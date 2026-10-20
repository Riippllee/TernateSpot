
import { createClient } from "npm:@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const respond = (status: number, body: Record<string, unknown>) =>
    new Response(JSON.stringify(body), {
      status,
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",
      },
    });

  if (req.method !== "POST") {
    return respond(405, {
      error: "Method tidak diizinkan.",
    });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseUrl || !anonKey || !serviceRoleKey) {
    return respond(500, {
      error: "Konfigurasi Supabase server belum lengkap.",
    });
  }

  const authorization = req.headers.get("Authorization");

  if (!authorization?.startsWith("Bearer ")) {
    return respond(401, {
      error: "Sesi login diperlukan.",
    });
  }

  const callerClient = createClient(supabaseUrl, anonKey, {
    global: {
      headers: { Authorization: authorization },
    },
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });

  const adminClient = createClient(supabaseUrl, serviceRoleKey, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });

  try {
    // 1. Verifikasi identitas pemanggil.
    const {
      data: { user: caller },
      error: callerError,
    } = await callerClient.auth.getUser();

    if (callerError || !caller) {
      return respond(401, {
        error: "Sesi login tidak valid.",
      });
    }

    // 2. Pastikan pemanggil adalah admin aktif.
    const { data: adminProfile, error: adminProfileError } =
      await adminClient
        .from("user")
        .select("role, status")
        .eq("id_user", caller.id)
        .maybeSingle();

    if (
      adminProfileError ||
      !adminProfile ||
      adminProfile.role !== "admin" ||
      adminProfile.status !== true
    ) {
      return respond(403, {
        error: "Hanya admin aktif yang boleh menghapus pengguna.",
      });
    }

    // 3. Ambil ID pengguna target.
    const body = await req.json();
    const userId =
      typeof body.userId === "string" ? body.userId.trim() : "";

    if (!userId) {
      return respond(400, {
        error: "ID pengguna wajib diisi.",
      });
    }

    // Admin tidak boleh menghapus akunnya sendiri.
    if (userId === caller.id) {
      return respond(403, {
        error: "Admin tidak dapat menghapus akun sendiri.",
      });
    }

    // 4. Pastikan target memiliki profil dengan role user.
    const { data: targetProfile, error: targetError } =
      await adminClient
        .from("user")
        .select("id_user, role")
        .eq("id_user", userId)
        .maybeSingle();

    if (targetError) {
      console.error("Gagal memeriksa target:", targetError.message);
      return respond(500, {
        error: "Gagal memeriksa data pengguna.",
      });
    }

    if (!targetProfile) {
      return respond(404, {
        error: "Profil pengguna tidak ditemukan.",
      });
    }

    if (targetProfile.role !== "user") {
      return respond(403, {
        error: "Hanya akun dengan role user yang boleh dihapus.",
      });
    }

    // 5. Hapus profil terlebih dahulu.
    // Jika gagal, akun Authentication belum dihapus.
    const { data: deletedProfiles, error: deleteProfileError } =
      await adminClient
        .from("user")
        .delete()
        .eq("id_user", userId)
        .select("id_user");

    if (deleteProfileError) {
      console.error(
        "Gagal menghapus profil:",
        deleteProfileError.message,
      );

      return respond(500, {
        error: "Gagal menghapus profil pengguna.",
      });
    }

    if (!deletedProfiles || deletedProfiles.length === 0) {
      return respond(500, {
        error: "Profil tidak terhapus. Periksa kebijakan database.",
      });
    }

    // 6. Hapus akun Authentication.
    const { error: deleteAuthError } =
      await adminClient.auth.admin.deleteUser(userId);

    if (deleteAuthError) {
      console.error(
        "Gagal menghapus akun Authentication:",
        deleteAuthError.message,
      );

      // Profil telah dihapus, tetapi akun Auth mungkin masih ada.
      // Laporkan kondisi ini agar dapat ditangani.
      return respond(500, {
        error:
          "Profil terhapus, tetapi akun Authentication gagal dihapus. " +
          "Periksa log server dan lakukan rekonsiliasi akun.",
      });
    }

    return respond(200, {
      success: true,
      message: "Pengguna berhasil dihapus.",
      userId,
    });
  } catch (error) {
    console.error("delete-user error:", error);

    return respond(500, {
      error: "Terjadi kesalahan pada server.",
    });
  }
});
