import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/destinasi_user_controller.dart';

import 'package:ternatespot/views/destinasi/detail_destinasi_page.dart';
import 'package:ternatespot/views/destinasi/lokasi_destinasi_page.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  // ==========================================
  // CONTROLLER DAN STATE
  // ==========================================

  final TextEditingController searchController = TextEditingController();

  final SupabaseClient _supabase = Supabase.instance.client;

  late final DestinasiUserController _destinasiController;

  String searchQuery = '';
  String selectedCategory = 'Semua';

  int selectedBottomIndex = 0;

  final Set<int> favorites = {};
  final Set<int> _favoriteProcessing = {};

  bool _isLoadingFavorites = false;
  String? _favoriteError;

  // ==========================================
  // WARNA APLIKASI
  // ==========================================

  static const Color primaryBlue = Color(0xFF0875ED);
  static const Color backgroundColor = Color(0xFFF7F8FD);
  static const Color textColor = Color(0xFF17233C);
  static const Color secondaryText = Color(0xFF78869A);

  // ==========================================
  // INIT STATE
  // ==========================================

  @override
  void initState() {
    super.initState();

    _destinasiController = DestinasiUserController();

    _destinasiController.addListener(_refreshPage);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _destinasiController.loadData();
      _loadFavorites();
    });
  }

  void _refreshPage() {
    if (!mounted) return;

    setState(() {});
  }

  // ==========================================
  // MEMUAT DATA FAVORIT
  // ==========================================

  Future<void> _loadFavorites() async {
    if (!mounted) return;

    final user = _supabase.auth.currentUser;

    if (user == null) {
      setState(() {
        favorites.clear();
        _isLoadingFavorites = false;
        _favoriteError = null;
      });

      return;
    }

    final userId = user.id;

    setState(() {
      _isLoadingFavorites = true;
      _favoriteError = null;
    });

    try {
      final response = await _supabase
          .from('favorit')
          .select('id_destinasi')
          .eq('id_user', userId);

      final loadedFavorites = <int>{};

      for (final item in response) {
        final id = item['id_destinasi'];

        if (id is num) {
          loadedFavorites.add(id.toInt());
        }
      }

      if (!mounted || _supabase.auth.currentUser?.id != userId) return;

      setState(() {
        favorites
          ..clear()
          ..addAll(loadedFavorites);
      });
    } catch (error) {
      debugPrint('Gagal memuat favorit: $error');

      if (!mounted) return;

      setState(() {
        _favoriteError = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingFavorites = false;
        });
      }
    }
  }

  // ==========================================
  // TAMBAH DAN HAPUS FAVORIT
  // ==========================================

  Future<void> toggleFavorite(int id) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan login terlebih dahulu untuk menyimpan favorit.',
          ),
        ),
      );

      return;
    }

    if (_favoriteProcessing.contains(id)) return;

    final wasFavorite = favorites.contains(id);

    setState(() {
      _favoriteProcessing.add(id);
    });

    try {
      if (wasFavorite) {
        await _supabase
            .from('favorit')
            .delete()
            .eq('id_user', user.id)
            .eq('id_destinasi', id);

        if (!mounted) return;

        setState(() {
          favorites.remove(id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Destinasi dihapus dari favorit.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final existing = await _supabase
            .from('favorit')
            .select('id_destinasi')
            .eq('id_user', user.id)
            .eq('id_destinasi', id)
            .limit(1);

        if (existing.isEmpty) {
          await _supabase.from('favorit').insert({
            'id_user': user.id,
            'id_destinasi': id,
            'tanggal_ditambah': DateTime.now().toUtc().toIso8601String(),
          });
        }

        if (!mounted) return;

        setState(() {
          favorites.add(id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Destinasi berhasil ditambahkan ke favorit.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      debugPrint('Gagal memperbarui favorit: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui favorit: $error'),
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _favoriteProcessing.remove(id);
        });
      }
    }
  }

  // ==========================================
  // NORMALISASI KATEGORI
  // ==========================================

  String _normalizeCategory(String namaKategori) {
    final lower = namaKategori.toLowerCase();

    if (lower.contains('pantai')) {
      return 'Pantai';
    }

    if (lower.contains('alam') ||
        lower.contains('danau') ||
        lower.contains('air') ||
        lower.contains('gunung')) {
      return 'Alam';
    }

    if (lower.contains('sejarah') || lower.contains('benteng')) {
      return 'Sejarah';
    }

    return namaKategori;
  }

  // ==========================================
  // DATA DESTINASI DARI SUPABASE
  // ==========================================

  List<Map<String, dynamic>> get destinations {
    return _destinasiController.listDestinasi.map((item) {
      return {
        'id': item.idDestinasi,
        'name': item.namaDestinasi,
        'location': item.alamat,
        'category': _normalizeCategory(
          _destinasiController.getNamaKategori(item.idKategori),
        ),
        'rating': '',
        'image': item.fotoUtama,
      };
    }).toList();
  }

  // ==========================================
  // FILTER PENCARIAN DAN KATEGORI BERANDA
  // ==========================================

  List<Map<String, dynamic>> get filteredDestinations {
    return destinations.where((item) {
      final name = item['name'].toString().toLowerCase();
      final location = item['location'].toString().toLowerCase();

      final query = searchQuery.trim().toLowerCase();

      final matchesSearch = name.contains(query) || location.contains(query);

      final matchesCategory =
          selectedCategory == 'Semua' || item['category'] == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // ==========================================
  // DATA DESTINASI FAVORIT
  // ==========================================

  List<Map<String, dynamic>> get favoriteDestinations {
    return destinations.where((item) {
      final id = (item['id'] as num).toInt();

      return favorites.contains(id);
    }).toList();
  }

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    searchController.dispose();

    _destinasiController.removeListener(_refreshPage);
    _destinasiController.dispose();

    super.dispose();
  }

  // ==========================================
  // MAIN BUILD
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: selectedBottomIndex == 2
                  ? _buildFavoritesPage()
                  : selectedBottomIndex == 1
                  ? LokasiDestinasiPage(controller: _destinasiController)
                  : RefreshIndicator(
                      onRefresh: _destinasiController.refreshData,
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
                            const SizedBox(height: 14),
                            _buildCategories(),
                            const SizedBox(height: 22),
                            _buildRecommendations(),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ==========================================
  // HEADER
  // ==========================================

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
            child: CustomPaint(painter: TernateLogoPainter()),
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
          Stack(
            children: [
              const Icon(
                Icons.notifications_none,
                size: 24,
                color: Color(0xFF26364D),
              ),
              Positioned(
                right: 1,
                top: 1,
                child: Container(
                  height: 6,
                  width: 6,
                  decoration: const BoxDecoration(
                    color: primaryBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFE5EFFD),
            child: Icon(Icons.person, size: 18, color: primaryBlue),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // GREETING
  // ==========================================

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

  // ==========================================
  // NAVIGASI KE HALAMAN PENCARIAN
  // ==========================================

  Future<void> _openSearchPage() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) => PencarianDestinasiPage(
          controller: _destinasiController,
          favorites: favorites,
          onToggleFavorite: toggleFavorite,
          onRefreshFavorites: _loadFavorites,
        ),
      ),
    );

    if (!mounted) return;

    await _loadFavorites();
  }

  // ==========================================
  // SEARCH BERANDA
  // ==========================================

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFE7ECF3)),
        ),
        child: TextField(
          controller: searchController,
          readOnly: true,
          showCursor: false,
          onTap: _openSearchPage,
          decoration: const InputDecoration(
            hintText: 'Cari destinasi di Ternate...',
            hintStyle: TextStyle(fontSize: 12, color: secondaryText),
            prefixIcon: Icon(Icons.search, size: 20, color: secondaryText),
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

  // ==========================================
  // BANNER BERANDA
  // ==========================================

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
                        colors: [Color(0xFF0B65B5), Color(0xFF55A6C8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
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
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedBottomIndex = 0;
                            selectedCategory = 'Semua';
                            searchQuery = '';
                            searchController.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryBlue,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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

  // ==========================================
  // KATEGORI DESTINASI
  // ==========================================

  Widget _buildCategories() {
    final categoryNames = _destinasiController.listKategori
        .map((kategori) => _normalizeCategory(kategori.namaKategori))
        .where((nama) => nama.trim().isNotEmpty && nama != 'Semua')
        .toSet()
        .toList();

    final categories = <String>['Semua', ...categoryNames];

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
                return _categoryButton(category, _getCategoryIcon(category));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? primaryBlue : const Color(0xFFE5E9F1),
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

  // ==========================================
  // REKOMENDASI DESTINASI
  // ==========================================

  Widget _buildRecommendations() {
    if (_destinasiController.isLoading &&
        _destinasiController.listDestinasi.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 35),
        child: Center(child: CircularProgressIndicator(color: primaryBlue)),
      );
    }

    if (_destinasiController.errorMessage != null &&
        _destinasiController.listDestinasi.isEmpty) {
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
                style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                _destinasiController.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: secondaryText, fontSize: 11),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _destinasiController.refreshData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                ),
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
                onPressed: _openSearchPage,
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
            style: TextStyle(fontSize: 11, color: secondaryText),
          ),
        ),
        if (results.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.search_off, size: 38, color: secondaryText),
                  const SizedBox(height: 8),
                  Text(
                    searchQuery.isNotEmpty
                        ? 'Destinasi tidak ditemukan.'
                        : 'Belum ada destinasi untuk kategori ini.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: secondaryText),
                  ),
                ],
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

  // ==========================================
  // HALAMAN FAVORIT USER
  // ==========================================

  Widget _buildFavoritesPage() {
    final favoriteItems = favoriteDestinations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 15),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Destinasi Favorit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: _loadFavorites,
                icon: const Icon(Icons.refresh, color: primaryBlue),
                tooltip: 'Muat ulang favorit',
              ),
            ],
          ),
        ),

        if (_isLoadingFavorites ||
            (_destinasiController.isLoading && destinations.isEmpty))
          const Expanded(
            child: Center(child: CircularProgressIndicator(color: primaryBlue)),
          )
        else if (_supabase.auth.currentUser == null)
          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline, size: 55, color: secondaryText),
                  SizedBox(height: 12),
                  Text(
                    'Silakan login terlebih dahulu.',
                    style: TextStyle(fontSize: 14, color: secondaryText),
                  ),
                ],
              ),
            ),
          )
        else if (_favoriteError != null)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
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
                      'Gagal memuat favorit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _favoriteError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        color: secondaryText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadFavorites,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else if (favoriteItems.isEmpty)
          const Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 55, color: secondaryText),
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
                    style: TextStyle(fontSize: 11, color: secondaryText),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    '${favoriteItems.length} destinasi tersimpan',
                    style: const TextStyle(fontSize: 12, color: secondaryText),
                  ),
                ),
                SizedBox(
                  height: 267,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    scrollDirection: Axis.horizontal,
                    itemCount: favoriteItems.length,
                    itemBuilder: (context, index) {
                      return _destinationCard(favoriteItems[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ==========================================
  // KARTU DESTINASI BERANDA
  // ==========================================

  Widget _destinationCard(Map<String, dynamic> item) {
    final id = (item['id'] as num).toInt();
    final name = item['name'] as String;
    final category = item['category'] as String;
    final imageUrl = (item['image'] ?? '').toString();
    final rating = (item['rating'] ?? '').toString();

    final isFavorite = favorites.contains(id);
    final isProcessing = _favoriteProcessing.contains(id);

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
      onTap: () async {
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (context) => DetailDestinasiPage(
              destinasiId: id,
              controller: _destinasiController,
            ),
          ),
        );

        if (!mounted) return;

        await _loadFavorites();
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
                        return Container(
                          color: const Color(0xFFE0E7EE),
                          child: const Icon(
                            Icons.image_not_supported,
                            color: secondaryText,
                          ),
                        );
                      },
                    )
                  else
                    Container(
                      color: const Color(0xFFE0E7EE),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: secondaryText,
                      ),
                    ),

                  if (rating.isNotEmpty)
                    Positioned(
                      top: 7,
                      left: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: Color(0xFFFFB300),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              rating,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  Positioned(
                    top: 7,
                    right: 7,
                    child: GestureDetector(
                      onTap: isProcessing ? null : () => toggleFavorite(id),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: isProcessing
                            ? const SizedBox(
                                width: 13,
                                height: 13,
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
                                color: isFavorite ? Colors.red : secondaryText,
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
                          item['location'].toString(),
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

  // ==========================================
  // BOTTOM NAVIGATION
  // ==========================================

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
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 57,
          child: Row(
            children: List.generate(items.length, (index) {
              final active = selectedBottomIndex == index;

              final IconData icon;

              if (index == 2 && active) {
                icon = Icons.favorite;
              } else {
                icon = items[index]['icon'] as IconData;
              }

              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (index == 0 || index == 1 || index == 2) {
                      setState(() {
                        selectedBottomIndex = index;
                      });

                      if (index == 2) {
                        _loadFavorites();
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Halaman ${items[index]['label']} belum dihubungkan.',
                          ),
                        ),
                      );
                    }
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

// ==========================================
// LOGO TERNATESPOT
// ==========================================

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

// ==========================================
// HALAMAN PENCARIAN DESTINASI
// ==========================================

class PencarianDestinasiPage extends StatefulWidget {
  final DestinasiUserController controller;
  final Set<int> favorites;
  final Future<void> Function(int id) onToggleFavorite;
  final Future<void> Function() onRefreshFavorites;

  const PencarianDestinasiPage({
    super.key,
    required this.controller,
    required this.favorites,
    required this.onToggleFavorite,
    required this.onRefreshFavorites,
  });

  @override
  State<PencarianDestinasiPage> createState() => _PencarianDestinasiPageState();
}

class _PencarianDestinasiPageState extends State<PencarianDestinasiPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Semua';

  static const Color primaryBlue = Color(0xFF0875ED);
  static const Color backgroundColor = Color(0xFFF7F8FD);
  static const Color textColor = Color(0xFF17233C);
  static const Color secondaryText = Color(0xFF78869A);

  // ==========================================
  // INIT STATE
  // ==========================================

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_refreshPage);
  }

  void _refreshPage() {
    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refreshPage);
    _searchController.dispose();

    super.dispose();
  }

  // ==========================================
  // NORMALISASI KATEGORI
  // ==========================================

  String _normalizeCategory(String namaKategori) {
    final lower = namaKategori.toLowerCase();

    if (lower.contains('pantai')) {
      return 'Pantai';
    }

    if (lower.contains('alam') ||
        lower.contains('danau') ||
        lower.contains('air') ||
        lower.contains('gunung')) {
      return 'Alam';
    }

    if (lower.contains('sejarah') || lower.contains('benteng')) {
      return 'Sejarah';
    }

    return namaKategori;
  }

  // ==========================================
  // DATA DESTINASI
  // ==========================================

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

  // ==========================================
  // DAFTAR KATEGORI
  // ==========================================

  List<String> get _categories {
    final categoryNames = widget.controller.listKategori
        .map((kategori) => _normalizeCategory(kategori.namaKategori))
        .where((nama) => nama.trim().isNotEmpty && nama != 'Semua')
        .toSet()
        .toList();

    return ['Semua', ...categoryNames];
  }

  // ==========================================
  // FILTER PENCARIAN
  // ==========================================

  List<Map<String, dynamic>> get _filteredDestinations {
    final query = _searchController.text.trim().toLowerCase();

    return _destinations.where((item) {
      final name = item['name'].toString().toLowerCase();
      final location = item['location'].toString().toLowerCase();
      final category = item['category'].toString().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          name.contains(query) ||
          location.contains(query) ||
          category.contains(query);

      final matchesCategory =
          _selectedCategory == 'Semua' || item['category'] == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // ==========================================
  // IKON KATEGORI
  // ==========================================

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

  // ==========================================
  // TOMBOL KATEGORI
  // ==========================================

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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? primaryBlue : const Color(0xFFE5E9F1),
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

  // ==========================================
  // FOTO DESTINASI
  // ==========================================

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

  // ==========================================
  // KARTU HASIL PENCARIAN
  // ==========================================

  Widget _buildDestinationCard(Map<String, dynamic> item) {
    final id = (item['id'] as num).toInt();

    final name = item['name'].toString();
    final location = item['location'].toString();
    final category = item['category'].toString();
    final image = (item['image'] ?? '').toString();

    final isFavorite = widget.favorites.contains(id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDF0F5)),
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
        onTap: () async {
          await Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (context) => DetailDestinasiPage(
                destinasiId: id,
                controller: widget.controller,
              ),
            ),
          );

          if (!mounted) return;

          await widget.onRefreshFavorites();

          if (mounted) {
            setState(() {});
          }
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
                onPressed: () async {
                  await widget.onToggleFavorite(id);

                  if (mounted) {
                    setState(() {});
                  }
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
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

  // ==========================================
  // HASIL PENCARIAN
  // ==========================================

  Widget _buildResults() {
    if (widget.controller.isLoading &&
        widget.controller.listDestinasi.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: primaryBlue));
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
                style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
              ),
              const SizedBox(height: 10),
              Text(
                widget.controller.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: secondaryText),
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
                style: const TextStyle(fontSize: 11, color: secondaryText),
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
                        _searchController.text.isNotEmpty
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
                        style: TextStyle(fontSize: 11, color: secondaryText),
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

  // ==========================================
  // BUILD HALAMAN PENCARIAN
  // ==========================================

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
            // KOLOM PENCARIAN
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
                          icon: const Icon(Icons.close, size: 18),
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFFE5E9F1)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Color(0xFFE5E9F1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: primaryBlue),
                  ),
                ),
              ),
            ),

            // FILTER KATEGORI
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

            // HASIL DESTINASI
            Expanded(child: _buildResults()),
          ],
        ),
      ),
    );
  }
}
