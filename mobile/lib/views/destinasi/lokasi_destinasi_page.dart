import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../controllers/destinasi_user_controller.dart';
import '../../models/destinasi_user_model.dart';
import 'detail_destinasi_page.dart';

class LokasiDestinasiPage extends StatefulWidget {
  final DestinasiUserController controller;

  const LokasiDestinasiPage({super.key, required this.controller});

  @override
  State<LokasiDestinasiPage> createState() => _LokasiDestinasiPageState();
}

class _LokasiDestinasiPageState extends State<LokasiDestinasiPage> {
  // ==========================================
  // CONTROLLER DAN STATE
  // ==========================================

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  DestinasiUserModel? _selectedDestination;

  bool _mapReady = false;

  // ==========================================
  // WARNA TERNATESPOT
  // ==========================================

  static const Color primaryBlue = Color(0xFF0875ED);
  static const Color backgroundColor = Color(0xFFF7F8FD);
  static const Color textColor = Color(0xFF17233C);
  static const Color secondaryText = Color(0xFF78869A);

  // Titik tengah Kota Ternate.
  static const LatLng ternateCenter = LatLng(0.7906, 127.3842);

  // ==========================================
  // INIT STATE
  // ==========================================

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_refreshPage);
  }

  @override
  void didUpdateWidget(covariant LokasiDestinasiPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_refreshPage);
      widget.controller.addListener(_refreshPage);
    }
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

  String _getCategory(DestinasiUserModel item) {
    return _normalizeCategory(
      widget.controller.getNamaKategori(item.idKategori),
    );
  }

  // ==========================================
  // VALIDASI KOORDINAT
  // ==========================================

  bool _hasValidCoordinates(DestinasiUserModel item) {
    final latitude = item.latitude;
    final longitude = item.longitude;

    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180 &&
        !(latitude == 0 && longitude == 0);
  }

  // ==========================================
  // DATA DESTINASI DENGAN KOORDINAT
  // ==========================================

  List<DestinasiUserModel> get _destinationsWithCoordinates {
    return widget.controller.listDestinasi.where(_hasValidCoordinates).toList();
  }

  // ==========================================
  // DATA KATEGORI
  // ==========================================

  List<String> get _categories {
    final categoryNames = widget.controller.listKategori
        .map((item) => _normalizeCategory(item.namaKategori))
        .where((name) => name.trim().isNotEmpty && name != 'Semua')
        .toSet()
        .toList();

    return ['Semua', ...categoryNames];
  }

  // ==========================================
  // FILTER DESTINASI
  // ==========================================

  List<DestinasiUserModel> get _filteredDestinations {
    final query = _searchQuery.trim().toLowerCase();

    return _destinationsWithCoordinates.where((item) {
      final name = item.namaDestinasi.toLowerCase();
      final address = item.alamat.toLowerCase();
      final category = _getCategory(item).toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          name.contains(query) ||
          address.contains(query) ||
          category.contains(query);

      final matchesCategory =
          _selectedCategory == 'Semua' ||
          _getCategory(item) == _selectedCategory;

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
  // FILTER KATEGORI
  // ==========================================

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _selectedDestination = null;
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
  // MEMILIH DESTINASI PADA PETA
  // ==========================================

  void _selectDestination(DestinasiUserModel item) {
    setState(() {
      _selectedDestination = item;
    });

    if (_mapReady) {
      _mapController.move(LatLng(item.latitude, item.longitude), 15);
    }
  }

  // ==========================================
  // KEMBALI KE PUSAT KOTA TERNATE
  // ==========================================

  void _moveToTernate() {
    if (!_mapReady) return;

    _mapController.move(ternateCenter, 12.5);

    setState(() {
      _selectedDestination = null;
    });
  }

  // ==========================================
  // MEMUAT ULANG DATA
  // ==========================================

  Future<void> _refreshData() async {
    setState(() {
      _selectedDestination = null;
    });

    await widget.controller.refreshData();
  }

  // ==========================================
  // MEMBUKA DETAIL DESTINASI
  // ==========================================

  void _openDetail(DestinasiUserModel item) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (context) {
          return DetailDestinasiPage(
            destinasiId: item.idDestinasi,
            controller: widget.controller,
          );
        },
      ),
    );
  }

  // ==========================================
  // PENCARIAN
  // ==========================================

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFFE5E9F1)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
              _selectedDestination = null;
            });
          },
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Cari destinasi atau lokasi...',
            hintStyle: const TextStyle(fontSize: 12, color: secondaryText),
            prefixIcon: const Icon(Icons.search, size: 20, color: primaryBlue),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();

                      setState(() {
                        _searchQuery = '';
                        _selectedDestination = null;
                      });
                    },
                    icon: const Icon(Icons.close, size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // KATEGORI
  // ==========================================

  Widget _buildCategories() {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          return _buildCategoryChip(_categories[index]);
        },
      ),
    );
  }

  // ==========================================
  // MARKER PETA
  // ==========================================

  List<Marker> _buildMarkers() {
    return _filteredDestinations.map((item) {
      final isSelected = _selectedDestination?.idDestinasi == item.idDestinasi;

      return Marker(
        point: LatLng(item.latitude, item.longitude),
        width: 48,
        height: 52,
        child: GestureDetector(
          onTap: () {
            _selectDestination(item);
          },
          child: Icon(
            Icons.location_pin,
            size: isSelected ? 49 : 43,
            color: isSelected ? primaryBlue : const Color(0xFFE53935),
            shadows: const [
              Shadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  // ==========================================
  // KONTROL PETA
  // ==========================================

  Widget _buildMapControl() {
    return Material(
      color: Colors.white,
      elevation: 3,
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: _moveToTernate,
        tooltip: 'Kembali ke Ternate',
        icon: const Icon(Icons.my_location, color: primaryBlue, size: 21),
      ),
    );
  }

  // ==========================================
  // STATUS PETA
  // ==========================================

  Widget? _buildMapStatus() {
    if (widget.controller.isLoading &&
        widget.controller.listDestinasi.isEmpty) {
      return _statusCard(
        icon: Icons.map_outlined,
        message: 'Memuat lokasi destinasi...',
        showLoading: true,
      );
    }

    if (widget.controller.errorMessage != null &&
        widget.controller.listDestinasi.isEmpty) {
      return _statusCard(
        icon: Icons.cloud_off_outlined,
        message: 'Gagal memuat data destinasi.',
        description: widget.controller.errorMessage,
        buttonText: 'Coba Lagi',
        onPressed: _refreshData,
      );
    }

    if (widget.controller.listDestinasi.isEmpty) {
      return _statusCard(
        icon: Icons.location_off_outlined,
        message: 'Belum ada destinasi tersedia.',
        description: 'Data destinasi belum tersedia.',
      );
    }

    if (_destinationsWithCoordinates.isEmpty) {
      return _statusCard(
        icon: Icons.location_off_outlined,
        message: 'Koordinat destinasi belum tersedia.',
        description:
            'Pastikan latitude dan longitude setiap destinasi '
            'sudah diisi dengan benar di database.',
        buttonText: 'Muat Ulang',
        onPressed: _refreshData,
      );
    }

    return null;
  }

  Widget _statusCard({
    required IconData icon,
    required String message,
    String? description,
    bool showLoading = false,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showLoading)
            const CircularProgressIndicator(color: primaryBlue)
          else
            Icon(icon, color: secondaryText, size: 42),
          const SizedBox(height: 14),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 7),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: secondaryText,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ],
          if (buttonText != null && onPressed != null) ...[
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: Text(buttonText),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // KARTU INFORMASI DESTINASI TERPILIH
  // ==========================================

  Widget _buildSelectedDestinationCard(DestinasiUserModel item) {
    final imageUrl = item.fotoUtama.trim();
    final category = _getCategory(item);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 78,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _imagePlaceholder();
                    },
                  )
                : _imagePlaceholder(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaDestinasi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: primaryBlue,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.alamat,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                SizedBox(
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: () => _openDetail(item),
                    icon: const Icon(Icons.info_outline, size: 15),
                    label: const Text(
                      'Lihat Detail',
                      style: TextStyle(fontSize: 10),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDestination = null;
              });
            },
            icon: const Icon(Icons.close, size: 18, color: secondaryText),
            tooltip: 'Tutup informasi',
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KARTU RINGKASAN PETA
  // ==========================================

  Widget _buildMapSummary() {
    final total = _filteredDestinations.length;
    final totalWithoutCoordinates =
        widget.controller.listDestinasi.length -
        _destinationsWithCoordinates.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.location_on, color: primaryBlue, size: 23),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$total destinasi tampil di peta',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  total == 0
                      ? 'Tidak ada destinasi sesuai pencarian.'
                      : 'Ketuk penanda untuk melihat informasi.',
                  style: const TextStyle(fontSize: 10, color: secondaryText),
                ),
                if (totalWithoutCoordinates > 0) ...[
                  const SizedBox(height: 3),
                  Text(
                    '$totalWithoutCoordinates destinasi belum memiliki '
                    'koordinat valid.',
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFFD97706),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: _refreshData,
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh, color: primaryBlue),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // PLACEHOLDER FOTO
  // ==========================================

  Widget _imagePlaceholder() {
    return Container(
      width: 78,
      height: 90,
      color: const Color(0xFFE5EAF0),
      child: const Icon(
        Icons.image_not_supported_outlined,
        size: 28,
        color: secondaryText,
      ),
    );
  }

  // ==========================================
  // TAMPILAN PETA
  // ==========================================

  Widget _buildMap() {
    final markers = _buildMarkers();
    final mapStatus = _buildMapStatus();

    return Stack(
      children: [
        Positioned.fill(
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: ternateCenter,
              initialZoom: 12.5,
              minZoom: 10,
              maxZoom: 18,
              onMapReady: () {
                if (!mounted) return;

                setState(() {
                  _mapReady = true;
                });
              },
              onTap: (tapPosition, point) {
                if (_selectedDestination != null) {
                  setState(() {
                    _selectedDestination = null;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ternatespot',
              ),
              MarkerLayer(markers: markers),
              RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                attributions: const [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),
        ),

        // TOMBOL KEMBALI KE TERNATE
        Positioned(top: 12, right: 12, child: _buildMapControl()),

        // STATUS DATA
        if (mapStatus != null)
          Positioned.fill(
            child: Container(
              color: Colors.white.withValues(alpha: 0.65),
              child: Center(child: mapStatus),
            ),
          ),

        // KARTU DESTINASI TERPILIH
        Positioned(
          left: 12,
          right: 12,
          bottom: 12,
          child: _selectedDestination != null
              ? _buildSelectedDestinationCard(_selectedDestination!)
              : _buildMapSummary(),
        ),
      ],
    );
  }

  // ==========================================
  // BUILD HALAMAN LOKASI
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // JUDUL
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 17, 18, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi Destinasi',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Temukan lokasi wisata di Kota Ternate.',
                        style: TextStyle(fontSize: 11, color: secondaryText),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _refreshData,
                  tooltip: 'Muat ulang destinasi',
                  icon: const Icon(Icons.refresh, color: primaryBlue),
                ),
              ],
            ),
          ),

          // PENCARIAN
          _buildSearchField(),

          const SizedBox(height: 11),

          // KATEGORI
          _buildCategories(),

          const SizedBox(height: 10),

          // PETA
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(17),
              ),
              child: _buildMap(),
            ),
          ),
        ],
      ),
    );
  }
}