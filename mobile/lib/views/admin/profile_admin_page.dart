
import 'package:flutter/material.dart';

const Color warnaLatar = Color(0xFFF5F7FC);
const Color warnaBiru = Color(0xFF246BFD);
const Color warnaTeks = Color(0xFF1D2939);
const Color warnaAbu = Color(0xFF667085);
const Color warnaGaris = Color(0xFFE5EAF2);

class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({super.key});

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

class _ProfileAdminPageState extends State<ProfileAdminPage> {
  bool modeGelap = false;
  bool notifikasiAktif = true;
  int menuAktif = 4;

  void tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaLatar,

      // Header logo aplikasi sudah dihapus.
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profil Admin',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: warnaTeks,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Kelola informasi dan pengaturan akun administrator.',
                style: TextStyle(fontSize: 12, color: warnaAbu),
              ),
              const SizedBox(height: 18),

              // Kartu profil admin sesuai desain gambar.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1760D2),
                      Color(0xFF0645A5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status dan tombol edit.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle,
                                color: Color(0xFF78F0B0),
                                size: 7,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'AKTIF / ON DUTY',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            tampilkanPesan(
                              'Fitur edit profil belum dihubungkan.',
                            );
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.20),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Foto dan identitas administrator.
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white70,
                              width: 1.5,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/admin.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.white24,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Super Administrator',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.white70,
                                    size: 11,
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'ID: ADM-TERNATE-001',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 9,
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
                    const SizedBox(height: 12),

                    // Email administrator.
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.alternate_email,
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'admin@ternatespot.com',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Statistik kinerja dan sistem.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Kinerja & Integritas Sistem',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: warnaTeks,
                      ),
                    ),
                  ),
                  Text(
                    'Real-time',
                    style: TextStyle(
                      color: warnaBiru,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.55,
                children: const [
                  KartuStatistik(
                    ikon: Icons.place_outlined,
                    angka: '24',
                    judul: 'Destinasi Dikelola',
                    warnaIkon: Color(0xFF246BFD),
                  ),
                  KartuStatistik(
                    ikon: Icons.people_outline,
                    angka: '142',
                    judul: 'User Dimoderasi',
                    warnaIkon: Color(0xFF12A878),
                  ),
                  KartuStatistik(
                    ikon: Icons.monitor_heart_outlined,
                    angka: '99,8%',
                    judul: 'System Uptime',
                    warnaIkon: Color(0xFF8B5CF6),
                  ),
                  KartuStatistik(
                    ikon: Icons.access_time,
                    angka: '14:32 WIT',
                    judul: 'Terakhir Login',
                    warnaIkon: Color(0xFFF59E0B),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Menu otoritas dan pengelolaan akun.
              const Text(
                'Otoritas & Manajemen Akun',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: warnaTeks,
                ),
              ),
              const SizedBox(height: 12),

              KartuMenuAdmin(
                ikon: Icons.admin_panel_settings_outlined,
                judul: 'Hak Akses & Otoritas',
                deskripsi: 'Pengaturan peran dan hak akses admin',
                onTap: () {
                  tampilkanPesan('Menu Hak Akses dipilih.');
                },
              ),
              const SizedBox(height: 10),

              KartuMenuAdmin(
                ikon: Icons.history,
                judul: 'Aktivitas & Log Sistem',
                deskripsi: 'Riwayat aktivitas administrator',
                onTap: () {
                  tampilkanPesan('Menu Aktivitas dipilih.');
                },
              ),
              const SizedBox(height: 10),

              KartuMenuAdmin(
                ikon: Icons.security_outlined,
                judul: 'Keamanan & Akun',
                deskripsi: 'Ganti Password • 2FA Aktif',
                onTap: () {
                  tampilkanPesan(
                    'Pengaturan keamanan belum dihubungkan.',
                  );
                },
              ),

              const SizedBox(height: 24),

              // Preferensi sistem dan aplikasi.
              const Text(
                'Preferensi Sistem & Aplikasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: warnaTeks,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: warnaGaris),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(
                        Icons.dark_mode_outlined,
                        color: warnaBiru,
                      ),
                      title: const Text(
                        'Mode Tampilan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: const Text(
                        'Aktifkan mode gelap',
                        style: TextStyle(fontSize: 11),
                      ),
                      value: modeGelap,
                      activeColor: warnaBiru,
                      onChanged: (nilai) {
                        setState(() {
                          modeGelap = nilai;
                        });
                        tampilkanPesan(
                          nilai
                              ? 'Mode gelap dipilih.'
                              : 'Mode terang dipilih.',
                        );
                      },
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(
                        Icons.notifications_active_outlined,
                        color: warnaBiru,
                      ),
                      title: const Text(
                        'Notifikasi Kejadian',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      subtitle: const Text(
                        '3 notifikasi tertunda',
                        style: TextStyle(fontSize: 11),
                      ),
                      value: notifikasiAktif,
                      activeColor: warnaBiru,
                      onChanged: (nilai) {
                        setState(() {
                          notifikasiAktif = nilai;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

    );
  }
}

// Widget kartu statistik.
class KartuStatistik extends StatelessWidget {
  final IconData ikon;
  final String angka;
  final String judul;
  final Color warnaIkon;

  const KartuStatistik({
    super.key,
    required this.ikon,
    required this.angka,
    required this.judul,
    required this.warnaIkon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: warnaGaris),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, color: warnaIkon, size: 24),
          const SizedBox(height: 7),
          Text(
            angka,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: warnaTeks,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            judul,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: warnaAbu,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget kartu menu admin.
class KartuMenuAdmin extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String deskripsi;
  final VoidCallback onTap;

  const KartuMenuAdmin({
    super.key,
    required this.ikon,
    required this.judul,
    required this.deskripsi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: warnaGaris),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: warnaBiru.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  ikon,
                  color: warnaBiru,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      style: const TextStyle(
                        color: warnaTeks,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deskripsi,
                      style: const TextStyle(
                        color: warnaAbu,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: warnaAbu,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
