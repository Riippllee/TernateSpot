import 'package:flutter/material.dart';

import '../../controllers/rekomendasi_controller.dart';
import '../../models/destinasi_model.dart';
import '../../services/destinasi_service.dart';
import '../../utils/profile_update_notifier.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _namaAdmin = 'Admin';
  String? _fotoAdmin;
  final DestinasiService _destinasiService = DestinasiService();

  Map<String, int> _dashboardStats = {};

  bool _isLoadingStats = true;
  String? _statsError;
  final RekomendasiController _rekomendasiController = RekomendasiController();
  @override
  void initState() {
    super.initState();

    _rekomendasiController.addListener(_refreshHome);

    _rekomendasiController.loadRekomendasiAktif();
    _rekomendasiController.loadDestinasi();
    _loadDashboardStatistics();
    _loadNamaAdmin();
    ProfileUpdateNotifier.version.addListener(_onProfileUpdated);
  }

  void _onProfileUpdated() {
    _loadNamaAdmin();
  }

  void _refreshHome() {
    if (mounted) {
      setState(() {});
    }
  }

  String _getTanggalHariIni() {
    final sekarang = DateTime.now();

    const namaHari = [
      'SENIN',
      'SELASA',
      'RABU',
      'KAMIS',
      'JUMAT',
      'SABTU',
      'MINGGU',
    ];

    const namaBulan = [
      'JANUARI',
      'FEBRUARI',
      'MARET',
      'APRIL',
      'MEI',
      'JUNI',
      'JULI',
      'AGUSTUS',
      'SEPTEMBER',
      'OKTOBER',
      'NOVEMBER',
      'DESEMBER',
    ];

    final hari = namaHari[sekarang.weekday - 1];
    final tanggal = sekarang.day;
    final bulan = namaBulan[sekarang.month - 1];
    final tahun = sekarang.year;

    return '$hari, $tanggal $bulan $tahun';
  }

  @override
  void dispose() {
    _rekomendasiController.removeListener(_refreshHome);
    _rekomendasiController.dispose();
    ProfileUpdateNotifier.version.removeListener(_onProfileUpdated);
    super.dispose();
  }

  Future<void> _loadDashboardStatistics() async {
    try {
      final result = await _destinasiService.getDashboardStatistics();

      if (!mounted) return;

      setState(() {
        _dashboardStats = result;
        _isLoadingStats = false;
        _statsError = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingStats = false;
        _statsError = e.toString();
      });
    }
  }

  String _getStatValue(String key) {
    if (_isLoadingStats) return '...';
    if (_statsError != null) return '—';

    return (_dashboardStats[key] ?? 0).toString();
  }

  Future<void> _loadNamaAdmin() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;

      if (userId == null) return;

      final data = await supabase
          .from('user')
          .select('nama, foto_profil')
          .eq('id_user', userId)
          .maybeSingle();
      debugPrint('DATA ADMIN DASHBOARD: $data');

      if (!mounted) return;

      final nama = data?['nama']?.toString().trim();
      final foto = data?['foto_profil']?.toString().trim();

      setState(() {
        _namaAdmin =
            (nama != null &&
                nama.isNotEmpty &&
                nama.toLowerCase() != 'undefined')
            ? nama
            : 'Admin';

        _fotoAdmin = (foto != null && foto.isNotEmpty) ? foto : null;
      });
    } catch (e) {
      debugPrint('Gagal mengambil profil admin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final rekomendasiTampil = <DestinasiModel>[];

    for (final rekomendasi in _rekomendasiController.rekomendasiAktif) {
      final hasil = _rekomendasiController.listDestinasi.where(
        (item) => item.idDestinasi == rekomendasi.idDestinasi && item.status,
      );

      if (hasil.isNotEmpty) {
        rekomendasiTampil.add(hasil.first);
      }

      if (rekomendasiTampil.length >= 6) break;
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0.5,
        titleSpacing: 16,
        title: Row(
          children: [
            // Logo TernateSpot
            CustomPaint(
              size: const Size(32, 24),
              painter: _TernateSpotLogoPainter(),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                    children: [
                      TextSpan(
                        text: 'ternate',
                        style: TextStyle(color: Color(0xFF1D61E7)),
                      ),
                      TextSpan(
                        text: 'Spot',
                        style: TextStyle(color: Color(0xFF1D61E7)),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'WISATA KOTA TERNATE',
                  style: TextStyle(
                    fontSize: 6.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A94A6),
                    letterSpacing: 0.6,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF2C3A4B),
                  size: 24,
                ),
                onPressed: () {},
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1D61E7),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFEBF3FE),
              backgroundImage: _fotoAdmin != null
                  ? NetworkImage(_fotoAdmin!)
                  : null,
              child: _fotoAdmin == null
                  ? const Icon(Icons.person, color: Color(0xFF1D61E7), size: 20)
                  : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Tanggal & Status Sistem
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getTanggalHariIni(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8A94A6),
                      letterSpacing: 0.8,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBF3FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1D61E7),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Sistem Normal',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D61E7),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Header Halo Admin
              Text(
                'Halo, $_namaAdmin! 👋',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A212A),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Ringkasan aktivitas pariwisata hari ini.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),
              // Grid Kartu Statistik 2x2
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,

                children: [
                  _buildStatCard(
                    icon: Icons.people_outline_rounded,
                    iconBgColor: const Color(0xFFEBF3FE),
                    iconColor: const Color(0xFF1D61E7),
                    badgeText: 'Database',
                    badgeBgColor: const Color(0xFFEBF3FE),
                    badgeTextColor: const Color(0xFF1D61E7),
                    value: _getStatValue('total_pengguna'),
                    label: 'Total Pengguna',
                  ),

                  _buildStatCard(
                    icon: Icons.explore_outlined,
                    iconBgColor: const Color(0xFFEBF3FE),
                    iconColor: const Color(0xFF1D61E7),
                    badgeText: 'Database',
                    badgeBgColor: const Color(0xFFEBF3FE),
                    badgeTextColor: const Color(0xFF1D61E7),
                    value: _getStatValue('total_destinasi'),
                    label: 'Total Destinasi',
                  ),

                  _buildStatCard(
                    icon: Icons.star_outline_rounded,
                    iconBgColor: const Color(0xFFEBF3FE),
                    iconColor: const Color(0xFF1D61E7),
                    badgeText: 'Database',
                    badgeBgColor: const Color(0xFFEBF3FE),
                    badgeTextColor: const Color(0xFF1D61E7),
                    value: _getStatValue('total_ulasan'),
                    label: 'Total Ulasan',
                  ),

                  _buildStatCard(
                    icon: Icons.collections_outlined,
                    iconBgColor: const Color(0xFFEBF3FE),
                    iconColor: const Color(0xFF1D61E7),
                    badgeText: 'Database',
                    badgeBgColor: const Color(0xFFEBF3FE),
                    badgeTextColor: const Color(0xFF1D61E7),
                    value: _getStatValue('total_foto'),
                    label: 'Koleksi Foto',
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Header Rekomendasi Destinasi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.donut_large_outlined,
                        size: 18,
                        color: Color(0xFF1D61E7),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Rekomendasi Destinasi',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A212A),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D61E7),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Rekomendasi Destinasi dari Supabase
              if (_rekomendasiController.isLoading ||
                  _rekomendasiController.isLoadingDestinasi)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (rekomendasiTampil.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Belum ada destinasi yang dipilih sebagai rekomendasi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF718096)),
                  ),
                )
              else
                ...List.generate(rekomendasiTampil.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildDestinationListItem(
                      destinasi: rekomendasiTampil[index],
                      rank: '#${index + 1}',
                    ),
                  );
                }),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar Admin (Dashboard, Destinasi, Users, Review, Profil)
    );
  }

  // Widget Kartu Statistik ringkas
  Widget _buildStatCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String badgeText,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A212A),
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF718096),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationListItem({
    required DestinasiModel destinasi,
    required String rank,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: destinasi.fotoUtama.isNotEmpty
                    ? Image.network(
                        destinasi.fotoUtama,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Container(
                          width: 60,
                          height: 60,
                          color: const Color(0xFFEAF0F6),
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: const Color(0xFFEAF0F6),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                        ),
                      ),
              ),
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    rank,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destinasi.namaDestinasi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A212A),
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: Color(0xFF718096),
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        destinasi.alamat,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF718096),
                          fontFamily: 'Poppins',
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
    );
  }
}

// Logo Custom Painter TernateSpot
class _TernateSpotLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = const Color(0xFF1D61E7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaint = Paint()
      ..color = const Color(0xFFFF9800)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.05, size.height * 0.70);
    path.lineTo(size.width * 0.40, size.height * 0.20);
    path.lineTo(size.width * 0.70, size.height * 0.70);
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.90,
      size.width * 0.95,
      size.height * 0.70,
    );

    canvas.drawPath(path, strokePaint);

    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.30),
      size.width * 0.10,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
