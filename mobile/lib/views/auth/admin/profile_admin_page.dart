// Mengambil library Flutter untuk membuat tampilan aplikasi,
// seperti teks, tombol, ikon, warna, dan layout.
import 'package:flutter/material.dart';

// Kumpulan warna yang digunakan pada halaman Profil Admin.
const Color warnaLatar = Color(0xFFF5F7FC);
const Color warnaBiru = Color(0xFF246BFD);
const Color warnaTeks = Color(0xFF1D2939);
const Color warnaAbu = Color(0xFF667085);
const Color warnaGaris = Color(0xFFE5EAF2);

// Membuat halaman Profil Admin.
// StatefulWidget digunakan karena halaman ini memiliki
// beberapa nilai yang dapat berubah ketika pengguna berinteraksi.
class ProfileAdminPage extends StatefulWidget {
  const ProfileAdminPage({super.key});

  @override
  State<ProfileAdminPage> createState() => _ProfileAdminPageState();
}

// Menyimpan pengaturan dan mengatur tampilan halaman Profil Admin.
class _ProfileAdminPageState extends State<ProfileAdminPage> {
  // Menentukan apakah pilihan mode gelap sedang aktif.
  bool modeGelap = false;

  // Menentukan apakah notifikasi sedang diaktifkan.
  bool notifikasiAktif = true;

  // Menentukan menu navigasi bawah yang sedang dipilih.
  // Angka 4 menunjukkan menu Profil.
  int menuAktif = 4;

