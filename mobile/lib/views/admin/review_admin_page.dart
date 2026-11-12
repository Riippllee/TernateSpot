import 'package:flutter/material.dart';

import '../../controllers/review_admin_controller.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final ReviewAdminController _controller = ReviewAdminController();

  String _formatTanggal(String? tanggal) {
    if (tanggal == null || tanggal.isEmpty) {
      return '-';
    }

    try {
      final date = DateTime.parse(tanggal).toLocal();

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    } catch (e) {
      return '-';
    }
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onReviewChanged);
    _controller.loadUlasan();
  }

  void _onReviewChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onReviewChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
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
          const Padding(
            padding: EdgeInsets.only(right: 16, left: 4),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=5'),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Judul Halaman
                  const Text(
                    'Ulasan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A212A),
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Search Bar & Dropdown Rating Filter
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: _controller.searchUlasan,
                            decoration: const InputDecoration(
                              hintText: 'Cari destinasi atau user...',
                              hintStyle: TextStyle(
                                color: Color(0xFFA0AEC0),
                                fontSize: 13,
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Color(0xFFA0AEC0),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xFF1D61E7),
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Rating',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A5568),
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(0xFF718096),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Filter Tab Horizontal (Perlu Moderasi, Disetujui, Dilaporkan/Spam)

                  // Filter status ulasan.
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatusTab(
                          label: 'Semua',
                          count: _controller.jumlahSemua,
                          status: null,
                        ),

                        const SizedBox(width: 8),

                        _buildStatusTab(
                          label: 'Ditampilkan',
                          count: _controller.jumlahDitampilkan,
                          status: true,
                        ),

                        const SizedBox(width: 8),

                        _buildStatusTab(
                          label: 'Disembunyikan',
                          count: _controller.jumlahDisembunyikan,
                          status: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Kartu Ulasan 1: Dimas Aditya

                  // Menampilkan data ulasan dari Supabase.
                  if (_controller.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_controller.errorMessage != null)
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 35,
                          ),
                          const SizedBox(height: 8),
                          const Text('Gagal memuat ulasan'),
                          TextButton(
                            onPressed: _controller.loadUlasan,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                  else if (_controller.filteredUlasan.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text('Belum ada ulasan ditemukan.'),
                      ),
                    )
                  else
                    ..._controller.filteredUlasan.map((item) {
                      final user = item['user'] as Map<String, dynamic>?;
                      final destinasi =
                          item['destinasi'] as Map<String, dynamic>?;

                      final namaUser = user?['nama']?.toString() ?? 'Pengguna';

                      final fotoUser = user?['foto_profil']?.toString() ?? '';

                      final namaDestinasi =
                          destinasi?['nama_destinasi']?.toString() ??
                          'Destinasi tidak diketahui';

                      final rating = (item['rating'] as num?)?.toDouble() ?? 0;

                      final komentar = item['komentar']?.toString() ?? '';

                      final tanggal = item['tanggal_ditambah']?.toString();

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),

                        child: _buildReviewCard(
                          statusUlasan: item['status'] == true,
                          avatarUrl: fotoUser,
                          name: namaUser,
                          badgeText: 'Pengguna TernateSpot',
                          isVerified: false,
                          timeAgo: _formatTanggal(tanggal),
                          rating: rating.toStringAsFixed(1),
                          locationName: namaDestinasi,
                          locationIcon: Icons.location_on_outlined,
                          comment: komentar,
                          idUlasan: (item['id_ulasan'] as num).toInt(),
                        ),
                      );
                    }),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget tab filter status ulasan.
  Widget _buildStatusTab({
    required String label,
    required int count,
    required bool? status,
  }) {
    final selected = _controller.selectedStatus == status;

    return InkWell(
      onTap: () {
        _controller.filterByStatus(status);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1D61E7) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFF1D61E7) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF4A5568),
              ),
            ),
            const SizedBox(width: 7),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : const Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Kartu Ulasan Presisi Sesuai Gambar
  Widget _buildReviewCard({
    required String avatarUrl,
    required String name,
    required String badgeText,
    required bool isVerified,
    required String timeAgo,
    required String rating,
    required String locationName,
    required IconData locationIcon,
    required String comment,
    required int idUlasan,
    required bool statusUlasan,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Header Profil & Rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFEBF3FE),
                    backgroundImage: avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl.isEmpty
                        ? const Icon(Icons.person, color: Color(0xFF1D61E7))
                        : null,
                  ),
                  if (isVerified)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          size: 12,
                          color: Color(0xFF1D61E7),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A212A),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        Text(
                          badgeText,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D61E7),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: Color(0xFFCBD5E0),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeAgo,
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
              ),
              // Rating Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF3FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: Color(0xFF1D61E7),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D61E7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Badge Lokasi Destinasi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF3FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(locationIcon, size: 13, color: const Color(0xFF1D61E7)),
                const SizedBox(width: 4),
                Text(
                  locationName,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D61E7),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Teks Komentar Ulasan
          Text(
            comment,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF4A5568),
              height: 1.45,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 14),

          // Tombol aksi moderasi dan hapus.
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final statusBaru = !statusUlasan;

                      final berhasil = await _controller.updateStatusUlasan(
                        idUlasan: idUlasan,
                        status: statusBaru,
                      );

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            berhasil
                                ? statusBaru
                                      ? 'Ulasan berhasil ditampilkan.'
                                      : 'Ulasan berhasil disembunyikan.'
                                : 'Gagal mengubah status ulasan.',
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      statusUlasan
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 17,
                    ),
                    label: Text(
                      statusUlasan ? 'Sembunyikan' : 'Tampilkan',
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: statusUlasan
                          ? const Color(0xFF1D61E7)
                          : const Color(0xFF16A36A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () async {
                    final konfirmasi = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Ulasan?'),
                        content: const Text(
                          'Ulasan akan dihapus secara permanen.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (konfirmasi != true || !mounted) return;

                    final berhasil = await _controller.deleteUlasan(idUlasan);

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          berhasil
                              ? 'Ulasan berhasil dihapus.'
                              : 'Gagal menghapus ulasan.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 19,
                    color: Color(0xFFE53E3E),
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
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
