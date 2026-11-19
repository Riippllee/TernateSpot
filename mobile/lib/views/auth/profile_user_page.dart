import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/profile_controller.dart';
import 'favorit_user_page.dart';
import 'ulasan_saya_page.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({super.key});

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  // =========================================================
  // CONTROLLER
  // =========================================================

  final ProfileController _controller = ProfileController();
  final ImagePicker _imagePicker = ImagePicker();

  // =========================================================
  // STATE PROFILE
  // =========================================================

  String nama = 'Pengguna';
  String email = '-';
  String role = 'user';
  String? fotoProfil;
  bool status = true;

  bool _isLoading = true;
  bool _isProcessing = false;

  // Statistik pengguna
  int jumlahDestinasi = 0;
  int jumlahFavorit = 0;
  int jumlahUlasan = 0;

  bool _isLoadingStatistik = true;
  bool _statistikGagal = false;

  // Profil berada di index 3
  int menuAktif = 3;

  // =========================================================
  // WARNA TERNATESPOT
  // =========================================================

  static const Color warnaBiru = Color(0xFF0875F9);
  static const Color warnaLatar = Color(0xFFF5F7FC);
  static const Color warnaTeks = Color(0xFF202B3C);
  static const Color warnaAbu = Color(0xFF8A94A6);

  // =========================================================
  // INIT STATE
  // =========================================================

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // =========================================================
  // LOAD PROFILE
  // =========================================================

  Future<void> loadProfile() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _controller.loadProfile();

      if (!mounted) return;

      if (data == null) {
        setState(() {
          nama = 'Pengguna';
          email = '-';
          role = 'user';
          fotoProfil = null;
          status = true;
        });
      } else {
        setState(() {
          nama = data['nama']?.toString().trim().isNotEmpty == true
              ? data['nama'].toString()
              : 'Pengguna';

          email = data['email']?.toString().trim().isNotEmpty == true
              ? data['email'].toString()
              : '-';

          role = data['role']?.toString() ?? 'user';

          final foto = data['foto_profil']?.toString();

          fotoProfil = foto != null && foto.trim().isNotEmpty
              ? foto.trim()
              : null;

          status = _parseStatus(data['status']);
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        nama = 'Pengguna';
        email = '-';
        role = 'user';
        fotoProfil = null;
        status = true;
      });

      pesan('Gagal memuat profil.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    if (mounted) {
      await loadStatistik();
    }
  }

  // =========================================================
  // LOAD STATISTIK PENGGUNA
  // =========================================================

  Future<void> loadStatistik() async {
    if (!mounted) return;

    setState(() {
      _isLoadingStatistik = true;
      _statistikGagal = false;
    });

    try {
      final data = await _controller.loadStatistics();

      if (!mounted) return;

      if (data == null) {
        setState(() {
          _statistikGagal = true;
        });
        return;
      }

      setState(() {
        jumlahDestinasi = data['destinasi'] ?? 0;
        jumlahFavorit = data['favorit'] ?? 0;
        jumlahUlasan = data['ulasan'] ?? 0;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _statistikGagal = true;
      });

      pesan('Gagal memuat statistik pengguna.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingStatistik = false;
        });
      }
    }
  }

  // =========================================================
  // FORMAT NILAI STATISTIK
  // =========================================================

  String nilaiStatistik(int jumlah) {
    if (_isLoadingStatistik) {
      return '...';
    }

    if (_statistikGagal) {
      return '-';
    }

    return jumlah.toString();
  }

  // =========================================================
  // PARSE STATUS
  // =========================================================

  bool _parseStatus(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;

    final text = value?.toString().toLowerCase().trim();

    return text == 'true' || text == '1' || text == 'aktif' || text == 'active';
  }

  // =========================================================
  // FOTO PROFIL
  // =========================================================

  Future<void> pilihFotoProfil() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null || !mounted) return;

      setState(() {
        _isProcessing = true;
      });

      final berhasil = await _controller.uploadProfilePicture(image);

      if (!mounted) return;

      if (berhasil) {
        await loadProfile();

        if (!mounted) return;

        pesan('Foto profil berhasil diperbarui.');
      } else {
        pesan('Gagal memperbarui foto profil.');
      }
    } catch (e) {
      if (!mounted) return;

      pesan('Terjadi kesalahan saat mengganti foto profil.');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // =========================================================
  // EDIT PROFIL
  // =========================================================

  Future<void> editProfil() async {
    final namaController = TextEditingController(text: nama);
    final emailController = TextEditingController(text: email);

    final namaBaru = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Nama lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                  helperText: 'Email tidak dapat diubah di menu ini.',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = namaController.text.trim();

                if (value.isEmpty) return;

                Navigator.pop(dialogContext, value);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    namaController.dispose();
    emailController.dispose();

    if (namaBaru == null || !mounted) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final berhasil = await _controller.updateProfile(nama: namaBaru);

      if (!mounted) return;

      if (berhasil) {
        await loadProfile();

        if (!mounted) return;

        pesan('Profil berhasil diperbarui.');
      } else {
        pesan('Gagal memperbarui profil.');
      }
    } catch (e) {
      if (!mounted) return;

      pesan('Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // =========================================================
  // SNACKBAR
  // =========================================================

  void pesan(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  // =========================================================
  // DIALOG STATISTIK
  // =========================================================

  Future<void> bukaDialogStatistik({
    required String judul,
    required String isi,
  }) async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(judul),
          content: Text(isi),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // MENU AKUN
  // =========================================================

  Future<void> bukaMenu(String menu) async {
    switch (menu) {
      case 'favorit':
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const FavoritUserPage(),
          ),
        );

        if (mounted) {
          await loadStatistik();
        }
        break;

      case 'ulasan':
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(builder: (context) => const UlasanSayaPage()),
        );

        if (mounted) {
          await loadStatistik();
        }
        break;

      case 'riwayat':
        pesan('Fitur riwayat perjalanan belum tersedia.');
        break;

      case 'pengaturan':
        await editProfil();
        break;

      case 'notifikasi':
        pesan('Pengaturan notifikasi belum tersedia.');
        break;

      case 'tentang':
        await bukaTentang();
        break;
    }
  }

  // =========================================================
  // TENTANG APLIKASI
  // =========================================================

  Future<void> bukaTentang() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Tentang TernateSpot'),
          content: const Text(
            'TernateSpot merupakan aplikasi informasi wisata '
            'yang membantu pengguna menemukan destinasi menarik '
            'di Kota Ternate.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> konfirmasiLogout() async {
    if (_isProcessing) return;

    final keluar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Keluar dari Akun'),
          content: const Text(
            'Apakah kamu yakin ingin keluar dari akun TernateSpot?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );

    if (keluar != true || !mounted) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await _controller.logout();

      if (!mounted) return;

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      pesan('Gagal keluar dari akun.');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // =========================================================
  // NAVIGASI BOTTOM
  // =========================================================
  //
  // 0 = Beranda
  // 1 = Lokasi
  // 2 = Favorit
  // 3 = Profil
  //
  // Profil mengembalikan index ke BerandaPage.
  //
  // =========================================================

  void navigasiBottom(int index) {
    if (index == 3) {
      return;
    }

    final navigator = Navigator.of(context);

    if (navigator.canPop()) {
      navigator.pop(index);
    }
  }

  // =========================================================
  // IMAGE PROVIDER
  // =========================================================

  ImageProvider? get _profileImage {
    final foto = fotoProfil?.trim();

    if (foto == null || foto.isEmpty) {
      return null;
    }

    if (foto.startsWith('http://') || foto.startsWith('https://')) {
      return NetworkImage(foto);
    }

    return null;
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaLatar,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadProfile,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                _buildStatistics(),
                _buildMenuSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // =========================================================
  // HEADER PROFILE
  // =========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
      decoration: const BoxDecoration(
        color: warnaBiru,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // STATUS DAN EDIT

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status
                            ? const Color(0xFF66F3B0)
                            : Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      status ? 'Akun Aktif' : 'Akun Nonaktif',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.white.withValues(alpha: 0.18),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _isProcessing ? null : editProfil,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.edit, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // FOTO PROFIL
          GestureDetector(
            onTap: _isProcessing ? null : pilihFotoProfil,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: ClipOval(
                    child: _profileImage != null
                        ? Image(
                            image: _profileImage!,
                            width: 88,
                            height: 88,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 48,
                                color: warnaAbu,
                              );
                            },
                          )
                        : const Icon(Icons.person, size: 48, color: warnaAbu),
                  ),
                ),
                Positioned(
                  right: -3,
                  bottom: -3,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: warnaBiru, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: warnaBiru,
                      size: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // NAMA
          _isLoading
              ? const SizedBox(
                  width: 90,
                  height: 22,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : Text(
                  nama,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

          const SizedBox(height: 8),

          // ROLE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role.toLowerCase() == 'admin'
                  ? 'Administrator'
                  : 'Penjelajah Ternate ⭐',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // EMAIL
          Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 8),

          const Text(
            'Ketuk foto untuk mengganti foto profil',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // STATISTICS
  // =========================================================

  Widget _buildStatistics() {
    return Transform.translate(
      offset: const Offset(0, -18),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // DESTINASI

            Expanded(
              child: _buildStatisticItem(
                icon: Icons.public,
                iconColor: warnaBiru,
                value: nilaiStatistik(jumlahDestinasi),
                label: 'Destinasi',
                onTap: () {
                  bukaDialogStatistik(
                    judul: 'Destinasi Wisata',
                    isi: _statistikGagal
                        ? 'Statistik destinasi gagal dimuat.'
                        : 'Saat ini terdapat $jumlahDestinasi destinasi wisata aktif di TernateSpot.',
                  );
                },
              ),
            ),

            Container(width: 1, height: 38, color: const Color(0xFFE2E6EE)),

            // FAVORIT
            Expanded(
              child: _buildStatisticItem(
                icon: Icons.favorite,
                iconColor: Colors.red,
                value: nilaiStatistik(jumlahFavorit),
                label: 'Favorit',
                onTap: () {
                  bukaMenu('favorit');
                },
              ),
            ),

            Container(width: 1, height: 38, color: const Color(0xFFE2E6EE)),

            // ULASAN
            Expanded(
              child: _buildStatisticItem(
                icon: Icons.rate_review,
                iconColor: const Color(0xFF18A879),
                value: nilaiStatistik(jumlahUlasan),
                label: 'Ulasan',
                onTap: () {
                  bukaMenu('ulasan');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ITEM STATISTIK
  // =========================================================

  Widget _buildStatisticItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 18),
                const SizedBox(width: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: warnaTeks,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: warnaAbu, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // MENU AKUN
  // =========================================================

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MENU AKUN & PETUALANGAN',
            style: TextStyle(
              color: warnaAbu,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          MenuProfilUser(
            ikon: Icons.favorite,
            judul: 'Destinasi Favorit',
            deskripsi: 'Lihat tempat wisata tersimpan',
            warnaIkon: const Color(0xFFFFDADA),
            warnaSimbol: Colors.red,
            onTap: () => bukaMenu('favorit'),
          ),

          const SizedBox(height: 12),

          MenuProfilUser(
            ikon: Icons.star,
            judul: 'Ulasan Saya',
            deskripsi: 'Ulasan dan pengalaman wisata',
            warnaIkon: const Color(0xFFDCE6F7),
            warnaSimbol: warnaTeks,
            onTap: () => bukaMenu('ulasan'),
          ),

          const SizedBox(height: 12),

          MenuProfilUser(
            ikon: Icons.explore_outlined,
            judul: 'Riwayat Kunjungan & Rencana',
            deskripsi: 'Jadwal jelajah Pulau Ternate',
            warnaIkon: const Color(0xFFE0E8FF),
            warnaSimbol: const Color(0xFF4775F5),
            onTap: () => bukaMenu('riwayat'),
          ),

          const SizedBox(height: 12),

          MenuProfilUser(
            ikon: Icons.lock_outline,
            judul: 'Pengaturan Akun & Keamanan',
            deskripsi: 'Edit profil dan keamanan akun',
            warnaIkon: const Color(0xFFDCE8FF),
            warnaSimbol: warnaBiru,
            onTap: () => bukaMenu('pengaturan'),
          ),

          const SizedBox(height: 12),

          MenuProfilUser(
            ikon: Icons.notifications_active_outlined,
            judul: 'Notifikasi Wisata',
            deskripsi: 'Informasi wisata terbaru',
            warnaIkon: const Color(0xFFCCF7E5),
            warnaSimbol: const Color(0xFF087D55),
            onTap: () => bukaMenu('notifikasi'),
          ),

          const SizedBox(height: 12),

          MenuProfilUser(
            ikon: Icons.info_outline,
            judul: 'Tentang Aplikasi TernateSpot',
            deskripsi: 'Informasi aplikasi dan bantuan',
            warnaIkon: const Color(0xFFDCE6FF),
            warnaSimbol: warnaBiru,
            onTap: () => bukaMenu('tentang'),
          ),

          const SizedBox(height: 12),

          MenuProfilUser(
            ikon: Icons.logout,
            judul: 'Keluar dari Akun',
            deskripsi: 'Keluar dari akun TernateSpot',
            warnaIkon: const Color(0xFFFFE2E2),
            warnaSimbol: Colors.red,
            onTap: konfirmasiLogout,
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOTTOM NAVIGATION
  // =========================================================

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: menuAktif,
      selectedItemColor: warnaBiru,
      unselectedItemColor: warnaAbu,
      backgroundColor: Colors.white,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      onTap: navigasiBottom,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined),
          activeIcon: Icon(Icons.location_on),
          label: 'Lokasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          activeIcon: Icon(Icons.favorite),
          label: 'Favorit',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

// =============================================================
// WIDGET MENU PROFILE
// =============================================================

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
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: warnaIkon,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(ikon, color: warnaSimbol, size: 29),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF202B3C),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      deskripsi,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF8A94A6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              const Icon(
                Icons.chevron_right,
                color: Color(0xFF8A94A6),
                size: 27,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
