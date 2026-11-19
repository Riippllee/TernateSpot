
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/destinasi_user_controller.dart';
import '../../controllers/profile_controller.dart';
import '../destinasi/detail_destinasi_page.dart';
import '../destinasi/lokasi_destinasi_page.dart';
import 'profile_user_page.dart';

// =====================================================
// BERANDA TERNATESPOT
// =====================================================

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  late final DestinasiUserController _destinasiController;

  final ProfileController _profileController = ProfileController();

  final SupabaseClient _supabase = Supabase.instance.client;

  String? _fotoProfil;

  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'Semua';

  int selectedBottomIndex = 0;

  // =====================================================
  // FAVORIT DARI SUPABASE
  // =====================================================

  final Set<int> favorites = {};

  final Set<int> _favoriteProcessingIds = {};

  bool _isLoadingFavorites = true;

  String? _favoriteLoadError;

  // =====================================================
  // WARNA APLIKASI
  // =====================================================

  static const Color primaryBlue = Color(0xFF0875ED);
  static const Color backgroundColor = Color(0xFFF7F8FD);
  static const Color textColor = Color(0xFF17233C);
  static const Color secondaryText = Color(0xFF78869A);

  // =====================================================
  // INIT STATE
  // =====================================================

  @override
  void initState() {
    super.initState();

    _destinasiController = DestinasiUserController();

    _destinasiController.addListener(_refreshPage);

    _loadFotoProfil();
    _loadFavorites();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _destinasiController.loadData();
    });
  }

  // =====================================================
  // REFRESH HALAMAN
  // =====================================================

  void _refreshPage() {
    if (!mounted) return;

    setState(() {});
  }

  // =====================================================
  // MEMUAT FOTO PROFIL
  // =====================================================

  Future<void> _loadFotoProfil() async {
    try {
      final data = await _profileController.loadProfile();

      if (!mounted) return;

      final foto = data?['foto_profil']?.toString().trim();

      final fotoValid =
          foto != null &&
          foto.isNotEmpty &&
          (foto.startsWith('https://') || foto.startsWith('http://'));

      setState(() {
        _fotoProfil = fotoValid ? foto : null;
      });
    } catch (error) {
      debugPrint('Gagal memuat foto profil: $error');

      if (!mounted) return;

      setState(() {
        _fotoProfil = null;
      });
    }
  }

  // =====================================================
  // MEMUAT FAVORIT DARI SUPABASE
  // =====================================================

  Future<void> _loadFavorites() async {
    if (!mounted) return;

    final userId = _supabase.auth.currentUser?.id;

    // Favorit hanya tersedia untuk pengguna yang sudah login.
    if (userId == null) {
      setState(() {
        favorites.clear();
        _favoriteLoadError = null;
        _isLoadingFavorites = false;
      });
      return;
    }

    setState(() {
      _isLoadingFavorites = true;
      _favoriteLoadError = null;
      favorites.clear();
    });

    try {
      final favoriteRows = await _supabase
          .from('favorit')
          .select('id_destinasi')
          .eq('id_user', userId);

      final Set<int> loadedFavoriteIds = {};

      for (final row in favoriteRows) {
        final rawId = row['id_destinasi'];

        if (rawId is num) {
          loadedFavoriteIds.add(rawId.toInt());
        } else {
          final parsedId = int.tryParse(rawId?.toString() ?? '');

          if (parsedId != null) {
            loadedFavoriteIds.add(parsedId);
          }
        }
      }

      if (!mounted) return;

      setState(() {
        favorites
          ..clear()
          ..addAll(loadedFavoriteIds);

        _favoriteLoadError = null;
      });
    } catch (error) {
      debugPrint('Gagal memuat favorit: $error');

      if (!mounted) return;

      setState(() {
        _favoriteLoadError = 'Gagal memuat daftar favorit.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFavorites = false;
        });
      }
    }
  }

  // =====================================================
  // REFRESH DATA BERANDA
  // =====================================================

  Future<void> _refreshHomeData() async {
    await _destinasiController.refreshData();
    await _loadFavorites();
  }

  // =====================================================
  // MENAMPILKAN PESAN FAVORIT
  // =====================================================

  void _showFavoriteMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    searchController.dispose();

    _destinasiController.removeListener(_refreshPage);
    _destinasiController.dispose();

    super.dispose();
  }

  // =====================================================
  // NORMALISASI KATEGORI
  // =====================================================

  String _normalizeCategory(String namaKategori) {
    final lower = namaKategori.trim().toLowerCase();

    if (lower.contains('pantai')) {
      return 'Pantai';
    }

    if (lower.contains('alam') ||
        lower.contains('danau') ||
        lower.contains('air terjun') ||
        lower.contains('air') ||
        lower.contains('gunung')) {
      return 'Alam';
    }

    if (lower.contains('sejarah') || lower.contains('benteng')) {
      return 'Sejarah';
    }

    return namaKategori.trim();
  }

  // =====================================================
  // DATA DESTINASI
  // =====================================================

  List<Map<String, dynamic>> get destinations {
    return _destinasiController.listDestinasi.map((item) {
      return {
        'id': item.idDestinasi,
        'name': item.namaDestinasi,
        'location': item.alamat,
        'category': _normalizeCategory(
          _destinasiController.getNamaKategori(item.idKategori),
        ),
        'image': item.fotoUtama,
      };
    }).toList();
  }

  // =====================================================
  // DATA KATEGORI
  // =====================================================

  List<String> get categories {
    final categoryNames = _destinasiController.listKategori
        .map((kategori) {
          return _normalizeCategory(kategori.namaKategori);
        })
        .where((nama) {
          return nama.trim().isNotEmpty && nama != 'Semua';
        })
        .toSet()
        .toList();

    categoryNames.sort();

    return ['Semua', ...categoryNames];
  }

  // =====================================================
  // FILTER DESTINASI BERANDA
  // =====================================================

  List<Map<String, dynamic>> get filteredDestinations {
    return destinations.where((item) {
      final category = item['category'].toString();

      final matchesCategory =
          selectedCategory == 'Semua' || category == selectedCategory;

      return matchesCategory;
    }).toList();
  }

  // =====================================================
  // DESTINASI FAVORIT
  // =====================================================

  List<Map<String, dynamic>> get favoriteDestinations {
    return destinations.where((item) {
      final id = (item['id'] as num).toInt();

      return favorites.contains(id);
    }).toList();
  }

  // =====================================================
  // TAMBAH / HAPUS FAVORIT DI SUPABASE
  // =====================================================

  Future<void> toggleFavorite(int id) async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      _showFavoriteMessage(
        'Silakan login terlebih dahulu untuk menyimpan destinasi favorit.',
      );
      return;
    }

    if (_isLoadingFavorites) {
      _showFavoriteMessage(
        'Daftar favorit sedang dimuat. Coba lagi sebentar.',
      );
      return;
    }

    if (_favoriteProcessingIds.contains(id)) return;

    // Jika pemuatan sebelumnya gagal, coba muat ulang.
    if (_favoriteLoadError != null) {
      await _loadFavorites();

      if (!mounted) return;

      if (_favoriteLoadError != null) {
        _showFavoriteMessage(
          'Favorit belum dapat dimuat. Silakan coba lagi.',
        );
        return;
      }
    }

    final bool wasFavorite = favorites.contains(id);

    setState(() {
      _favoriteProcessingIds.add(id);
    });

    try {
      if (wasFavorite) {
        // HAPUS FAVORIT
        await _supabase
            .from('favorit')
            .delete()
            .eq('id_user', userId)
            .eq('id_destinasi', id);
      } else {
        // TAMBAH FAVORIT
        await _supabase.from('favorit').insert({
          'id_user': userId,
          'id_destinasi': id,
          'tanggal_ditambah': DateTime.now().toUtc().toIso8601String(),
        });
      }

      if (!mounted) return;

      setState(() {
        if (wasFavorite) {
          favorites.remove(id);
        } else {
          favorites.add(id);
        }
      });

      _showFavoriteMessage(
        wasFavorite
            ? 'Destinasi dihapus dari favorit.'
            : 'Destinasi ditambahkan ke favorit.',
      );
    } catch (error) {
      debugPrint('Gagal mengubah favorit: $error');

      if (!mounted) return;

      _showFavoriteMessage(
        wasFavorite
            ? 'Gagal menghapus destinasi dari favorit.'
            : 'Gagal menambahkan destinasi ke favorit.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _favoriteProcessingIds.remove(id);
        });
      }
    }
  }

  // =====================================================
  // NAVIGASI DETAIL DESTINASI
  // =====================================================

  Future<void> openDetail(int id) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return DetailDestinasiPage(
            destinasiId: id,
            controller: _destinasiController,
          );
        },
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // =====================================================
  // NAVIGASI PENCARIAN
  // =====================================================

  Future<void> openSearchPage() async {
    if (_isLoadingFavorites) {
      await _loadFavorites();
    }

    if (!mounted) return;

    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) {
          return PencarianDestinasiPage(
            controller: _destinasiController,
            favorites: favorites,
            processingFavoriteIds: _favoriteProcessingIds,
            onToggleFavorite: toggleFavorite,
          );
        },
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // =====================================================
  // NAVIGASI PROFIL
  // =====================================================

  Future<void> openProfile() async {
    final hasil = await Navigator.push<int>(
      context,
      MaterialPageRoute<int>(
        builder: (context) => const ProfileUserPage(),
      ),
    );

    if (!mounted) return;

    // Perbarui avatar dan favorit setelah kembali dari Profil.
    await _loadFotoProfil();
    await _loadFavorites();

    if (!mounted || hasil == null) return;

    if (hasil < 0 || hasil > 2) return;

    setState(() {
      selectedBottomIndex = hasil;
    });
  }

  // =====================================================
  // MAIN BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: selectedBottomIndex == 1
                  ? LokasiDestinasiPage(
                      controller: _destinasiController,
                    )
                  : selectedBottomIndex == 2
                      ? _buildFavoritesPage()
                      : _buildHomePage(),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // =====================================================
  // HEADER
  // =====================================================

  Widget _buildHeader() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      color: Colors.white,

      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 37,
            child: CustomPaint(
              painter: TernateLogoPainter(),
            ),
          ),

          const SizedBox(width: 5),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'ternate',
                      style: TextStyle(
                        color: Color(0xFF26364D),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Spot',
                      style: TextStyle(
                        color: primaryBlue,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Text(
                'WISATA KOTA TERNATE',
                style: TextStyle(
                  fontSize: 6.5,
                  color: secondaryText,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const Spacer(),

          IconButton(
            tooltip: 'Profil',
            onPressed: openProfile,
            icon: CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFFE5EFFD),
              child: ClipOval(
                child: _fotoProfil != null
                    ? Image.network(
                        _fotoProfil!,
                        width: 34,
                        height: 34,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 19,
                            color: primaryBlue,
                          );
                        },
                      )
                    : const Icon(
                        Icons.person,
                        size: 19,
                        color: primaryBlue,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // HALAMAN UTAMA
  // =====================================================

  Widget _buildHomePage() {
    return RefreshIndicator(
      onRefresh: _refreshHomeData,
      color: primaryBlue,

      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            _buildGreeting(),

            _buildSearch(),

            const SizedBox(height: 12),

            _buildBanner(),

            const SizedBox(height: 18),

            _buildCategories(),

            const SizedBox(height: 22),

            _buildRecommendations(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // GREETING
  // =====================================================

  Widget _buildGreeting() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 14, 18, 11),

      child: Text(
        'Mau jelajah ke mana hari ini?',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  // =====================================================
  // SEARCH BERANDA
  // =====================================================

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),

      child: Container(
        height: 46,

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: const Color(0xFFE7ECF3),
          ),
        ),

        child: TextField(
          controller: searchController,
          readOnly: true,
          showCursor: false,

          onTap: openSearchPage,

          decoration: const InputDecoration(
            hintText: 'Cari destinasi di Ternate...',

            hintStyle: TextStyle(
              fontSize: 12,
              color: secondaryText,
            ),

            prefixIcon: Icon(
              Icons.search,
              size: 20,
              color: secondaryText,
            ),

            suffixIcon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: secondaryText,
            ),

            border: InputBorder.none,

            contentPadding: EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // BANNER
  // =====================================================

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),

        child: AspectRatio(
          aspectRatio: 2.15,

          child: Stack(
            fit: StackFit.expand,

            children: [
              Image.network(
                'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=1200',

                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0B65B5),
                          Color(0xFF55A6C8),
                        ],
                      ),
                    ),

                    child: const Icon(
                      Icons.landscape_outlined,
                      color: Colors.white,
                      size: 52,
                    ),
                  );
                },
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,

                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 14,
                right: 12,
                bottom: 13,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    const Text(
                      'Jelajahi Keindahan Ternate',

                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Temukan destinasi menarik di sekitar Kota Ternate.',

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      height: 30,

                      child: ElevatedButton(
                        onPressed: openSearchPage,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryBlue,
                          elevation: 0,

                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        child: const Text(
                          'Jelajahi Sekarang',

                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
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
  }

  // =====================================================
  // KATEGORI
  // =====================================================

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text(
            'Kategori Wisata',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: categories.map((category) {
                return _categoryButton(
                  category,
                  _getCategoryIcon(category),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // ICON KATEGORI
  // =====================================================

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Semua':
        return Icons.grid_view_rounded;

      case 'Pantai':
        return Icons.beach_access_outlined;

      case 'Alam':
        return Icons.landscape_outlined;

      case 'Sejarah':
        return Icons.museum_outlined;

      default:
        return Icons.place_outlined;
    }
  }

  // =====================================================
  // BUTTON KATEGORI
  // =====================================================

  Widget _categoryButton(String category, IconData icon) {
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        margin: const EdgeInsets.only(right: 8),

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,

          borderRadius: BorderRadius.circular(22),

          border: Border.all(
            color: isSelected
                ? primaryBlue
                : const Color(0xFFE5E9F1),
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : secondaryText,
            ),

            const SizedBox(width: 5),

            Text(
              category,

              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // REKOMENDASI DESTINASI
  // =====================================================

  Widget _buildRecommendations() {
    if (_destinasiController.isLoading && destinations.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 35),

        child: Center(
          child: CircularProgressIndicator(
            color: primaryBlue,
          ),
        ),
      );
    }

    if (_destinasiController.errorMessage != null &&
        destinations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),

        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 42,
                color: secondaryText,
              ),

              const SizedBox(height: 10),

              const Text(
                'Destinasi belum dapat dimuat.',

                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _destinasiController.errorMessage!,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _destinasiController.refreshData,

                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final results = filteredDestinations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),

          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Rekomendasi Pilihan',

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),

              TextButton(
                onPressed: openSearchPage,

                child: const Text(
                  'Lihat Semua',

                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(18, 0, 18, 12),

          child: Text(
            'Temukan tempat menarik untuk dikunjungi.',

            style: TextStyle(
              fontSize: 11,
              color: secondaryText,
            ),
          ),
        ),

        if (results.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 28,
            ),

            child: Center(
              child: Text(
                'Belum ada destinasi untuk kategori ini.',

                style: TextStyle(
                  fontSize: 12,
                  color: secondaryText,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 267,

            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),

              scrollDirection: Axis.horizontal,

              itemCount: results.length,

              itemBuilder: (context, index) {
                return _destinationCard(results[index]);
              },
            ),
          ),
      ],
    );
  }

  // =====================================================
  // KARTU DESTINASI
  // =====================================================

  Widget _destinationCard(Map<String, dynamic> item) {
    final id = (item['id'] as num).toInt();

    final name = item['name'].toString();
    final category = item['category'].toString();
    final location = item['location'].toString();
    final imageUrl = (item['image'] ?? '').toString();

    final isFavorite = favorites.contains(id);

    final isFavoriteProcessing =
        _isLoadingFavorites || _favoriteProcessingIds.contains(id);

    Color tagBackground;
    Color tagText;

    switch (category) {
      case 'Sejarah':
        tagBackground = const Color(0xFFE5F5EF);
        tagText = const Color(0xFF168567);
        break;

      case 'Pantai':
        tagBackground = const Color(0xFFE5F3FC);
        tagText = const Color(0xFF1675B8);
        break;

      default:
        tagBackground = const Color(0xFFE5F5EF);
        tagText = const Color(0xFF168567);
    }

    return GestureDetector(
      onTap: () {
        openDetail(id);
      },

      child: Container(
        width: 201,

        margin: const EdgeInsets.symmetric(horizontal: 5),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(13),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        clipBehavior: Clip.antiAlias,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,

                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) {
                        return _placeholderImage();
                      },
                    )
                  else
                    _placeholderImage(),

                  Positioned(
                    top: 7,
                    right: 7,

                    child: Material(
                      color: Colors.transparent,

                      child: InkWell(
                        customBorder: const CircleBorder(),

                        onTap: isFavoriteProcessing
                            ? null
                            : () {
                                toggleFavorite(id);
                              },

                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.white,

                          child: isFavoriteProcessing
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: primaryBlue,
                                  ),
                                )
                              : Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 16,
                                  color: isFavorite
                                      ? Colors.red
                                      : secondaryText,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    name,

                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: Color(0xFF287C92),
                      ),

                      const SizedBox(width: 3),

                      Expanded(
                        child: Text(
                          location,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 11,
                            color: secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 9),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: tagBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(
                      category == 'Alam' ? 'Wisata Alam' : category,

                      style: TextStyle(
                        fontSize: 9,
                        color: tagText,
                        fontWeight: FontWeight.w600,
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

  // =====================================================
  // PLACEHOLDER FOTO
  // =====================================================

  Widget _placeholderImage() {
    return Container(
      color: const Color(0xFFE0E7EE),

      alignment: Alignment.center,

      child: const Icon(
        Icons.image_not_supported_outlined,
        color: secondaryText,
        size: 30,
      ),
    );
  }

  // =====================================================
  // HALAMAN FAVORIT
  // =====================================================

  Widget _buildFavoritesPage() {
    final favoriteItems = favoriteDestinations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 20, 18, 15),

          child: Text(
            'Destinasi Favorit',

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),

        Expanded(
          child: _isLoadingFavorites
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primaryBlue,
                  ),
                )
              : _favoriteLoadError != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.cloud_off_outlined,
                              size: 45,
                              color: secondaryText,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Daftar favorit belum dapat dimuat.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _favoriteLoadError!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                color: secondaryText,
                              ),
                            ),
                            TextButton(
                              onPressed: _loadFavorites,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _supabase.auth.currentUser == null
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  size: 48,
                                  color: secondaryText,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Silakan login untuk melihat destinasi favorit.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : favoriteItems.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite_border,
                                    size: 55,
                                    color: secondaryText,
                                  ),

                                  SizedBox(height: 12),

                                  Text(
                                    'Belum ada destinasi favorit',

                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),

                                  SizedBox(height: 5),

                                  Text(
                                    'Klik ikon hati pada destinasi yang kamu sukai.',

                                    textAlign: TextAlign.center,

                                    style: TextStyle(
                                      fontSize: 11,
                                      color: secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 5,
                              ),

                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.78,
                              ),

                              itemCount: favoriteItems.length,

                              itemBuilder: (context, index) {
                                return _destinationCard(
                                  favoriteItems[index],
                                );
                              },
                            ),
        ),
      ],
    );
  }

  // =====================================================
  // BOTTOM NAVIGATION
  // =====================================================

  Widget _buildBottomNavigation() {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Beranda'},
      {'icon': Icons.location_on_outlined, 'label': 'Lokasi'},
      {'icon': Icons.favorite_border, 'label': 'Favorit'},
      {'icon': Icons.person_outline, 'label': 'Profil'},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE)),
        ),
      ),

      child: SafeArea(
        top: false,

        child: SizedBox(
          height: 57,

          child: Row(
            children: List.generate(items.length, (index) {
              final active = selectedBottomIndex == index;

              IconData icon = items[index]['icon'] as IconData;

              if (index == 2 && active) {
                icon = Icons.favorite;
              }

              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (index == 3) {
                      openProfile();
                      return;
                    }

                    setState(() {
                      selectedBottomIndex = index;
                    });
                  },

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(
                        icon,
                        size: 22,

                        color: active ? primaryBlue : secondaryText,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        items[index]['label'] as String,

                        style: TextStyle(
                          fontSize: 10,

                          color: active ? primaryBlue : secondaryText,

                          fontWeight: active
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
        ),
      ),
    );
  }
}

// =====================================================
// LOGO TERNATESPOT
// =====================================================

class TernateLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bluePaint = Paint()
      ..color = const Color(0xFF0875ED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final orangePaint = Paint()
      ..color = const Color(0xFFFFA500)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(2, 28);
    path.lineTo(20, 7);
    path.quadraticBezierTo(22, 4, 25, 8);
    path.lineTo(39, 25);

    path.moveTo(2, 32);
    path.quadraticBezierTo(13, 24, 22, 29);
    path.quadraticBezierTo(30, 35, 41, 29);

    canvas.drawPath(path, bluePaint);

    canvas.drawCircle(const Offset(34, 7), 4.5, orangePaint);
  }

  @override
  bool shouldRepaint(covariant TernateLogoPainter oldDelegate) {
    return false;
  }
}

