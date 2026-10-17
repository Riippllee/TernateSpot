import 'package:flutter/material.dart';
import 'package:ternatespot/views/user/review/review_page.dart';
import 'package:ternatespot/widgate/lib/widgets/admin_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
                  const Text(
                    'SENIN, 24 OKTOBER 2024',
                    style: TextStyle(
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
              const Text(
                'Halo, Admin Sarah! 👋',
                style: TextStyle(
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

              // Tombol Cepat Aksi Admin
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_location_alt_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        '+ Destinasi Baru',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D61E7),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),


                  Expanded(
                    flex: 3,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.rate_review_outlined,
                            size: 15,
                            color: Color(0xFF4A5568),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Moderasi',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A5568),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE8E8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '12',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE53E3E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.download_outlined,
                        size: 15,
                        color: Color(0xFF4A5568),
                      ),
                      label: const Text(
                        'Export',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5568),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFFEDF2F7),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
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
                    badgeText: '📈 +12%',
                    badgeBgColor: const Color(0xFFEBF3FE),
                    badgeTextColor: const Color(0xFF1D61E7),
                    value: '12.540',
                    label: 'Total Pengguna',
                  ),
                  _buildStatCard(
                    icon: Icons.explore_outlined,
                    iconBgColor: const Color(0xFFEBF3FE),
                    iconColor: const Color(0xFF1D61E7),
                    badgeText: '+14 baru',
                    badgeBgColor: const Color(0xFFEBF3FE),
                    badgeTextColor: const Color(0xFF1D61E7),
                    value: '350',
                    label: 'Total Destinasi',
                  ),
                  _buildStatCard(
                    icon: Icons.star_outline_rounded,
                    iconBgColor: const Color(0xFFEBF3FE),
                    iconColor: const Color(0xFF1D61E7),
                    badgeText: '★ 4.8',
                    badgeBgColor: const Color(0xFFF7FAFC),
                    badgeTextColor: const Color(0xFF4A5568),
                    value: '8.920',
                    label: 'Total Ulasan',
                  ),
                  _buildStatCard(
                    icon: Icons.collections_outlined,
                    iconBgColor: const Color(0xFFEBF3FE),
                    iconColor: const Color(0xFF1D61E7),
                    badgeText: '+85 hari ini',
                    badgeBgColor: const Color(0xFFEBF3FE),
                    badgeTextColor: const Color(0xFF1D61E7),
                    value: '5.200',
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

              // Daftar Item Destinasi Populer
              _buildDestinationListItem(
                rank: '#1',
                imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=300',
                title: 'Pantai Sulamadaha',
                location: 'Kelurahan Sulamadaha, Kota Ternate',
                views: '3.420 tontonan',
                category: 'Alam',
                rating: '4.9',
              ),
              const SizedBox(height: 10),
              _buildDestinationListItem(
                rank: '#2',
                imageUrl: 'https://images.unsplash.com/photo-1590523741831-ab7e8b8f9c7f?q=80&w=300',
                title: 'Landmark',
                location: 'Kelurahan Muhajirin, Kota Ternate',
                views: '2.890 tontonan',
                category: 'Alam',
                rating: '4.8',
              ),
              const SizedBox(height: 10),
              _buildDestinationListItem(
                rank: '#3',
                imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=300',
                title: 'Taman Nukila',
                location: 'Kelurahan Gamalama, Kota Ternate',
                views: '2.150 tontonan',
                category: 'Sejarah',
                rating: '4.8',
              ),

              const SizedBox(height: 24),
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
            color: Colors.black.withOpacity(0.02),
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

  // Widget Item Daftar Destinasi
  Widget _buildDestinationListItem({
    required String rank,
    required String imageUrl,
    required String title,
    required String location,
    required String views,
    required String category,
    required String rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
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
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
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
                    color: Colors.black.withOpacity(0.5),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A212A),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Color(0xFF1D61E7),
                        ),
                        const SizedBox(width: 2),
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
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF718096),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      size: 11,
                      color: Color(0xFF718096),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      views,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF718096),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF3FE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D61E7),
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