  // Fungsi untuk menampilkan pesan singkat di bagian bawah layar.
  // Pesan ini digunakan ketika pengguna memilih suatu menu.
  void tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(pesan)),
    );
  }

  // Fungsi build menyusun seluruh tampilan halaman Profil Admin.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Memberikan warna latar belakang pada halaman.
      backgroundColor: warnaLatar,

      // Header logo aplikasi tidak ditampilkan pada halaman ini.
      body: SafeArea(
        // Memungkinkan halaman digulir jika isinya melebihi layar.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            // Semua bagian halaman disusun dari atas ke bawah.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan judul utama halaman.
              const Text(
                'Profil Admin',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: warnaTeks,
                ),
              ),

              // Memberikan jarak antara judul dan deskripsi.
              const SizedBox(height: 5),

              // Menampilkan penjelasan singkat halaman.
              const Text(
                'Kelola informasi dan pengaturan akun administrator.',
                style: TextStyle(fontSize: 12, color: warnaAbu),
              ),

              const SizedBox(height: 18),

              // Membuat kartu profil dengan latar gradasi biru.
              Container(
                // Kartu menggunakan seluruh lebar yang tersedia.
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  // Menggabungkan dua warna biru menjadi gradasi.
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1760D2),
                      Color(0xFF0645A5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  // Membuat sudut kartu melengkung.
                  borderRadius: BorderRadius.circular(14),

                  // Memberikan bayangan pada kartu profil.
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                // Menyusun isi kartu dari atas ke bawah.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Baris pertama berisi status dan tombol edit profil.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Menampilkan label status administrator.
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            // Membuat latar label transparan.
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Titik hijau sebagai tanda status aktif.
                              Icon(
                                Icons.circle,
                                color: Color(0xFF78F0B0),
                                size: 7,
                              ),
                              SizedBox(width: 5),

                              // Tulisan status administrator.
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

                        // Tombol edit profil.
                        // Saat ini tombol hanya menampilkan pesan,
                        // belum mengubah data profil.
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

                    // Menampilkan foto dan informasi administrator.
                    Row(
                      children: [
                        // Memuat foto admin dari folder assets/images.
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

                              // Jika foto gagal dimuat, tampilkan ikon orang.
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

                        // Menampilkan nama, jabatan, dan ID administrator.
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama administrator.
                              Text(
                                'Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),

                              // Jabatan administrator.
                              Text(
                                'Super Administrator',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(height: 3),

                              // Menampilkan ID khusus administrator.
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

                    // Menampilkan alamat email administrator.
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

              // Bagian statistik yang menunjukkan informasi sistem.
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

                  // Label pembaruan statistik.
                  // Angka yang ditampilkan masih berupa contoh.
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

              // Menyusun empat kartu statistik dalam dua kolom.
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,

                // Grid tidak digulir sendiri karena halaman utama
                // sudah menggunakan SingleChildScrollView.
                physics: const NeverScrollableScrollPhysics(),

                // Mengatur jarak antarkartu.
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,

                // Mengatur perbandingan lebar dan tinggi kartu.
                childAspectRatio: 1.55,

                // Data yang ditampilkan pada kartu statistik.
                // Nilai berikut masih ditulis langsung dalam kode.
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

              // Judul bagian pengelolaan hak akses dan akun.
              const Text(
                'Otoritas & Manajemen Akun',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: warnaTeks,
                ),
              ),

              const SizedBox(height: 12),

              // Menu untuk pengaturan peran dan hak akses admin.
              KartuMenuAdmin(
                ikon: Icons.admin_panel_settings_outlined,
                judul: 'Hak Akses & Otoritas',
                deskripsi: 'Pengaturan peran dan hak akses admin',
                onTap: () {
                  // Menampilkan pesan ketika menu ditekan.
                  tampilkanPesan('Menu Hak Akses dipilih.');
                },
              ),

              const SizedBox(height: 10),

              // Menu untuk aktivitas dan riwayat sistem.
              KartuMenuAdmin(
                ikon: Icons.history,
                judul: 'Aktivitas & Log Sistem',
                deskripsi: 'Riwayat aktivitas administrator',
                onTap: () {
                  tampilkanPesan('Menu Aktivitas dipilih.');
                },
              ),

              const SizedBox(height: 10),

              // Menu untuk pengaturan keamanan akun.
              KartuMenuAdmin(
                ikon: Icons.security_outlined,
                judul: 'Keamanan & Akun',
                deskripsi: 'Ganti Password • 2FA Aktif',
                onTap: () {
                  // Pengaturan keamanan belum terhubung ke fitur asli.
                  tampilkanPesan(
                    'Pengaturan keamanan belum dihubungkan.',
                  );
                },
              ),

              const SizedBox(height: 24),

              // Judul bagian pengaturan tampilan dan notifikasi.
              const Text(
                'Preferensi Sistem & Aplikasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: warnaTeks,
                ),
              ),

              const SizedBox(height: 12),

              // Kotak yang menampung pengaturan aplikasi.
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
                    // Switch untuk memilih mode tampilan.
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

                      // Menentukan posisi switch berdasarkan variabel.
                      value: modeGelap,
                      activeColor: warnaBiru,

                      // Dijalankan ketika pengguna mengubah posisi switch.
                      onChanged: (nilai) {
                        setState(() {
                          // Menyimpan pilihan mode tampilan sementara.
                          modeGelap = nilai;
                        });

                        // Memberi tahu pengguna mode yang dipilih.
                        tampilkanPesan(
                          nilai
                              ? 'Mode gelap dipilih.'
                              : 'Mode terang dipilih.',
                        );
                      },
                    ),

                    // Garis pemisah antara dua pengaturan.
                    const Divider(height: 1),

                    // Switch untuk mengaktifkan atau menonaktifkan notifikasi.
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

                      // Menentukan apakah switch notifikasi aktif.
                      value: notifikasiAktif,
                      activeColor: warnaBiru,

                      onChanged: (nilai) {
                        setState(() {
                          // Menyimpan pilihan notifikasi sementara.
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

      // Navigasi yang ditampilkan di bagian bawah layar.
      bottomNavigationBar: BottomNavigationBar(
        // Semua menu ditampilkan dalam satu baris.
        type: BottomNavigationBarType.fixed,

        // Menentukan menu yang sedang dipilih.
        currentIndex: menuAktif,

        // Mengatur warna menu yang dipilih dan tidak dipilih.
        selectedItemColor: warnaBiru,
        unselectedItemColor: warnaAbu,
        backgroundColor: Colors.white,
        selectedFontSize: 11,
        unselectedFontSize: 10,

        // Fungsi yang dijalankan saat pengguna menekan menu.
        onTap: (index) {
          setState(() {
            // Memperbarui indeks menu yang dipilih.
            menuAktif = index;
          });

          // Daftar nama menu sesuai urutan navigasi.
          const namaMenu = [
            'Dashboard',
            'Destinasi',
            'Users',
            'Moderasi',
            'Profil',
          ];

          // Menu selain Profil belum terhubung ke halaman lain.
          if (index != 4) {
            tampilkanPesan(
              'Menu ${namaMenu[index]} belum dihubungkan.',
            );
          }
        },

        // Menentukan ikon dan label setiap menu navigasi.
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.place_outlined),
            label: 'Destinasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user_outlined),
            label: 'Moderasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Widget khusus untuk membuat kartu statistik.
// Dengan widget ini, desain kartu bisa digunakan berulang kali.
class KartuStatistik extends StatelessWidget {
  // Ikon yang ditampilkan pada kartu.
  final IconData ikon;

  // Angka atau nilai utama pada kartu.
  final String angka;

  // Keterangan dari angka statistik.
  final String judul;

  // Warna ikon pada kartu.
  final Color warnaIkon;

  // Menerima data yang diperlukan untuk membuat kartu statistik.
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
      // Memberikan jarak pada isi kartu.
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: warnaGaris),
      ),

      // Menyusun ikon, angka, dan keterangan secara vertikal.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Menampilkan ikon sesuai data yang diterima.
          Icon(ikon, color: warnaIkon, size: 24),
          const SizedBox(height: 7),

          // Menampilkan angka utama statistik.
          Text(
            angka,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: warnaTeks,
            ),
          ),

          const SizedBox(height: 3),

          // Menampilkan keterangan di bawah angka.
          // Teks dibatasi dua baris agar kartu tetap rapi.
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

// Widget untuk membuat kartu menu administrator.
// Digunakan pada menu Hak Akses, Aktivitas, dan Keamanan.
class KartuMenuAdmin extends StatelessWidget {
  // Ikon yang mewakili menu.
  final IconData ikon;

  // Nama menu yang ditampilkan.
  final String judul;

  // Penjelasan singkat tentang menu.
  final String deskripsi;

  // Fungsi yang dijalankan saat kartu ditekan.
  final VoidCallback onTap;

  // Menerima data yang diperlukan untuk membuat kartu menu.
  const KartuMenuAdmin({
    super.key,
    required this.ikon,
    required this.judul,
    required this.deskripsi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Material menyediakan dasar untuk efek sentuhan.
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),

      child: InkWell(
        // Menjalankan fungsi ketika kartu ditekan.
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),

        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: warnaGaris),
          ),

          // Menyusun ikon, teks, dan tanda panah dalam satu baris.
          child: Row(
            children: [
              // Kotak kecil sebagai latar ikon menu.
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

              // Memberikan ruang untuk judul dan deskripsi menu.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama menu.
                    Text(
                      judul,
                      style: const TextStyle(
                        color: warnaTeks,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Penjelasan singkat tentang menu.
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

              // Tanda panah yang menunjukkan kartu dapat ditekan.
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