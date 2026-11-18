
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ==========================================
// WARNA APLIKASI
// ==========================================

const Color warnaBiru = Color(0xFF1769E0);
const Color warnaLatar = Color(0xFFF5F7FC);
const Color warnaTeks = Color(0xFF202631);
const Color warnaAbu = Color(0xFF7B8494);
const Color warnaMerah = Color(0xFFC62828);
const Color warnaHijau = Color(0xFF239B68);

// ==========================================
// FAVORIT USER PAGE
// ==========================================

class FavoritUserPage extends StatefulWidget {
  const FavoritUserPage({super.key});

  @override
  State<FavoritUserPage> createState() =>
      _FavoritUserPageState();
}

class _FavoritUserPageState extends State<FavoritUserPage> {
  final SupabaseClient _supabase =
      Supabase.instance.client;

  String kategoriAktif = 'Semua';
  int menuAktif = 2;

  final List<Map<String, dynamic>> destinasi = [];

  final Set<int> _removingIds = {};

  bool _isLoading = true;
  String? _errorMessage;

  // ==========================================
  // INIT STATE
  // ==========================================

  @override
  void initState() {
    super.initState();
    muatFavorit();
  }

  // ==========================================
  // NORMALISASI KATEGORI
  // ==========================================

  String _normalisasiKategori(String kategori) {
    final value = kategori.toLowerCase();

    if (value.contains('pantai')) {
      return 'Pantai';
    }

    if (value.contains('alam') ||
        value.contains('danau') ||
        value.contains('air') ||
        value.contains('gunung')) {
      return 'Alam';
    }

    if (value.contains('sejarah') ||
        value.contains('benteng')) {
      return 'Sejarah';
    }

    return kategori;
  }

  // ==========================================
  // LOAD FAVORIT DARI SUPABASE
  // ==========================================

  Future<void> muatFavorit() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Mengambil ID pengguna yang sedang login.
      final userId = _supabase.auth.currentUser?.id;

      if (userId == null) {
        throw Exception(
          'Silakan login untuk melihat destinasi favorit.',
        );
      }

      // 1. Mengambil daftar favorit pengguna.
      final favoriteRows = await _supabase
          .from('favorit')
          .select('id_destinasi, tanggal_ditambah')
          .eq('id_user', userId)
          .order('tanggal_ditambah', ascending: false);

      if (favoriteRows.isEmpty) {
        if (!mounted) return;

        setState(() {
          destinasi.clear();
        });

        return;
      }

      // 2. Mengumpulkan ID destinasi.
      final List<int> favoriteIds = [];

      for (final row in favoriteRows) {
        final id = (row['id_destinasi'] as num).toInt();

        if (!favoriteIds.contains(id)) {
          favoriteIds.add(id);
        }
      }

      // 3. Mengambil informasi destinasi berdasarkan ID.
      final destinationRows = await _supabase
          .from('destinasi')
          .select(
            'id_destinasi, '
            'id_kategori, '
            'nama_destinasi, '
            'deskripsi, '
            'alamat, '
            'foto_utama',
          )
          .inFilter('id_destinasi', favoriteIds);

      // 4. Membuat pemetaan destinasi berdasarkan ID.
      final Map<int, Map<String, dynamic>> destinationMap = {};

      for (final row in destinationRows) {
        final id = (row['id_destinasi'] as num).toInt();

        destinationMap[id] =
            Map<String, dynamic>.from(row);
      }

      // 5. Mengumpulkan ID kategori.
      final Set<int> kategoriIds = {};

      for (final row in destinationRows) {
        final rawId = row['id_kategori'];

        if (rawId is num) {
          kategoriIds.add(rawId.toInt());
        }
      }

      // 6. Mengambil nama kategori.
      final Map<int, String> kategoriMap = {};

