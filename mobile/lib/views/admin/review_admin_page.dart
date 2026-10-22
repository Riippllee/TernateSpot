import 'package:flutter/material.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _selectedIndex = 3; // Mengaktifkan tab "Review" pada bottom navigation bar
  int _selectedFilterIndex = 0;

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Perlu Moderasi', 'count': '12'},
    {'label': 'Disetujui', 'count': '8.850'},
    {'label': 'Dilaporkan / Spam', 'count': ''},
  ];

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
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/100?img=5',
              ),
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
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
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
                              contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                              color: Colors.black.withOpacity(0.02),
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
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final isSelected = _selectedFilterIndex == index;
                        final filter = _filters[index];

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedFilterIndex = index;
                            });
                          },
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (index == 2
                                      ? const Color(0xFFFFF5F5)
                                      : const Color(0xFF1D61E7))
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSelected
                                    ? (index == 2
                                        ? const Color(0xFFFEB2B2)
                                        : const Color(0xFF1D61E7))
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                if (index == 2) ...[
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE53E3E),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  filter['label'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? (index == 2
                                            ? const Color(0xFFC53030)
                                            : Colors.white)
                                        : const Color(0xFF4A5568),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                if (filter['count'].toString().isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 1,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.25)
                                          : const Color(0xFFEDF2F7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      filter['count'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : const Color(0xFF718096),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Kartu Ulasan 1: Dimas Aditya
                  _buildReviewCard(
                    avatarUrl: 'https://i.pravatar.cc/100?img=12',
                    name: 'Dimas Aditya',
                    badgeText: 'Wisatawan Terverifikasi',
                    isVerified: true,
                    timeAgo: '10 Menit lalu',
                    rating: '5.0',
                    locationName: 'Jikamalamo, Ternate',
                    locationIcon: Icons.location_on_outlined,
                    comment:
                        '"Air laut di Jikomalamo benar-benar jernih sebening kaca dan dikelilingi pasir putih yang lembut. Suasananya tenang dan cocok untuk melepas penat, paling enak datang agak pagi supaya bisa menikmati pemandangan bawah laut dengan lebih puas!"',
                  ),

                  const SizedBox(height: 14),

                  // Kartu Ulasan 2: Clara Sinta
                  _buildReviewCard(
                    avatarUrl: 'https://i.pravatar.cc/100?img=47',
                    name: 'Clara Sinta',
                    badgeText: 'Member Wisata',
                    isVerified: false,
                    timeAgo: '1 Jam lalu',
                    rating: '4.0',
                    locationName: 'Gunung Gamalama, Ternate',
                    locationIcon: Icons.terrain_outlined,
                    comment:
                        '“Gunung Gamalama menawarkan pengalaman wisata alam yang menarik dengan panorama khas Pulau Ternate dan jalur pendakian yang menantang. Selain keindahan alamnya, Gamalama juga memiliki nilai sejarah dan budaya yang membuatnya menjadi salah satu destinasi yang ikonik di Ternate.”',
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
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
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
                    backgroundImage: NetworkImage(avatarUrl),
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
                Icon(
                  locationIcon,
                  size: 13,
                  color: const Color(0xFF1D61E7),
                ),
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

          // Tombol Aksi (Laporkan, Setujui Ulasan, Hapus)
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF3FE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.flag_outlined,
                      size: 15,
                      color: Color(0xFF4A5568),
                    ),
                    label: const Text(
                      'Laporkan',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A5568),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D61E7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 15,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Setujui Ulasan',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
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