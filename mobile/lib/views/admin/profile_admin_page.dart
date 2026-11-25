import 'package:flutter/material.dart';

class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({super.key});

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  static const Color biruUtama = Color(0xFF2563EB);
  static const Color biruGelap = Color(0xFF0A58CA);
  static const Color latar = Color(0xFFF4F7FB);
  static const Color teksUtama = Color(0xFF0F172A);
  static const Color teksSekunder = Color(0xFF64748B);

  String namaAdmin = 'Admin';
  String emailAdmin = 'admin@ternatespot.com';
  bool adaAktivitasBaru = true;

  void _editProfil() {
    final namaCtrl = TextEditingController(text: namaAdmin);
    final emailCtrl = TextEditingController(text: emailAdmin);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 12, 16, 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF084298), biruGelap, biruUtama],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.manage_accounts_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Edit Profil Admin',
                                  style: TextStyle(
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Perbarui nama & email administrator',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFDBEAFE),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.verified_user_rounded,
                              size: 18,
                              color: biruUtama,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Peran: Super Administrator (Level 1)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: biruGelap,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nama Tampilan',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: teksUtama,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: namaCtrl,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: teksUtama,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Masukkan nama administrator',
                          prefixIcon: const Icon(
                            Icons.person_outline_rounded,
                            color: biruUtama,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: biruUtama,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Email Administrator',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: teksUtama,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: teksUtama,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Masukkan email aktif',
                          prefixIcon: const Icon(
                            Icons.alternate_email_rounded,
                            color: biruUtama,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: Color(0xFFE2E8F0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: biruUtama,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: teksSekunder,
                                  side: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                                child: const Text(
                                  'Batal',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (namaCtrl.text.trim().isEmpty ||
                                      emailCtrl.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Nama dan email tidak boleh kosong.',
                                        ),
                                        backgroundColor: Color(0xFFDC2626),
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    namaAdmin = namaCtrl.text.trim();
                                    emailAdmin = emailCtrl.text.trim();
                                  });
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Profil administrator berhasil diperbarui.',
                                      ),
                                      backgroundColor: Color(0xFF16A34A),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: 19,
                                ),
                                label: const Text(
                                  'Simpan Perubahan',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: biruUtama,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _konfirmasiKeluar() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Keluar dari Akun?',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Sesi administrator saat ini akan diakhiri. Anda harus masuk kembali untuk mengakses panel admin.',
          style: TextStyle(fontSize: 13.5, color: teksSekunder),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesi administrator telah diakhiri.'),
                  backgroundColor: Color(0xFFDC2626),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _tampilkanTentang(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.explore_rounded,
                size: 34,
                color: biruUtama,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'TernateSpot',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: teksUtama,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Versi 1.0.0 • Build 2026.11',
              style: TextStyle(fontSize: 12, color: teksSekunder),
            ),
            const SizedBox(height: 14),
            const Text(
              'Sistem informasi pariwisata Kota Ternate untuk mempermudah pengelolaan destinasi wisata dan moderasi ulasan pengunjung.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pengembang', style: TextStyle(fontSize: 12.5, color: teksSekunder)),
                      Text('Tim TernateSpot', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Institusi', style: TextStyle(fontSize: 12.5, color: teksSekunder)),
                      Text('Universitas Khairun', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: biruUtama,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: latar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildStatistik(),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                'PENGATURAN & INFORMASI',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: teksSekunder,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildMenuPengaturan(),
            const SizedBox(height: 16),
            _buildTombolKeluar(),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'TernateSpot Administrator • ID: ADM-TERNATE-001',
                style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 175,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 52, 22, 20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF084298), biruGelap, biruUtama],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profil Admin',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              SizedBox(height: 4),
              Text(
                'Pusat kendali akun administrator',
                style: TextStyle(fontSize: 13, color: Color(0xFFDBEAFE)),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 122, 20, 0),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF93C5FD), width: 2),
                      ),
                      child: const Icon(Icons.person_rounded, size: 34, color: biruUtama),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                namaAdmin,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: teksUtama),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.verified_rounded, color: biruUtama, size: 17),
                            ],
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Super Administrator',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: biruUtama),
                          ),
                          const SizedBox(height: 2),
                          Text(emailAdmin, style: const TextStyle(fontSize: 12, color: teksSekunder)),
                        ],
                      ),
                    ),
                    Material(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: _editProfil,
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.all(9),
                          child: Icon(Icons.edit_outlined, size: 19, color: biruUtama),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: Color(0xFF16A34A)),
                        SizedBox(width: 6),
                        Text(
                          'AKTIF / ON DUTY',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A34A),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Akses Penuh • Level 1',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: teksSekunder),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistik() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                children: [
                  Text('24', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: biruUtama)),
                  SizedBox(height: 3),
                  Text('Destinasi', style: TextStyle(fontSize: 12, color: teksSekunder)),
                ],
              ),
            ),
            Container(width: 1, height: 34, color: const Color(0xFFE2E8F0)),
            const Expanded(
              child: Column(
                children: [
                  Text('142', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: biruUtama)),
                  SizedBox(height: 3),
                  Text('Ulasan', style: TextStyle(fontSize: 12, color: teksSekunder)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuPengaturan() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            _menuItem(
              ikon: Icons.lock_outline_rounded,
              warnaIkon: const Color(0xFF2563EB),
              bgIkon: const Color(0xFFEFF6FF),
              judul: 'Keamanan & Password',
              subjudul: 'Proteksi akun & autentikasi',
              badge: '2FA Aktif',
              warnaBadge: const Color(0xFF16A34A),
              bgBadge: const Color(0xFFDCFCE7),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const KeamananPasswordAdminPage()),
              ),
            ),
            const Divider(height: 1, indent: 72, endIndent: 18, color: Color(0xFFF1F5F9)),
            _menuItem(
              ikon: Icons.history_rounded,
              warnaIkon: const Color(0xFF7C3AED),
              bgIkon: const Color(0xFFF5F3FF),
              judul: 'Riwayat Aktivitas',
              subjudul: 'Log perubahan & moderasi',
              badge: adaAktivitasBaru ? 'Baru' : 'Terlihat',
              warnaBadge: adaAktivitasBaru ? const Color(0xFF2563EB) : const Color(0xFF64748B),
              bgBadge: adaAktivitasBaru ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
              onTap: () {
                setState(() => adaAktivitasBaru = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RiwayatAktivitasAdminPage()),
                );
              },
            ),
            const Divider(height: 1, indent: 72, endIndent: 18, color: Color(0xFFF1F5F9)),
            _menuItem(
              ikon: Icons.info_outline_rounded,
              warnaIkon: const Color(0xFF0D9488),
              bgIkon: const Color(0xFFF0FDFA),
              judul: 'Tentang TernateSpot',
              subjudul: 'Informasi sistem & pengembang',
              badge: 'v1.0.0',
              warnaBadge: const Color(0xFF475569),
              bgBadge: const Color(0xFFF1F5F9),
              onTap: () => _tampilkanTentang(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData ikon,
    required Color warnaIkon,
    required Color bgIkon,
    required String judul,
    required String subjudul,
    required String badge,
    required Color warnaBadge,
    required Color bgBadge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: bgIkon, borderRadius: BorderRadius.circular(13)),
                child: Icon(ikon, color: warnaIkon, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(judul, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: teksUtama)),
                    const SizedBox(height: 2),
                    Text(subjudul, style: const TextStyle(fontSize: 12, color: teksSekunder)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: bgBadge, borderRadius: BorderRadius.circular(20)),
                child: Text(badge, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: warnaBadge)),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTombolKeluar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: _konfirmasiKeluar,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626), size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Keluar dari Akun', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFFDC2626))),
                      SizedBox(height: 2),
                      Text('Akhiri sesi administrator saat ini', style: TextStyle(fontSize: 11.5, color: Color(0xFFEF4444))),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Color(0xFFF87171), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================================