      if (kategoriIds.isNotEmpty) {
        final kategoriRows = await _supabase
            .from('kategori')
            .select('id_kategori, nama_kategori')
            .inFilter(
              'id_kategori',
              kategoriIds.toList(),
            );

        for (final row in kategoriRows) {
          final id = (row['id_kategori'] as num).toInt();

          kategoriMap[id] =
              (row['nama_kategori'] ?? 'Lainnya').toString();
        }
      }

      // 7. Menggabungkan data favorit dan destinasi.
      final List<Map<String, dynamic>> hasil = [];

      for (final id in favoriteIds) {
        final data = destinationMap[id];

        // Lewati jika destinasi tidak ditemukan.
        if (data == null) continue;

        final rawKategoriId = data['id_kategori'];

        final kategoriId = rawKategoriId is num
            ? rawKategoriId.toInt()
            : -1;

        final namaKategori =
            kategoriMap[kategoriId] ?? 'Lainnya';

        hasil.add({
          'id_destinasi': id,
          'nama': data['nama_destinasi'] ?? 'Tanpa Nama',
          'kategori': _normalisasiKategori(namaKategori),
          'lokasi': data['alamat'] ?? '',
          'rating': '',
          'gambar': data['foto_utama'] ?? '',
          'favorit': true,
          'deskripsi': data['deskripsi'] ?? '',
        });
      }

      if (!mounted) return;

