import 'package:flutter/material.dart';

// Warna utama aplikasi TernateSpot.
const Color warnaBiru = Color(0xFF0875F9);
const Color warnaLatar = Color(0xFFF5F7FC);
const Color warnaTeks = Color(0xFF202B3C);
const Color warnaAbu = Color(0xFF8A94A6);

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({super.key});

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  // Data profil yang dapat diubah pengguna.
  String nama = 'Rizky Maulana';
  String email = 'rizky.maulana@gmail.com';

  // Data statistik contoh.
  int jumlahDestinasi = 12;
  int jumlahFavorit = 5;
  int jumlahUlasan = 8;

  // Menyimpan destinasi favorit yang dipilih.
  final List<String> favorit = [
    'Pantai Sulamadaha',
    'Danau Tolire',
    'Benteng Tolukko',
    'Pantai Jikomalamo',
    'Batu Angus',
  ];

  // Menyimpan ulasan contoh.
  final List<String> ulasan = [
    'Pantai Sulamadaha - Tempatnya indah dan airnya jernih.',
    'Danau Tolire - Pemandangannya bagus untuk dikunjungi.',
    'Benteng Tolukko - Tempat bersejarah yang menarik.',
  ];

  // Indeks menu navigasi yang sedang dipilih.
  int menuAktif = 3;

  // Menampilkan pemberitahuan singkat.
  void pesan(String teks) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(teks),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Menampilkan dialog untuk suatu menu.
  void bukaDialog({
    required String judul,
    required Widget isi,
    List<Widget> aksi = const [],
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(judul),
        content: isi,
        actions: [
          ...aksi,
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Dialog untuk melihat statistik yang dipilih.
  void bukaStatistik(String jenis) {
    if (jenis == 'Destinasi') {
      bukaDialog(
        judul: 'Destinasi Dikunjungi',
        isi: Text(
          'Kamu sudah mencatat $jumlahDestinasi destinasi wisata. '
          'Ayo temukan tempat menarik lainnya di Ternate!',
        ),
      );
    } else if (jenis == 'Favorit') {
      bukaDialog(
        judul: 'Destinasi Favorit',
        isi: Text(
          'Kamu menyimpan ${favorit.length} destinasi favorit.',
        ),
        aksi: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              bukaFavorit();
            },
            child: const Text('Lihat Favorit'),
          ),
        ],
      );
    } else {
      bukaDialog(
        judul: 'Ulasan Saya',
        isi: Text(
          'Kamu telah membuat $jumlahUlasan ulasan. '
          'Terima kasih telah berbagi pengalaman wisata!',
        ),
        aksi: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              bukaUlasan();
            },
            child: const Text('Lihat Ulasan'),
          ),
        ],
      );
    }
  }

  // Dialog untuk mengubah nama dan email.
  void editProfil() {
    final namaController = TextEditingController(text: nama);
    final emailController = TextEditingController(text: email);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: 'Nama lengkap',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final namaBaru = namaController.text.trim();
              final emailBaru = emailController.text.trim();

              if (namaBaru.isEmpty ||
                  !emailBaru.contains('@') ||
                  !emailBaru.contains('.')) {
                pesan('Masukkan nama dan email yang valid.');
                return;
              }

              setState(() {
                nama = namaBaru;
                email = emailBaru;
              });

              Navigator.pop(dialogContext);
              pesan('Profil berhasil diperbarui pada tampilan ini.');
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Menampilkan daftar destinasi favorit.
  void bukaFavorit() {
    bukaDialog(
      judul: 'Destinasi Favorit',
      isi: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: favorit.map((item) {
            return ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: Text(item),
              onTap: () {
                Navigator.pop(context);
                pesan('Kamu memilih $item.');
              },
            );
          }).toList(),
        ),
      ),
      aksi: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            tambahFavorit();
          },
          child: const Text('Tambah Favorit'),
        ),
      ],
    );
  }

  // Contoh interaksi menambahkan destinasi favorit.
  // Dalam aplikasi nyata, pilihan destinasi diambil dari database.
  void tambahFavorit() {
    final controller = TextEditingController();

    bukaDialog(
      judul: 'Tambah Destinasi Favorit',
      isi: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Nama destinasi',
          hintText: 'Contoh: Pantai Kastela',
        ),
      ),
      aksi: [
        TextButton(
          onPressed: () {
            final teks = controller.text.trim();

            if (teks.isEmpty) {
              pesan('Nama destinasi belum diisi.');
              return;
            }

            setState(() {
              if (!favorit.contains(teks)) {
                favorit.add(teks);
              }
            });

            Navigator.pop(context);
            pesan('Destinasi ditambahkan ke daftar favorit.');
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  // Menampilkan daftar ulasan pengguna.
  void bukaUlasan() {
    bukaDialog(
      judul: 'Ulasan Saya',
      isi: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            ...ulasan.map(
              (item) => ListTile(
                leading: const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                title: Text(
                  item,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            if (ulasan.isEmpty)
              const Text('Belum ada ulasan.'),
          ],
        ),
      ),
      aksi: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            tambahUlasan();
          },
          child: const Text('Tulis Ulasan'),
        ),
      ],
    );
  }

  // Menambahkan ulasan baru ke daftar sementara.
  void tambahUlasan() {
    final controller = TextEditingController();

    bukaDialog(
      judul: 'Tulis Ulasan',
      isi: TextField(
        controller: controller,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Pengalaman wisata',
          hintText: 'Bagaimana pengalamanmu?',
          border: OutlineInputBorder(),
        ),
      ),
      aksi: [
        TextButton(
          onPressed: () {
            final teks = controller.text.trim();

            if (teks.isEmpty) {
              pesan('Tuliskan ulasan terlebih dahulu.');
              return;
            }

            setState(() {
              ulasan.insert(0, teks);
              jumlahUlasan++;
            });

            Navigator.pop(context);
            pesan('Ulasan ditambahkan pada tampilan ini.');
          },
          child: const Text('Kirim'),
        ),
      ],
    );
  }

  // Dialog riwayat kunjungan dan rencana perjalanan.
  void bukaRiwayat() {
    bukaDialog(
      judul: 'Riwayat Kunjungan & Rencana',
      isi: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Pantai Sulamadaha'),
            subtitle: Text('Riwayat kunjungan contoh'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month, color: warnaBiru),
            title: Text('Rencana ke Danau Tolire'),
            subtitle: Text('Jadwal perjalanan contoh'),
          ),
          ListTile(
            leading: Icon(Icons.explore, color: Colors.orange),
            title: Text('Jelajah Ternate'),
            subtitle: Text('Temukan tujuan wisata berikutnya'),
          ),
        ],
      ),
      aksi: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            pesan('Fitur rencana perjalanan belum tersambung.');
          },
          child: const Text('Buat Rencana'),
        ),
      ],
    );
  }

  // Pengaturan akun dan keamanan.
  void bukaPengaturan() {
    bukaDialog(
      judul: 'Pengaturan Akun & Keamanan',
      isi: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Edit profil'),
            onTap: () {
              Navigator.pop(context);
              editProfil();
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Ubah kata sandi'),
            onTap: () {
              Navigator.pop(context);
              ubahPassword();
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privasi'),
            onTap: () {
              Navigator.pop(context);
              bukaPrivasi();
            },
          ),
        ],
      ),
    );
  }

  // Dialog perubahan kata sandi.
  // Perubahan ini hanya simulasi, belum mengubah kata sandi akun asli.
  void ubahPassword() {
    final lama = TextEditingController();
    final baru = TextEditingController();

    bukaDialog(
      judul: 'Ubah Kata Sandi',
      isi: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: lama,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Kata sandi lama',
            ),
          ),
          TextField(
            controller: baru,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Kata sandi baru',
            ),
          ),
        ],
      ),
      aksi: [
        TextButton(
          onPressed: () {
            if (lama.text.isEmpty || baru.text.length < 6) {
              pesan('Isi kata sandi lama dan kata sandi baru minimal 6 karakter.');
              return;
            }

            Navigator.pop(context);
            pesan('Demo saja: hubungkan ke autentikasi untuk menyimpan perubahan.');
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  // Informasi privasi pengguna.
  void bukaPrivasi() {
    bukaDialog(
      judul: 'Privasi Akun',
      isi: const Text(
        'Informasi profil pada versi ini disimpan sementara di dalam '
        'halaman. Hubungkan aplikasi ke autentikasi dan database '
        'agar informasi akun dikelola dengan aman.',
      ),
    );
  }

  // Pengaturan notifikasi wisata.
  void bukaNotifikasi() {
    bool aktif = true;

    bukaDialog(
      judul: 'Notifikasi Wisata',
      isi: StatefulBuilder(
        builder: (context, ubahDialog) => SwitchListTile(
          title: const Text('Notifikasi wisata'),
          subtitle: const Text('Informasi event dan destinasi terbaru'),
          value: aktif,
          onChanged: (nilai) {
            ubahDialog(() => aktif = nilai);
          },
        ),
      ),
    );
  }

  // Informasi aplikasi TernateSpot.
  void bukaTentang() {
    bukaDialog(
      judul: 'Tentang TernateSpot',
      isi: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.travel_explore, size: 55, color: warnaBiru),
          SizedBox(height: 12),
          Text(
            'TernateSpot',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Aplikasi informasi wisata yang membantu pengguna '
            'menemukan destinasi menarik di Ternate.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text('Versi 1.0.0'),
        ],
      ),
    );
  }

  // Konfirmasi sebelum pengguna keluar dari akun.
  void konfirmasiLogout() {
    bukaDialog(
      judul: 'Keluar dari Akun?',
      isi: const Text(
        'Apakah kamu yakin ingin keluar dari halaman profil ini?',
      ),
      aksi: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            pesan('Logout belum terhubung ke autentikasi.');
          },
          child: const Text('Ya, Keluar'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaLatar,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER BIRU SEPERTI DESAIN.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0875F9),
                      Color(0xFF0756D8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status akun terverifikasi.
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Color(0xFF72F5B4),
                                size: 8,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Akun Terverifikasi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tombol edit profil.
                        IconButton(
                          onPressed: editProfil,
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white24,
                          ),
                        ),
                      ],
                    ),

                    // Foto profil sementara menggunakan ikon.
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFDCE8F8),
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: warnaBiru,
                        ),
                      ),
                    ),

                    const SizedBox(height: 9),

                    // Nama dan email akan mengikuti hasil edit profil.
                    Text(
                      nama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Penjelajah Ternate ⭐',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // KARTU STATISTIK YANG BISA DIKLIK.
              Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatistikUser(
                          ikon: Icons.public,
                          angka: '$jumlahDestinasi',
                          judul: 'Destinasi',
                          warnaIkon: warnaBiru,
                          onTap: () => bukaStatistik('Destinasi'),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 38,
                        color: const Color(0xFFE7ECF4),
                      ),
                      Expanded(
                        child: StatistikUser(
                          ikon: Icons.favorite,
                          angka: '${favorit.length}',
                          judul: 'Favorit',
                          warnaIkon: Colors.red,
                          onTap: () => bukaStatistik('Favorit'),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 38,
                        color: const Color(0xFFE7ECF4),
                      ),
                      Expanded(
                        child: StatistikUser(
                          ikon: Icons.rate_review,
                          angka: '$jumlahUlasan',
                          judul: 'Ulasan',
                          warnaIkon: const Color(0xFF20A879),
                          onTap: () => bukaStatistik('Ulasan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // DAFTAR MENU PROFIL.
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 3, bottom: 12),
                      child: Text(
                        'MENU AKUN & PETUALANGAN',
                        style: TextStyle(
                          fontSize: 11,
                          color: warnaAbu,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    MenuProfilUser(
                      ikon: Icons.favorite,
                      judul: 'Destinasi Favorit',
                      deskripsi: '${favorit.length} tempat wisata tersimpan',
                      warnaIkon: const Color(0xFFFFDADA),
                      warnaSimbol: Colors.red,
                      onTap: bukaFavorit,
                    ),

                    MenuProfilUser(
                      ikon: Icons.star,
                      judul: 'Ulasan Saya',
                      deskripsi: '$jumlahUlasan ulasan & pengalaman',
                      warnaIkon: const Color(0xFFDCE6F7),
                      warnaSimbol: warnaTeks,
                      onTap: bukaUlasan,
                    ),

                    MenuProfilUser(
                      ikon: Icons.explore_outlined,
                      judul: 'Riwayat Kunjungan & Rencana',
                      deskripsi: 'Jadwal jelajah pulau Ternate',
                      warnaIkon: const Color(0xFFE0E8FF),
                      warnaSimbol: const Color(0xFF4775F5),
                      onTap: bukaRiwayat,
                    ),

                    MenuProfilUser(
                      ikon: Icons.lock_outline,
                      judul: 'Pengaturan Akun & Keamanan',
                      deskripsi: 'Edit profil, kata sandi & privasi',
                      warnaIkon: const Color(0xFFDCE8FF),
                      warnaSimbol: warnaBiru,
                      onTap: bukaPengaturan,
                    ),

                    MenuProfilUser(
                      ikon: Icons.notifications_active_outlined,
                      judul: 'Notifikasi Wisata',
                      deskripsi: 'Update event & info spot terbaru',
                      warnaIkon: const Color(0xFF66F5C0),
                      warnaSimbol: const Color(0xFF087D55),
                      onTap: bukaNotifikasi,
                    ),

                    MenuProfilUser(
                      ikon: Icons.info_outline,
                      judul: 'Tentang Aplikasi TernateSpot',
                      deskripsi: 'Informasi aplikasi dan bantuan',
                      warnaIkon: const Color(0xFFDCE6FF),
                      warnaSimbol: warnaBiru,
                      onTap: bukaTentang,
                    ),

                    MenuProfilUser(
                      ikon: Icons.logout,
                      judul: 'Keluar dari Akun',
                      deskripsi: 'Keluar dari halaman profil',
                      warnaIkon: const Color(0xFFFFE2E2),
                      warnaSimbol: Colors.red,
                      onTap: konfirmasiLogout,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // NAVIGASI BAWAH SEPERTI PADA DESAIN.
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: menuAktif,
        selectedItemColor: warnaBiru,
        unselectedItemColor: warnaAbu,
        backgroundColor: Colors.white,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (index) {
          setState(() => menuAktif = index);

          switch (index) {
            case 0:
              pesan('Menu Beranda dipilih.');
              break;
            case 1:
              pesan('Menu Peta dipilih.');
              break;
            case 2:
              bukaFavorit();
              break;
            case 3:
              // Pengguna sedang berada di halaman Profil.
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Peta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorit',
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

// WIDGET STATISTIK.
// Setiap kartu bisa ditekan untuk membuka detail.
class StatistikUser extends StatelessWidget {
  final IconData ikon;
  final String angka;
  final String judul;
  final Color warnaIkon;
  final VoidCallback onTap;

  const StatistikUser({
    super.key,
    required this.ikon,
    required this.angka,
    required this.judul,
    required this.warnaIkon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(ikon, size: 14, color: warnaIkon),
                const SizedBox(width: 4),
                Text(
                  angka,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: warnaTeks,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              judul,
              style: const TextStyle(
                fontSize: 10,
                color: warnaAbu,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET KARTU MENU.
// Seluruh kartu menerima fungsi onTap masing-masing.
class MenuProfilUser extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String deskripsi;
  final Color warnaIkon;
  final Color warnaSimbol;
  final VoidCallback onTap;

  const MenuProfilUser({
    super.key,
    required this.ikon,
    required this.judul,
    required this.deskripsi,
    required this.warnaIkon,
    required this.warnaSimbol,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: Row(
              children: [
                // Ikon di dalam kotak berwarna.
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: warnaIkon,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    ikon,
                    color: warnaSimbol,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                // Judul dan deskripsi menu.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        judul,
                        style: const TextStyle(
                          color: warnaTeks,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deskripsi,
                        style: const TextStyle(
                          color: warnaAbu,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tanda panah untuk menunjukkan menu dapat dibuka.
                const Icon(
                  Icons.chevron_right,
                  color: warnaAbu,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