// =====================================================
// HALAMAN PENCARIAN DESTINASI
// =====================================================

class PencarianDestinasiPage extends StatefulWidget {
  final DestinasiUserController controller;

  final Set<int> favorites;

  final Set<int> processingFavoriteIds;

  final Future<void> Function(int id) onToggleFavorite;

  const PencarianDestinasiPage({
    super.key,
    required this.controller,
    required this.favorites,
    required this.processingFavoriteIds,
    required this.onToggleFavorite,
  });

  @override
  State<PencarianDestinasiPage> createState() =>
      _PencarianDestinasiPageState();
}

class _PencarianDestinasiPageState extends State<PencarianDestinasiPage> {
  final TextEditingController _searchController = TextEditingController();

  final Set<int> _localFavoriteProcessingIds = {};

  String _selectedCategory = 'Semua';

  static const Color primaryBlue = Color(0xFF0875ED);

  static const Color backgroundColor = Color(0xFFF7F8FD);

  static const Color textColor = Color(0xFF17233C);

  static const Color secondaryText = Color(0xFF78869A);

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_refreshPage);
  }

  // =====================================================
  // REFRESH
  // =====================================================

  void _refreshPage() {
    if (!mounted) return;

    setState(() {});
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    widget.controller.removeListener(_refreshPage);

    _searchController.dispose();

    super.dispose();
  }

  // =====================================================
  // NORMALISASI KATEGORI
  // =====================================================

  String _normalizeCategory(String namaKategori) {
    final lower = namaKategori.trim().toLowerCase();

    if (lower.contains('pantai')) {
      return 'Pantai';
    }

    if (lower.contains('alam') ||
        lower.contains('danau') ||
        lower.contains('air terjun') ||
        lower.contains('air') ||
        lower.contains('gunung')) {
      return 'Alam';
    }

    if (lower.contains('sejarah') || lower.contains('benteng')) {
      return 'Sejarah';
    }

    return namaKategori.trim();
  }

  // =====================================================
  // DATA DESTINASI
  // =====================================================

  List<Map<String, dynamic>> get _destinations {
    return widget.controller.listDestinasi.map((item) {
      return {
        'id': item.idDestinasi,
        'name': item.namaDestinasi,
        'location': item.alamat,
        'category': _normalizeCategory(
          widget.controller.getNamaKategori(item.idKategori),
        ),
        'image': item.fotoUtama,
      };
    }).toList();
  }

  // =====================================================
  // DATA KATEGORI
  // =====================================================

  List<String> get _categories {
    final categoryNames = widget.controller.listKategori
        .map((kategori) {
          return _normalizeCategory(kategori.namaKategori);
        })
        .where((nama) {
          return nama.trim().isNotEmpty && nama != 'Semua';
        })
        .toSet()
        .toList();

    categoryNames.sort();

    return ['Semua', ...categoryNames];
  }

  // =====================================================
  // LOGIKA PENCARIAN
  //
  // Pencarian dilakukan pada:
  // 1. Nama destinasi
  // 2. Lokasi/alamat
  // 3. Kategori
  //
  // Jika user mengetik beberapa kata,
  // setiap kata harus ditemukan pada data
  // destinasi tersebut.
  // =====================================================

  List<Map<String, dynamic>> get _filteredDestinations {
    final query = _searchController.text.trim().toLowerCase();

    final keywords = query
        .split(RegExp(r'\s+'))
        .where((word) => word.trim().isNotEmpty)
        .toList();

    return _destinations.where((item) {
      final name = item['name'].toString().trim().toLowerCase();

      final location = item['location'].toString().trim().toLowerCase();

      final category = item['category'].toString().trim().toLowerCase();

      final searchableText = '$name $location $category';

      final matchesSearch =
          keywords.isEmpty ||
          keywords.every((word) {
            return searchableText.contains(word);
          });

      final matchesCategory =
          _selectedCategory == 'Semua' ||
          item['category'] == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // =====================================================
  // ICON KATEGORI
  // =====================================================

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Semua':
        return Icons.grid_view_rounded;

      case 'Pantai':
        return Icons.beach_access_outlined;

      case 'Alam':
        return Icons.landscape_outlined;

      case 'Sejarah':
        return Icons.museum_outlined;

      default:
        return Icons.place_outlined;
    }
  }

  // =====================================================
  // FILTER KATEGORI
  // =====================================================

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,

          borderRadius: BorderRadius.circular(22),

          border: Border.all(
            color: isSelected
                ? primaryBlue
                : const Color(0xFFE5E9F1),
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              _categoryIcon(category),
              size: 14,
              color: isSelected ? Colors.white : secondaryText,
            ),

            const SizedBox(width: 5),

            Text(
              category,

              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // DETAIL DESTINASI
  // =====================================================

  Future<void> _openDetail(int id) async {
    await Navigator.push<void>(
      context,

      MaterialPageRoute<void>(
        builder: (context) {
          return DetailDestinasiPage(
            destinasiId: id,
            controller: widget.controller,
          );
        },
      ),
    );

    if (!mounted) return;

    setState(() {});
  }

  // =====================================================
  // KARTU HASIL PENCARIAN
  // =====================================================

  Widget _buildDestinationCard(Map<String, dynamic> item) {
    final id = (item['id'] as num).toInt();

    final name = item['name'].toString();

    final location = item['location'].toString();

    final category = item['category'].toString();

    final image = (item['image'] ?? '').toString();

    final isFavorite = widget.favorites.contains(id);

    final isFavoriteProcessing =
        widget.processingFavoriteIds.contains(id) ||
        _localFavoriteProcessingIds.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: const Color(0xFFEDF0F5),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: () {
          _openDetail(id);
        },

        child: Padding(
          padding: const EdgeInsets.all(10),

          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),

                child: _buildDestinationImage(image),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      name,

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: primaryBlue,
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            location,

                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,

                            style: const TextStyle(
                              fontSize: 11,
                              color: secondaryText,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3FF),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Text(
                        category,

                        style: const TextStyle(
                          fontSize: 10,
                          color: primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                tooltip: 'Favorit',

                onPressed: isFavoriteProcessing
                    ? null
                    : () async {
                        setState(() {
                          _localFavoriteProcessingIds.add(id);
                        });

                        try {
                          await widget.onToggleFavorite(id);
                        } finally {
                          if (mounted) {
                            setState(() {
                              _localFavoriteProcessingIds.remove(id);
                            });
                          }
                        }
                      },

                icon: isFavoriteProcessing
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: primaryBlue,
                        ),
                      )
                    : Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite ? Colors.red : secondaryText,
                        size: 21,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // FOTO DESTINASI
  // =====================================================

  Widget _buildDestinationImage(String imageUrl) {
    if (imageUrl.trim().isEmpty) {
      return Container(
        width: 105,
        height: 112,

        color: const Color(0xFFE5EAF0),

        child: const Icon(
          Icons.image_not_supported_outlined,
          color: secondaryText,
          size: 30,
        ),
      );
    }

    return Image.network(
      imageUrl,

      width: 105,
      height: 112,

      fit: BoxFit.cover,

      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: 105,
          height: 112,

          color: const Color(0xFFE5EAF0),

          child: const Icon(
            Icons.image_not_supported_outlined,
            color: secondaryText,
            size: 30,
          ),
        );
      },
    );
  }

  // =====================================================
  // HASIL PENCARIAN
  // =====================================================

  Widget _buildResults() {
    if (widget.controller.isLoading &&
        widget.controller.listDestinasi.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: primaryBlue,
        ),
      );
    }

    if (widget.controller.errorMessage != null &&
        widget.controller.listDestinasi.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Icon(
                Icons.cloud_off_outlined,
                size: 45,
                color: secondaryText,
              ),

              const SizedBox(height: 12),

              const Text(
                'Destinasi belum dapat dimuat.',

                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                widget.controller.errorMessage!,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 11,
                  color: secondaryText,
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: widget.controller.refreshData,

                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final results = _filteredDestinations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),

          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Hasil Pencarian',

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),

              Text(
                '${results.length} destinasi ditemukan',

                style: const TextStyle(
                  fontSize: 11,
                  color: secondaryText,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: results.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 48,
                        color: secondaryText,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        _searchController.text.trim().isNotEmpty
                            ? 'Destinasi tidak ditemukan.'
                            : 'Belum ada destinasi tersedia.',

                        style: const TextStyle(
                          fontSize: 13,
                          color: secondaryText,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Coba kata kunci atau kategori lainnya.',

                        style: TextStyle(
                          fontSize: 11,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),

                  itemCount: results.length,

                  itemBuilder: (context, index) {
                    return _buildDestinationCard(results[index]);
                  },
                ),
        ),
      ],
    );
  }

  // =====================================================
  // BUILD PENCARIAN
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,

        foregroundColor: textColor,

        elevation: 0,

        surfaceTintColor: Colors.white,

        title: const Text(
          'Cari Destinasi',

          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),

              child: TextField(
                controller: _searchController,

                autofocus: true,

                onChanged: (value) {
                  setState(() {});
                },

                textInputAction: TextInputAction.search,

                decoration: InputDecoration(
                  hintText: 'Cari nama destinasi atau lokasi...',

                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: secondaryText,
                  ),

                  prefixIcon: const Icon(
                    Icons.search,
                    color: primaryBlue,
                    size: 20,
                  ),

                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();

                            setState(() {});
                          },

                          icon: const Icon(
                            Icons.close,
                            size: 18,
                          ),
                        )
                      : null,

                  filled: true,

                  fillColor: Colors.white,

                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 13,
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),

                    borderSide: const BorderSide(
                      color: Color(0xFFE5E9F1),
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),

                    borderSide: const BorderSide(
                      color: Color(0xFFE5E9F1),
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),

                    borderSide: const BorderSide(
                      color: primaryBlue,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 43,

              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 18),

                scrollDirection: Axis.horizontal,

                itemCount: _categories.length,

                separatorBuilder: (context, index) {
                  return const SizedBox(width: 8);
                },

                itemBuilder: (context, index) {
                  return _buildCategoryChip(_categories[index]);
                },
              ),
            ),

            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }
}
