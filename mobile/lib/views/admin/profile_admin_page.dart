import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ternatespot/views/auth/login_page.dart';

const Color warnaLatar = Color(0xFFF3F6FC);
const Color warnaBiruUtama = Color(0xFF155EEF);
const Color warnaBiruGelap = Color(0xFF002B80);
const Color warnaTeksUtama = Color(0xFF101828);
const Color warnaTeksAbu = Color(0xFF667085);
const Color warnaGaris = Color(0xFFEAECF0);

class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({super.key});

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  String namaAdmin = 'Admin';
  String roleAdmin = 'Super Administrator';
  String emailAdmin = 'admin@ternatespot.com';
  String idAdmin = 'ADM-TERNATE-001';

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _konfirmasiLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar dari Akun?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        content: const Text(
          'Sesi administrator Anda akan diakhiri. Anda perlu masuk kembali untuk mengelola TernateSpot.',
          style: TextStyle(fontSize: 13.5, color: warnaTeksAbu),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: warnaTeksAbu)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD92D20),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              await Supabase.instance.client.auth.signOut();

              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaLatar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER LENGKUNG + FLOATING PROFILE CARD
            _buildHeaderDanKartuProfil(),

            // 2. KONTEN UTAMA
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BARIS RINGKASAN MINI (TANPA UPTIME)
                  _buildRingkasanMini(),
                  const SizedBox(height: 22),

                  // LABEL SECTION
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 10),
                    child: Text(
                      'PENGATURAN & INFORMASI',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: warnaTeksAbu,
                        letterSpacing: 0.9,
                      ),
                    ),
                  ),

                  // GRUP MENU UTAMA DENGAN STATUS BADGE
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: warnaGaris),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF101828).withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildItemMenu(
                          icon: Icons.lock_outline_rounded,
                          iconColor: warnaBiruUtama,
                          iconBg: const Color(0xFFEFF4FF),
                          title: 'Keamanan & Password',
                          subtitle: 'Proteksi akun & autentikasi',
                          badgeText: '2FA Aktif',
                          badgeBg: const Color(0xFFECFDF3),
                          badgeColor: const Color(0xFF067647),
                          onTap: () => _tampilkanPesan('Membuka Keamanan & Password'),
                        ),
                        const Divider(height: 1, color: warnaGaris, indent: 66, endIndent: 16),
                        _buildItemMenu(
                          icon: Icons.history_rounded,
                          iconColor: const Color(0xFF6938EF),
                          iconBg: const Color(0xFFF4F3FF),
                          title: 'Riwayat Aktivitas',
                          subtitle: 'Log perubahan & moderasi',
                          badgeText: 'Baru',
                          badgeBg: const Color(0xFFEFF4FF),
                          badgeColor: warnaBiruUtama,
                          onTap: () => _tampilkanPesan('Membuka Riwayat Aktivitas'),
                        ),
                        const Divider(height: 1, color: warnaGaris, indent: 66, endIndent: 16),
                        _buildItemMenu(
                          icon: Icons.info_outline_rounded,
                          iconColor: const Color(0xFF0E9384),
                          iconBg: const Color(0xFFF0FDF9),
                          title: 'Tentang TernateSpot',
                          subtitle: 'Informasi sistem & pengembang',
                          badgeText: 'v1.0.0',
                          badgeBg: const Color(0xFFF2F4F7),
                          badgeColor: warnaTeksAbu,
                          onTap: () => _tampilkanPesan('TernateSpot Admin Portal v1.0.0'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TOMBOL KELUAR DARI AKUN
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFEE4E2)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD92D20).withOpacity(0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _buildItemMenu(
                      icon: Icons.logout_rounded,
                      iconColor: const Color(0xFFD92D20),
                      iconBg: const Color(0xFFFEF3F2),
                      title: 'Keluar dari Akun',
                      titleColor: const Color(0xFFD92D20),
                      subtitle: 'Akhiri sesi administrator saat ini',
                      chevronColor: const Color(0xFFD92D20).withOpacity(0.6),
                      onTap: _konfirmasiLogout,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // FOOTER ID ADMIN
                  Center(
                    child: Text(
                      'TernateSpot Administrator • ID: $idAdmin',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF98A2B3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderDanKartuProfil() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Latar Biru Lengkung di Bagian Atas
        Container(
          height: 215,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1E68F6),
                warnaBiruGelap,
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -20,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
              Positioned(
                left: -40,
                bottom: 10,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Isi Header + Kartu Putih Melayang
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profil Admin',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pusat kendali akun administrator',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withOpacity(0.82),
                  ),
                ),
                const SizedBox(height: 20),

                // Kartu Profil Putih Melayang
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: warnaGaris),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF002B80).withOpacity(0.10),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar dengan Ring Gradien
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF2E90FA), warnaBiruUtama],
                              ),
                            ),
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFEFF4FF),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: warnaBiruUtama,
                                size: 32,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Info Nama, Role, dan Email
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      namaAdmin,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: warnaTeksUtama,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.verified_rounded,
                                      color: warnaBiruUtama,
                                      size: 17,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  roleAdmin,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: warnaBiruUtama,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  emailAdmin,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: warnaTeksAbu,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tombol Edit Profil di dalam kartu putih
                          Material(
                            color: const Color(0xFFEFF4FF),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _tampilkanPesan('Edit Profil Admin'),
                              child: const Padding(
                                padding: EdgeInsets.all(9),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color: warnaBiruUtama,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: warnaGaris),
                      const SizedBox(height: 12),

                      // Baris Status Akun di Bawah Kartu Profil
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF12B76A),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'AKTIF / ON DUTY',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF067647),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'Akses Penuh • Level 1',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: warnaTeksAbu,
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
        ),
      ],
    );
  }

  Widget _buildRingkasanMini() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: warnaGaris),
      ),
      child: Row(
        children: [
          _buildKolomStat('24', 'Destinasi', warnaBiruUtama),
          Container(width: 1, height: 28, color: warnaGaris),
          _buildKolomStat('142', 'Ulasan', const Color(0xFF6938EF)),
        ],
      ),
    );
  }

  Widget _buildKolomStat(String nilai, String label, Color warnaNilai) {
    return Expanded(
      child: Column(
        children: [
          Text(
            nilai,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: warnaNilai,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: warnaTeksAbu,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemMenu({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    Color titleColor = warnaTeksUtama,
    required String subtitle,
    String? badgeText,
    Color? badgeBg,
    Color? badgeColor,
    Color chevronColor = const Color(0xFF98A2B3),
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: warnaTeksAbu,
                    ),
                  ),
                ],
              ),
            ),
            if (badgeText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            Icon(Icons.chevron_right_rounded, color: chevronColor, size: 20),
          ],
        ),
      ),
    );
  }
}