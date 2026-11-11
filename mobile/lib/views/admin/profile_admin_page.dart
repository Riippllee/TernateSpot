import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/profile_update_notifier.dart';

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
                            final fotoLama = _dataAdmin?['foto_profil']
                                ?.toString();

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

                            // Hapus foto lama setelah foto baru berhasil disimpan.
                            if (fotoTerpilih != null &&
                                fotoLama != null &&
                                fotoLama.isNotEmpty) {
                              try {
                                final uri = Uri.parse(fotoLama);
                                final segments = uri.pathSegments;
                                final bucketIndex = segments.indexOf(
                                  'foto-profil',
                                );

                                if (bucketIndex != -1 &&
                                    bucketIndex < segments.length - 1) {
                                  final oldPath = segments
                                      .skip(bucketIndex + 1)
                                      .join('/');

                                  // Pastikan foto lama milik admin yang sedang login.
                                  if (oldPath.startsWith('$userId/')) {
                                    await supabase.storage
                                        .from('foto-profil')
                                        .remove([oldPath]);
                                  }
                                }
                              } catch (e) {
                                debugPrint(
                                  'Foto lama belum berhasil dihapus: $e',
                                );
                              }
                            }

                            await _loadProfilAdmin();

                            ProfileUpdateNotifier.notifyUpdate();
                            if (!dialogContext.mounted) return;

                            Navigator.pop(dialogContext);

                            if (!mounted) return;

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
                                final foto = _dataAdmin?['foto_profil']
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
                                  key: ValueKey(foto),
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
                    style: TextStyle(color: warnaBiru, fontSize: 10),
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
                  tampilkanPesan('Pengaturan keamanan belum dihubungkan.');
                },
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
            style: const TextStyle(fontSize: 11, color: warnaAbu),
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
                  color: warnaBiru.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(ikon, color: warnaBiru, size: 22),
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
                      style: const TextStyle(color: warnaAbu, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: warnaAbu),
            ],
          ),
        ),
      ),
    );
  }
}