// HALAMAN 1: KEAMANAN & PASSWORD ADMIN
// =========================================================================
class KeamananPasswordAdminPage extends StatefulWidget {
  const KeamananPasswordAdminPage({super.key});

  @override
  State<KeamananPasswordAdminPage> createState() => _KeamananPasswordAdminPageState();
}

class _KeamananPasswordAdminPageState extends State<KeamananPasswordAdminPage> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _hideOld = true;
  bool _hideNew = true;
  bool _hideConfirm = true;
  bool _is2fa = true;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (_oldCtrl.text.isEmpty || _newCtrl.text.isEmpty || _confirmCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom password.'), backgroundColor: Color(0xFFDC2626)),
      );
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password baru tidak cocok.'), backgroundColor: Color(0xFFDC2626)),
      );
      return;
    }
    _oldCtrl.clear();
    _newCtrl.clear();
    _confirmCtrl.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password administrator berhasil diperbarui.'), backgroundColor: Color(0xFF16A34A)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 165,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(8, 44, 20, 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF084298), Color(0xFF0A58CA), Color(0xFF2563EB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Keamanan & Password', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white)),
                              SizedBox(height: 2),
                              Text('Kelola proteksi akun administrator', style: TextStyle(fontSize: 12.5, color: Color(0xFFDBEAFE))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 118, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _is2fa ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _is2fa ? Icons.verified_user_rounded : Icons.gpp_maybe_rounded,
                            color: _is2fa ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Autentikasi 2FA', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _is2fa ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _is2fa ? 'Aktif' : 'Nonaktif',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: _is2fa ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              const Text('Kode OTP dikirim ke email admin saat login baru.', style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Switch(
                          value: _is2fa,
                          activeThumbColor: Colors.white,
                          activeTrackColor: const Color(0xFF2563EB),
                          onChanged: (v) => setState(() => _is2fa = v),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text('UBAH KATA SANDI', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8)),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inputSandi(_oldCtrl, 'Password Saat Ini', _hideOld, () => setState(() => _hideOld = !_hideOld)),
                    const SizedBox(height: 12),
                    _inputSandi(_newCtrl, 'Password Baru', _hideNew, () => setState(() => _hideNew = !_hideNew)),
                    const SizedBox(height: 12),
                    _inputSandi(_confirmCtrl, 'Konfirmasi Password Baru', _hideConfirm, () => setState(() => _hideConfirm = !_hideConfirm)),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 14, color: Color(0xFF64748B)),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text('Gunakan minimal 8 karakter dengan kombinasi huruf & angka.', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton.icon(
                        onPressed: _simpan,
                        icon: const Icon(Icons.lock_reset_rounded, size: 20),
                        label: const Text('Perbarui Password', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text('PERANGKAT & SESI AKTIF', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.8)),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.smartphone_rounded, color: Color(0xFF2563EB), size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pixel 5 • Android Emulator', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                          SizedBox(height: 2),
                          Text('Ternate, Maluku Utara • Aktif sekarang', style: TextStyle(fontSize: 11.5, color: Color(0xFF16A34A), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                      child: const Text('Utama', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF475569))),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _inputSandi(TextEditingController ctrl, String label, bool hide, VoidCallback onTapEye) {
    return TextField(
      controller: ctrl,
      obscureText: hide,
      style: const TextStyle(fontSize: 13.5),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 19, color: Color(0xFF64748B)),
        suffixIcon: IconButton(
          icon: Icon(hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 19, color: const Color(0xFF64748B)),
          onPressed: onTapEye,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5)),
      ),
    );
  }
}

