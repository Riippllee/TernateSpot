import 'package:flutter/material.dart';

class DestinationItem {
  final String title;
  final String category;
  final String filterCategory;
  final String location;
  final double rating;
  final String imageUrl;
  bool isFavorite;

  DestinationItem({
    required this.title,
    required this.category,
    required this.filterCategory,
    required this.location,
    required this.rating,
    required this.imageUrl,
    this.isFavorite = true,
  });
}

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  String _selectedCategory = 'Semua';
  int _currentIndex = 2;

  final List<DestinationItem> _favoriteDestinations = [
    DestinationItem(
      title: 'Pantai Sulamadaha',
      category: 'Pantai',
      filterCategory: 'Pantai',
      location: 'Ternate Barat, Maluku Utara',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
    ),
    DestinationItem(
      title: 'Benteng Oranje',
      category: 'Sejarah',
      filterCategory: 'Sejarah',
      location: 'Ternate Tengah, Kota Ternate',
      rating: 4.7,
      imageUrl: 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?auto=format&fit=crop&w=400&q=80',
    ),
    DestinationItem(
      title: 'Danau Tolire & Gama',
      category: 'Alam',
      filterCategory: 'Alam',
      location: 'Ternate Utara, Maluku Utara',
      rating: 4.9,
      imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=400&q=80',
    ),
    DestinationItem(
      title: 'Pantai Jikomalamo',
      category: 'Pantai',
      filterCategory: 'Pantai',
      location: 'Ternate Barat, Maluku Utara',
      rating: 4.8,
      imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&w=400&q=80',
    ),
    DestinationItem(
      title: 'Taman Nukila & Falajawa',
      category: 'Pantai / Santai',
      filterCategory: 'Pantai',
      location: 'Ternate Tengah, Kota Ternate',
      rating: 4.6,
      imageUrl: 'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=400&q=80',
    ),
  ];

  List<DestinationItem> get _filteredList {
    final activeItems = _favoriteDestinations.where((item) => item.isFavorite).toList();
    if (_selectedCategory == 'Semua') {
      return activeItems;
    }
    return activeItems.where((item) => item.filterCategory == _selectedCategory).toList();
  }

  int _getCountByCategory(String category) {
    final activeItems = _favoriteDestinations.where((item) => item.isFavorite).toList();
    if (category == 'Semua') return activeItems.length;
    return activeItems.where((item) => item.filterCategory == category).length;
  }

  @override
  Widget build(BuildContext context) {
    final totalSaved = _getCountByCategory('Semua');
    final displayedList = _filteredList;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: CustomPaint(
                          painter: MiniTernateLogoPainter(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                              children: [
                                TextSpan(text: 'ternate', style: TextStyle(color: Color(0xFF1E293B))),
                                TextSpan(text: 'Spot', style: TextStyle(color: Color(0xFF2563EB))),
                              ],
                            ),
                          ),
                          const Text(
                            'WISATA KOTA TERNATE',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF64748B),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.notifications_none_rounded, size: 26, color: Color(0xFF334155)),
                          Positioned(
                            top: 2,
                            right: 3,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF2563EB),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      const CircleAvatar(
                        radius: 17,
                        backgroundColor: Color(0xFFCBD5E1),
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'Destinasi Favorit',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBEAFE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$totalSaved Tersimpan',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0).withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.sort_rounded, size: 20, color: Color(0xFF475569)),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Daftar tempat wisata impian di Kepulauan Rempah yang siap kamu kunjungi.',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF475569),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Semua', 'Pantai', 'Alam', 'Sejarah'].map((category) {
                        final isSelected = _selectedCategory == category;
                        final count = _getCountByCategory(category);

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF0A58CA)
                                    : const Color(0xFFE2E8F0).withOpacity(0.75),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                      color: isSelected ? Colors.white : const Color(0xFF334155),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.22)
                                          : const Color(0xFFCBD5E1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '$count',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? Colors.white : const Color(0xFF475569),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (displayedList.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'Belum ada destinasi favorit di kategori ini.',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                      ),
                    )
                  else
                    ...displayedList.map((item) => _buildDestinationCard(item)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, 'Beranda'),
              _buildNavItem(1, Icons.location_on_outlined, Icons.location_on_rounded, 'Lokasi'),
              _buildNavItem(2, Icons.favorite_border_rounded, Icons.favorite_rounded, 'Favorit'),
              _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinationCard(DestinationItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  item.imageUrl,
                  width: 98,
                  height: 98,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 98,
                    height: 98,
                    color: const Color(0xFFE2E8F0),
                    child: const Icon(Icons.image_not_supported, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 13, color: Color(0xFF10B981)),
                      const SizedBox(width: 2),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 98,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: _getTagBgColor(item.filterCategory),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _getTagTextColor(item.filterCategory),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            item.isFavorite = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.title} dihapus dari favorit'),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'Batal',
                                onPressed: () {
                                  setState(() {
                                    item.isFavorite = true;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEE2E2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 16,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF2563EB)),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                item.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Text(
                              'Detail',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF2563EB)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTagBgColor(String category) {
    switch (category) {
      case 'Pantai':
        return const Color(0xFFDBEAFE);
      case 'Sejarah':
        return const Color(0xFFE2E8F0);
      case 'Alam':
        return const Color(0xFFD1FAE5);
      default:
        return const Color(0xFFDBEAFE);
    }
  }

  Color _getTagTextColor(String category) {
    switch (category) {
      case 'Pantai':
        return const Color(0xFF1D4ED8);
      case 'Sejarah':
        return const Color(0xFF334155);
      case 'Alam':
        return const Color(0xFF047857);
      default:
        return const Color(0xFF1D4ED8);
    }
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFDBEAFE) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

class MiniTernateLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sunPaint = Paint()
      ..color = const Color(0xFFF97316)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.28),
      size.width * 0.12,
      sunPaint,
    );

    final mountainPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final mountainPath = Path()
      ..moveTo(size.width * 0.18, size.height * 0.62)
      ..lineTo(size.width * 0.48, size.height * 0.22)
      ..lineTo(size.width * 0.78, size.height * 0.62);
    canvas.drawPath(mountainPath, mountainPaint);

    final wavePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    final wavePath = Path()
      ..moveTo(size.width * 0.12, size.height * 0.76)
      ..quadraticBezierTo(size.width * 0.30, size.height * 0.65, size.width * 0.48, size.height * 0.78)
      ..quadraticBezierTo(size.width * 0.65, size.height * 0.90, size.width * 0.88, size.height * 0.75);
    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}