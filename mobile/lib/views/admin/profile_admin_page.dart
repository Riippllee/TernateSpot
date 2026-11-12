import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
  Map<String, dynamic>? _dataAdmin;
  bool _isLoadingProfil = true;
  int menuAktif = 4;

  void tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  void initState() {
    super.initState();
    _loadProfilAdmin();
  }

  Future<void> _loadProfilAdmin() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      debugPrint('AUTH USER ID: $userId');

      if (userId == null) {
        throw Exception('Pengguna belum login');
      }

      final data = await supabase
          .from('user')
          .select('id_user, nama, email, foto_profil, role')
          .eq('id_user', userId)
          .maybeSingle();
      debugPrint('DATA PROFIL ADMIN: $data');
      if (!mounted) return;

      setState(() {
        _dataAdmin = data;
        _isLoadingProfil = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil profil admin: $e');

      if (!mounted) return;

      setState(() {
        _isLoadingProfil = false;
      });
    }
  }

  Future<void> _editProfilAdmin() async {
    final namaController = TextEditingController(
      text: _dataAdmin?['nama']?.toString() ?? '',
    );

    XFile? fotoTerpilih;
    bool sedangMenyimpan = false;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Profil Admin'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Admin',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: sedangMenyimpan
                          ? null
                          : () async {
                              final picker = ImagePicker();

                              final image = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 80,
                              );

                              if (image != null) {
                                setDialogState(() {
                                  fotoTerpilih = image;
                                });
                              }
                            },
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Pilih Foto Profil'),
                    ),
                    if (fotoTerpilih != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          fotoTerpilih!.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: sedangMenyimpan
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: sedangMenyimpan
                      ? null
                      : () async {
                          final nama = namaController.text.trim();

                          if (nama.isEmpty) {
                            tampilkanPesan('Nama tidak boleh kosong.');
                            return;
                          }

                          setDialogState(() {
                            sedangMenyimpan = true;
                          });

                          try {
                            final supabase = Supabase.instance.client;

                            final userId = supabase.auth.currentUser?.id;

                            if (userId == null) {
                              throw Exception('Akun belum login.');
                            }

                            final updateData = <String, dynamic>{'nama': nama};

                            // Upload foto jika admin memilih foto baru.
                            if (fotoTerpilih != null) {
                              final extension = fotoTerpilih!.name
                                  .split('.')
                                  .last
                                  .toLowerCase();

                              if (![
                                'jpg',
                                'jpeg',
                                'png',
                                'webp',
                              ].contains(extension)) {
                                throw Exception(
                                  'Format foto harus JPG, PNG, atau WEBP.',
                                );
                              }

                              final filePath =
                                  '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.$extension';

                              final bytes = await fotoTerpilih!.readAsBytes();

                              final mimeType = {
                                'jpg': 'image/jpeg',
                                'jpeg': 'image/jpeg',
                                'png': 'image/png',
                                'webp': 'image/webp',
                              }[extension]!;

                              await supabase.storage
                                  .from('foto-profil')
                                  .uploadBinary(
                                    filePath,
                                    bytes,
                                    fileOptions: FileOptions(
                                      contentType: mimeType,
                                    ),
                                  );

                              final fotoUrl = supabase.storage
                                  .from('foto-profil')
                                  .getPublicUrl(filePath);

                              updateData['foto_profil'] = fotoUrl;
                            }

                            await supabase
                                .from('user')
                                .update(updateData)
                                .eq('id_user', userId);

                            await _loadProfilAdmin();
                            if (!dialogContext.mounted) return;

                            Navigator.pop(dialogContext);

                            if (!mounted) return;

                            tampilkanPesan('Profil berhasil diperbarui.');

                            tampilkanPesan('Profil berhasil diperbarui.');
                          } catch (e) {
                            debugPrint('Gagal update profil: $e');

                            setDialogState(() {
                              sedangMenyimpan = false;
                            });

                            tampilkanPesan('Gagal memperbarui profil: $e');
                          }
                        },
                  child: sedangMenyimpan
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    namaController.dispose();
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
                    colors: [Color(0xFF1760D2), Color(0xFF0645A5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.15),
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
                            color: Colors.white.withValues(alpha: 0.20),
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
                          onTap: _editProfilAdmin,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.20),
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
                            child: Builder(
                              builder: (context) {
                                final foto = _dataAdmin?['foto']
                                    ?.toString()
                                    .trim();

                                if (foto == null || foto.isEmpty) {
                                  return Container(
                                    color: Colors.white24,
                                    child: const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  );
                                }

                                return Image.network(
                                  foto,
                                  width: 48,
                                  height: 48,
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
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isLoadingProfil
                                    ? 'Memuat...'
                                    : (_dataAdmin?['nama']?.toString() ??
                                          'Admin'),
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
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.alternate_email,
                            color: Colors.white,
                            size: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isLoadingProfil
                              ? 'Memuat email...'
                              : (_dataAdmin?['email']?.toString() ?? '-'),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'PENGATURAN & INFORMASI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: warnaAbu,
                ),
              ),

              const SizedBox(height: 12),

              // Semua menu dikelompokkan dalam satu kartu.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: warnaGaris),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.025),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    KartuMenuAdmin(
                      ikon: Icons.lock_outline_rounded,
                      judul: 'Keamanan & Password',
                      deskripsi: 'Kelola keamanan akun',
                      onTap: () {
                        tampilkanPesan('Menu Keamanan & Password dipilih.');
                      },
                    ),

                    const Divider(height: 1, color: warnaGaris),

                    KartuMenuAdmin(
                      ikon: Icons.history_rounded,
                      judul: 'Riwayat Aktivitas',
                      deskripsi: 'Lihat aktivitas administrator',
                      onTap: () {
                        tampilkanPesan('Menu Riwayat Aktivitas dipilih.');
                      },
                    ),

                    const Divider(height: 1, color: warnaGaris),

                    KartuMenuAdmin(
                      ikon: Icons.info_outline_rounded,
                      judul: 'Tentang TernateSpot',
                      deskripsi: 'Informasi dan versi aplikasi',
                      onTap: () {
                        tampilkanPesan('Menu Tentang TernateSpot dipilih.');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Tombol logout terpisah.
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    tampilkanPesan('Konfirmasi logout akan dihubungkan.');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFF3DADA)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEEEE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFDC4545),
                            size: 21,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Keluar dari Akun',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFDC4545),
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Akhiri sesi administrator',
                                style: TextStyle(fontSize: 11, color: warnaAbu),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFFDC4545),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

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
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(ikon, color: warnaBiru, size: 21),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: warnaTeks,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      deskripsi,
                      style: const TextStyle(fontSize: 11, color: warnaAbu),
                    ),
                  ],  
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF98A2B3),
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