// =========================================================================
// HALAMAN 2: RIWAYAT AKTIVITAS ADMIN
// =========================================================================
class RiwayatAktivitasAdminPage extends StatefulWidget {
  const RiwayatAktivitasAdminPage({super.key});

  @override
  State<RiwayatAktivitasAdminPage> createState() => _RiwayatAktivitasAdminPageState();
}

class _RiwayatAktivitasAdminPageState extends State<RiwayatAktivitasAdminPage> {
  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    final semuaLog = [
      ['Menyetujui Ulasan Pengunjung', 'Ulasan pada Pantai Sulamadaha dipublikasikan.', 'Ulasan', '10 menit lalu', Icons.rate_review_rounded, const Color(0xFF16A34A), const Color(0xFFDCFCE7)],
      ['Memperbarui Data Destinasi', 'Mengubah informasi jam buka Benteng Oranje.', 'Destinasi', '1 jam lalu', Icons.edit_location_alt_rounded, const Color(0xFF2563EB), const Color(0xFFDBEAFE)],
      ['Menambahkan Destinasi Baru', 'Menambahkan Danau Tolire Besar ke katalog.', 'Destinasi', '3 jam lalu', Icons.add_location_alt_rounded, const Color(0xFF7C3AED), const Color(0xFFEDE9FE)],
      ['Verifikasi Akun Pengguna', 'Mengaktifkan akun kontributor wisata lokal.', 'Pengguna', 'Kemarin', Icons.verified_user_rounded, const Color(0xFFD97706), const Color(0xFFFEF3C7)],
    ];

    final tampil = _filter == 'Semua' ? semuaLog : semuaLog.where((e) => e[2] == _filter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 44, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF084298), Color(0xFF0A58CA), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Riwayat Aktivitas', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Colors.white)),
                          SizedBox(height: 2),
                          Text('Log perubahan data & moderasi sistem', style: TextStyle(fontSize: 12.5, color: Color(0xFFDBEAFE))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Semua', 'Destinasi', 'Ulasan', 'Pengguna'].map((kat) {
                        final aktif = _filter == kat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => setState(() => _filter = kat),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: aktif ? Colors.white : Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                kat,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: aktif ? const Color(0xFF0A58CA) : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: tampil.length,
              itemBuilder: (ctx, i) {
                final item = tampil[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(color: item[6] as Color, borderRadius: BorderRadius.circular(13)),
                        child: Icon(item[4] as IconData, color: item[5] as Color, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(item[0] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF0F172A)))),
                                Text(item[3] as String, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(item[1] as String, style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.35)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}