      setState(() {
        destinasi
          ..clear()
          ..addAll(hasil);
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ==========================================
  // FILTER DAFTAR FAVORIT
  // ==========================================

  List<Map<String, dynamic>> get daftarFavorit {
    return destinasi.where((item) {
      final kategori = item['kategori'].toString();

      if (kategoriAktif == 'Semua') {
        return true;
      }

      return kategori == kategoriAktif;
    }).toList();
  }

  // ==========================================
  // JUMLAH FAVORIT PER KATEGORI
  // ==========================================

  int jumlahKategori(String kategori) {
    if (kategori == 'Semua') {
      return destinasi.length;
    }

    return destinasi.where((item) {
      return item['kategori'] == kategori;
    }).length;
  }

  // ==========================================
  // HAPUS FAVORIT DARI SUPABASE
  // ==========================================

  Future<void> ubahFavorit(
    Map<String, dynamic> item,
  ) async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu.'),
        ),
      );
      return;
    }

    final int id =
        (item['id_destinasi'] as num).toInt();

    if (_removingIds.contains(id)) return;

    setState(() {
      _removingIds.add(id);
    });

    try {
      // Menghapus data favorit milik pengguna.
      await _supabase
          .from('favorit')
          .delete()
          .eq('id_user', userId)
          .eq('id_destinasi', id);

      if (!mounted) return;

      // Memuat ulang daftar favorit.
      await muatFavorit();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${item['nama']} berhasil dihapus dari favorit.',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus favorit: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _removingIds.remove(id);
        });
      }
    }
  }

  // ==========================================
  // DETAIL DESTINASI
  // ==========================================

  void tampilkanDetail(Map<String, dynamic> item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final gambar = (item['gambar'] ?? '').toString();
        final rating = (item['rating'] ?? '').toString();

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    child: gambar.isNotEmpty
                        ? Image.network(
                            gambar,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) {
                              return _gambarCadangan(220);
                            },
                          )
                        : _gambarCadangan(220),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            labelKategori(
                              item['kategori'].toString(),
                            ),

                            const Spacer(),

                            if (rating.isNotEmpty) ...[
                              const Icon(
                                Icons.star,
                                size: 17,
                                color: warnaHijau,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          item['nama'].toString(),
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: warnaTeks,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: warnaBiru,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                item['lokasi'].toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: warnaAbu,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          item['deskripsi'].toString().isEmpty
                              ? 'Belum ada deskripsi destinasi.'
                              : item['deskripsi'].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: warnaTeks,
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _removingIds.contains(
                              (item['id_destinasi'] as num).toInt(),
                            )
                                ? null
                                : () async {
                                    Navigator.pop(sheetContext);
                                    await ubahFavorit(item);
                                  },
                            icon: const Icon(Icons.favorite),
                            label: const Text(
                              'Hapus dari Favorit',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: warnaBiru,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // GAMBAR CADANGAN
  // ==========================================

  Widget _gambarCadangan(double tinggi) {
    return Container(
      width: double.infinity,
      height: tinggi,
      color: const Color(0xFFE4EDF7),
      child: const Icon(
        Icons.landscape,
        color: warnaBiru,
        size: 45,
      ),
    );
  }

  // ==========================================
  // LABEL KATEGORI
  // ==========================================

  Widget labelKategori(String kategori) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        kategori,
        style: const TextStyle(
          color: warnaBiru,
          fontSize: 9,
        ),
      ),
    );
  }

  // ==========================================
  // TOMBOL KATEGORI
  // ==========================================

  Widget tombolKategori(String nama) {
    final bool aktif = kategoriAktif == nama;

    return GestureDetector(
      onTap: () {
        setState(() {
          kategoriAktif = nama;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: aktif ? warnaBiru : const Color(0xFFE9EDF5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nama,
              style: TextStyle(
                fontSize: 10,
                color: aktif
                    ? Colors.white
                    : const Color(0xFF566174),
                fontWeight:
                    aktif ? FontWeight.w600 : FontWeight.normal,
              ),
            ),

            const SizedBox(width: 5),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: aktif
                    ? Colors.white.withValues(alpha: 0.22)
                    : const Color(0xFFDCE3EF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${jumlahKategori(nama)}',
                style: TextStyle(
                  fontSize: 9,
                  color: aktif
                      ? Colors.white
                      : const Color(0xFF647087),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // KARTU DESTINASI
  // ==========================================

  Widget kartuDestinasi(Map<String, dynamic> item) {
    final gambar = (item['gambar'] ?? '').toString();
    final id = (item['id_destinasi'] as num).toInt();

    final sedangDihapus = _removingIds.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF243653).withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GAMBAR DESTINASI
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: gambar.isNotEmpty
                ? Image.network(
                    gambar,
                    width: 79,
                    height: 79,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return _gambarKecilCadangan();
                    },
                  )
                : _gambarKecilCadangan(),
          ),

          const SizedBox(width: 7),

          // INFORMASI DESTINASI
          Expanded(
            child: SizedBox(
              height: 79,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelKategori(
                    item['kategori'].toString(),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    item['nama'].toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: warnaTeks,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: warnaBiru,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          item['lokasi'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            color: warnaAbu,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 4),

          // TOMBOL FAVORIT DAN DETAIL
          SizedBox(
            height: 79,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: sedangDihapus
                      ? null
                      : () => ubahFavorit(item),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF0F0),
                      shape: BoxShape.circle,
                    ),
                    child: sedangDihapus
                        ? const Padding(
                            padding: EdgeInsets.all(6),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.favorite,
                            size: 15,
                            color: warnaMerah,
                          ),
                  ),
                ),

                const Spacer(),

                GestureDetector(
                  onTap: () => tampilkanDetail(item),
                  child: const Text(
                    'Detail >',
                    style: TextStyle(
                      fontSize: 9,
                      color: warnaBiru,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gambarKecilCadangan() {
    return Container(
      width: 79,
      height: 79,
      color: const Color(0xFFE4EDF7),
      child: const Icon(
        Icons.landscape,
        color: warnaBiru,
        size: 30,
      ),
    );
  }

  // ==========================================
  // NAVIGASI BAWAH
  // ==========================================

  Widget navigasiBawah() {
    final List<IconData> ikon = [
      Icons.home_outlined,
      Icons.location_on_outlined,
      Icons.favorite_outline,
      Icons.person_outline,
    ];

    final List<String> nama = [
      'Beranda',
      'Peta',
      'Favorit',
      'Profil',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 7,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? 4
            : 8,
      ),
      child: Row(
        children: List.generate(ikon.length, (index) {
          final bool aktif = menuAktif == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  menuAktif = index;
                });

                if (index == 0) {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  return;
                }

                if (index != 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Menu ${nama[index]} belum dihubungkan.',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: aktif
                          ? const Color(0xFFE5EEFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      ikon[index],
                      size: 21,
                      color: aktif
                          ? warnaBiru
                          : const Color(0xFF727C8C),
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    nama[index],
                    style: TextStyle(
                      fontSize: 9,
                      color: aktif ? warnaBiru : warnaAbu,
                      fontWeight: aktif
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==========================================
  // MAIN BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> daftar = daftarFavorit;

    return Scaffold(
      backgroundColor: warnaLatar,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER TERNATESPOT
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 8,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.landscape_outlined,
                    color: warnaBiru,
                    size: 27,
                  ),

                  const SizedBox(width: 5),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'ternate',
                                style: TextStyle(
                                  color: warnaTeks,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: 'Spot',
                                style: TextStyle(
                                  color: warnaBiru,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          'WISATA KOTA TERNATE',
                          style: TextStyle(
                            fontSize: 6,
                            color: warnaAbu,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Belum ada notifikasi baru.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: warnaTeks,
                      size: 22,
                    ),
                  ),

                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFFE0E9F5),
                    child: Icon(
                      Icons.person,
                      color: warnaBiru,
                      size: 17,
                    ),
                  ),
                ],
              ),
            ),

            // JUDUL DAN JUMLAH FAVORIT
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 13, 15, 8),
              child: Row(
                children: [
                  const Text(
                    'Destinasi Favorit',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: warnaTeks,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4EDFF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${destinasi.length} Tersimpan',
                      style: const TextStyle(
                        fontSize: 9,
                        color: warnaBiru,
                      ),
                    ),
                  ),

                  const Spacer(),

                  InkWell(
                    onTap: () {
                      setState(() {
                        kategoriAktif =
                            kategoriAktif == 'Semua'
                                ? 'Pantai'
                                : 'Semua';
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8EFFB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.filter_list,
                        size: 17,
                        color: Color(0xFF647087),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Daftar tempat wisata impian di Kepulauan Rempah,\n'
                  'yang siap kamu kunjungi.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.5,
                    color: warnaAbu,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 9),

            // FILTER KATEGORI
            SizedBox(
              height: 29,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  tombolKategori('Semua'),
                  const SizedBox(width: 6),
                  tombolKategori('Pantai'),
                  const SizedBox(width: 6),
                  tombolKategori('Alam'),
                  const SizedBox(width: 6),
                  tombolKategori('Sejarah'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // DAFTAR KARTU DESTINASI
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: warnaMerah,
                                  size: 42,
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  'Gagal memuat favorit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: warnaTeks,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: warnaAbu,
                                  ),
                                ),

                                TextButton(
                                  onPressed: muatFavorit,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : daftar.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.favorite_border,
                                      size: 50,
                                      color: Color(0xFFB6C5DA),
                                    ),

                                    const SizedBox(height: 12),

                                    Text(
                                      destinasi.isEmpty
                                          ? 'Belum ada destinasi favorit'
                                          : 'Tidak ada destinasi pada kategori ini',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: warnaTeks,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    const Text(
                                      'Destinasi yang kamu simpan akan muncul di sini.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: warnaAbu,
                                      ),
                                    ),

                                    if (destinasi.isEmpty)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Kembali ke Beranda',
                                        ),
                                      )
                                    else
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            kategoriAktif = 'Semua';
                                          });
                                        },
                                        child: const Text(
                                          'Lihat Semua',
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: muatFavorit,
                              child: ListView.builder(
                                physics:
                                    const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.fromLTRB(
                                  15,
                                  0,
                                  15,
                                  12,
                                ),
                                itemCount: daftar.length,
                                itemBuilder: (context, index) {
                                  return kartuDestinasi(
                                    daftar[index],
                                  );
                                },
                              ),
                            ),
            ),

            // NAVIGASI BAWAH
            navigasiBawah(),
          ],
        ),
      ),
    );
  }
}
