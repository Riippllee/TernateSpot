
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function jsonResponse(
  body: Record<string, unknown>,
  status = 200,
) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return jsonResponse({ error: "Method not allowed" }, 405);
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get(
      "SUPABASE_SERVICE_ROLE_KEY",
    );

    if (!supabaseUrl || !serviceRoleKey) {
      console.error("Konfigurasi Supabase server belum lengkap.");
      return jsonResponse(
        { error: "Konfigurasi server belum lengkap." },
        500,
      );
    }

    // Client khusus server. Jangan pernah menaruh key ini di Flutter.
    const supabaseAdmin = createClient(
      supabaseUrl,
      serviceRoleKey,
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false,
        },
      },
    );

    // 1. Periksa token pengguna yang memanggil function.
    const authHeader = req.headers.get("Authorization");

    if (!authHeader?.startsWith("Bearer ")) {
      return jsonResponse(
        { error: "Session login diperlukan." },
        401,
      );
    }

    const token = authHeader.substring("Bearer ".length);

    const {
      data: { user: caller },
      error: authError,
    } = await supabaseAdmin.auth.getUser(token);

    if (authError || !caller) {
      return jsonResponse(
        { error: "Session tidak valid." },
        401,
      );
    }

    // 2. Periksa role dan status admin dari database.
    const { data: adminProfile, error: adminError } =
      await supabaseAdmin
        .from("user")
        .select("role, status")
        .eq("id_user", caller.id)
        .maybeSingle();

    if (
      adminError ||
      !adminProfile ||
      adminProfile.role !== "admin" ||
      adminProfile.status !== true
    ) {
      return jsonResponse(
        { error: "Hanya admin aktif yang boleh menghapus pengguna." },
        403,
      );
    }

    // 3. Validasi ID target.
    const body = await req.json();
    const userId = body.userId;

    if (
      typeof userId !== "string" ||
      !/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
        .test(userId)
    ) {
      return jsonResponse({ error: "UUID pengguna tidak valid." }, 400);
    }

    if (userId === caller.id) {
      return jsonResponse(
        { error: "Admin tidak boleh menghapus akun sendiri." },
        400,
      );
    }

    // 4. Pastikan target merupakan user biasa.
    const { data: targetProfile, error: targetError } =
      await supabaseAdmin
        .from("user")
        .select("id_user, role")
        .eq("id_user", userId)
        .maybeSingle();

    if (targetError) {
      console.error("Gagal memeriksa target:", targetError.message);
      return jsonResponse(
        { error: "Gagal memeriksa profil pengguna." },
        500,
      );
    }

    if (!targetProfile) {
      return jsonResponse(
        { error: "Profil pengguna tidak ditemukan." },
        404,
      );
    }

    if (targetProfile.role !== "user") {
      return jsonResponse(
        { error: "Hanya akun dengan role user yang boleh dihapus." },
        403,
      );
    }

    // 5. Hapus akun Auth terlebih dahulu.
    // Jika gagal, profil tidak dihapus oleh langkah berikutnya.
    const { error: deleteAuthError } =
      await supabaseAdmin.auth.admin.deleteUser(userId);

    if (deleteAuthError) {
      console.error(
        "Gagal menghapus akun Auth:",
        deleteAuthError.message,
      );

      return jsonResponse(
        { error: "Gagal menghapus akun Authentication." },
        500,
      );
    }

    // 6. Hapus profil jika tidak terhapus melalui foreign key cascade.
    const { error: deleteProfileError } = await supabaseAdmin
      .from("user")
      .delete()
      .eq("id_user", userId);

    if (deleteProfileError) {
      console.error(
        "Akun Auth terhapus, tetapi profil gagal dihapus:",
        deleteProfileError.message,
      );

      return jsonResponse(
        {
          error:
            "Akun Auth telah dihapus, tetapi profil perlu diperiksa.",
        },
        500,
      );
    }

    return jsonResponse({
      message: "Akun dan profil pengguna berhasil dihapus.",
      userId,
    });
  } catch (error) {
    console.error("Kesalahan delete-user:", error);

    return jsonResponse(
      { error: "Terjadi kesalahan pada server." },
      500,
    );
  }
});
