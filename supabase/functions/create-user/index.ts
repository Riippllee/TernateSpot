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
    return respond(405, { error: "Method tidak diizinkan." });
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

  if (!supabaseUrl || !anonKey || !serviceRoleKey) {
    return respond(500, { error: "Konfigurasi server belum lengkap." });
  }

  const authorization = req.headers.get("Authorization");

  if (!authorization?.startsWith("Bearer ")) {
    return respond(401, { error: "Sesi login diperlukan." });
  }

  // Client pengguna: memverifikasi identitas admin yang memanggil fungsi.
  const callerClient = createClient(supabaseUrl, anonKey, {
    global: { headers: { Authorization: authorization } },
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // Client server: hanya digunakan di Edge Function.
  const adminClient = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  try {
    const {
      data: { user: caller },
      error: callerError,
    } = await callerClient.auth.getUser();

    if (callerError || !caller) {
      return respond(401, { error: "Sesi login tidak valid." });
    }

    const { data: profile, error: profileError } = await adminClient
      .from("user")
      .select("role, status")
      .eq("id_user", caller.id)
      .maybeSingle();

    if (
      profileError ||
      !profile ||
      profile.role !== "admin" ||
      profile.status !== true
    ) {
      return respond(403, {
        error: "Hanya admin aktif yang boleh menambah pengguna.",
      });
    }

    const body = await req.json();
    const nama = typeof body.nama === "string" ? body.nama.trim() : "";
    const email =
      typeof body.email === "string" ? body.email.trim().toLowerCase() : "";
    const password = typeof body.password === "string" ? body.password : "";

    if (!nama || !email || !email.includes("@")) {
      return respond(400, { error: "Nama dan email harus valid." });
    }

    if (password.length < 8) {
      return respond(400, {
        error: "Password sementara minimal 8 karakter.",
      });
    }

    // Role tidak diterima dari aplikasi. Akun baru selalu role user.
    const { data: created, error: createError } =
      await adminClient.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
        user_metadata: { nama },
      });

    if (createError || !created.user) {
      return respond(400, {
        error: createError?.message ?? "Gagal membuat akun Authentication.",
      });
    }

    const newUser = created.user;
    const now = new Date().toISOString();

    const { error: insertError } = await adminClient.from("user").insert({
      id_user: newUser.id,
      nama,
      email,
      role: "user",
      status: true,
      tanggal_daftar: now,
      tanggal_perubahan: now,
    });

    if (insertError) {
      // Batalkan akun Auth jika pembuatan profil gagal.
      const { error: rollbackError } = await adminClient.auth.admin.deleteUser(
        newUser.id,
      );

      if (rollbackError) {
        console.error("Rollback akun gagal:", rollbackError.message);
      }

      console.error("Pembuatan profil gagal:", insertError.message);
      return respond(500, {
        error: "Profil pengguna gagal dibuat. Akun tidak dapat diselesaikan.",
      });
    }

    return respond(201, {
      message: "Pengguna berhasil dibuat.",
      user: {
        id_user: newUser.id,
        nama,
        email,
        role: "user",
        status: true,
      },
    });
  } catch (error) {
    console.error("create-user error:", error);
    return respond(500, { error: "Terjadi kesalahan pada server." });
  }
});
