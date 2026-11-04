
import 'package:flutter/material.dart';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  String selectedCategory = 'Semua';

  final Set<String> favorites = {};

  // ==========================================
  // WARNA APLIKASI
  // ==========================================

  static const Color primaryBlue = Color(0xFF0875ED);
  static const Color backgroundColor = Color(0xFFF7F8FD);
  static const Color textColor = Color(0xFF17233C);
  static const Color secondaryText = Color(0xFF78869A);

  // ==========================================
  // DATA DESTINASI
  // ==========================================

  final List<Map<String, dynamic>> destinations = [
    {
      'name': 'Benteng Kalamata',
      'location': 'Ternate Selatan',
      'category': 'Sejarah',
      'rating': '4.7',
      'image':
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=700',
    },
    {
      'name': 'Danau Tolire',
      'location': 'Ternate Utara',
      'category': 'Alam',
      'rating': '4.8',
      'image':
          'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=700',
    },
    {
      'name': 'Pantai Sulamadaha',
      'location': 'Ternate Barat',
      'category': 'Pantai',
      'rating': '4.9',
      'image':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=700',
    },
    {
      'name': 'Gunung Gamalama',
      'location': 'Ternate Tengah',
      'category': 'Alam',
      'rating': '4.8',
      'image':
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=700',
    },
    {
      'name': 'Benteng Oranje',
      'location': 'Ternate Tengah',
      'category': 'Sejarah',
      'rating': '4.6',
      'image':
          'https://images.unsplash.com/photo-1511818966892-d7d671e672a2?w=700',
    },
    {
      'name': 'Pantai Jikomalamo',
      'location': 'Ternate Utara',
      'category': 'Pantai',
      'rating': '4.8',
      'image':
          'https://images.unsplash.com/photo-1519046904884-53103b34b206?w=700',
    },
  ];

  // ==========================================
  // FILTER PENCARIAN DAN KATEGORI
  // ==========================================

  List<Map<String, dynamic>> get filteredDestinations {
    return destinations.where((item) {
      final name = item['name'].toString().toLowerCase();
      final location = item['location'].toString().toLowerCase();

      final matchesSearch =
          name.contains(searchQuery.toLowerCase()) ||
          location.contains(searchQuery.toLowerCase());

      final matchesCategory =
          selectedCategory == 'Semua' ||
          item['category'] == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ==========================================
  // FAVORIT
  // ==========================================

  void toggleFavorite(String name) {
    setState(() {
      if (favorites.contains(name)) {
        favorites.remove(name);
      } else {
        favorites.add(name);
      }
    });
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
              child: SingleChildScrollView(
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
            child: Icon(
              Icons.person,
              size: 18,
              color: primaryBlue,
            ),
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
  // SEARCH
  // ==========================================

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: TextField(
          controller: searchController,

          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },

          style: const TextStyle(
            fontSize: 12,
            color: textColor,
          ),

          decoration: InputDecoration(
            hintText: 'Cari destinasi di Ternate...',

            hintStyle: const TextStyle(
              fontSize: 12,
              color: secondaryText,
            ),

            prefixIcon: const Icon(
              Icons.search,
              size: 19,
              color: secondaryText,
            ),

            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      searchController.clear();

                      setState(() {
                        searchQuery = '';
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 17,
                    ),
                  )
                : null,

            border: InputBorder.none,

            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // BANNER
  // ==========================================

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),

        child: AspectRatio(
          aspectRatio: 2.1,

          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=1000',

                fit: BoxFit.cover,

                errorBuilder: (_, __, ___) {
                  return Container(
                    color: const Color(0xFF718C9B),
                    child: const Icon(
                      Icons.landscape,
                      color: Colors.white,
                      size: 45,
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
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 12,
                bottom: 12,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Keindahan Alam Ternate\nMenanti Kamu!',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 7),

                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedCategory = 'Alam';
                        });
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,

                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 7,
                        ),

                        minimumSize: Size.zero,

                        tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),

                      child: const Text(
                        'Jelajahi Sekarang  ›',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 10,
                right: 13,

                child: Row(
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.only(left: 4),

                      height: 5,
                      width: index == 0 ? 13 : 5,

                      decoration: BoxDecoration(
                        color: index == 0
                            ? primaryBlue
                            : Colors.white70,

                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // KATEGORI WISATA
  // ==========================================

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
              children: [
                _categoryButton(
                  'Semua',
                  Icons.grid_view_rounded,
                ),

                _categoryButton(
                  'Pantai',
                  Icons.beach_access_outlined,
                ),

                _categoryButton(
                  'Alam',
                  Icons.landscape_outlined,
                ),

                _categoryButton(
                  'Sejarah',
                  Icons.museum_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TOMBOL KATEGORI
  // ==========================================

  Widget _categoryButton(
    String category,
    IconData icon,
  ) {
    final selected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },

      child: Container(
        margin: const EdgeInsets.only(right: 7),

        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 9,
        ),

        decoration: BoxDecoration(
          color: selected ? primaryBlue : Colors.white,

          borderRadius: BorderRadius.circular(22),

          border: Border.all(
            color: selected
                ? primaryBlue
                : const Color(0xFFE5E9F1),
          ),

          boxShadow: selected
              ? [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.13),
                    blurRadius: 7,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(
              icon,

              size: 13,

              color: selected
                  ? Colors.white
                  : const Color(0xFF64748B),
            ),

            const SizedBox(width: 5),

            Text(
              category,

              style: TextStyle(
                fontSize: 12,

                color: selected
                    ? Colors.white
                    : textColor,

                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // REKOMENDASI PILIHAN
  // ==========================================

  Widget _buildRecommendations() {
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = 'Semua';
                    searchQuery = '';
                    searchController.clear();
                  });
                },

                child: const Text(
                  'Lihat Semua ›',

                  style: TextStyle(
                    fontSize: 11,
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(18, 4, 18, 13),

          child: Text(
            'Jejak sejarah, danau misteri, dan mahkota\nGamalama',

            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF78869A),
              height: 1.4,
            ),
          ),
        ),

        if (results.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(30),

              child: Column(
                children: [
                  Icon(
                    Icons.search_off,
                    size: 40,
                    color: secondaryText,
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Destinasi tidak ditemukan',

                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          )

        else
          SizedBox(
            height: 267,

            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),

              scrollDirection: Axis.horizontal,

              itemCount: results.length,

              itemBuilder: (context, index) {
                return _destinationCard(
                  results[index],
                );
              },
            ),
          ),
      ],
    );
  }

  // ==========================================
  // KARTU DESTINASI
  // ==========================================

  Widget _destinationCard(
    Map<String, dynamic> item,
  ) {
    final name = item['name'] as String;
    final category = item['category'] as String;

    final isFavorite = favorites.contains(name);

    // WARNA LABEL KATEGORI

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

    return Container(
      width: 201,

      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(13),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // FOTO DESTINASI

          Expanded(
            child: Stack(
              fit: StackFit.expand,

              children: [
                Image.network(
                  item['image'],

                  fit: BoxFit.cover,

                  errorBuilder: (_, __, ___) {
                    return Container(
                      color: const Color(0xFFE0E7EE),

                      child: const Icon(
                        Icons.image_not_supported,
                        color: secondaryText,
                      ),
                    );
                  },
                ),

                // RATING

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
                          item['rating'],

                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // FAVORIT

                Positioned(
                  top: 7,
                  right: 7,

                  child: GestureDetector(
                    onTap: () => toggleFavorite(name),

                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,

                      child: Icon(
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
              ],
            ),
          ),

          // INFORMASI DESTINASI

          Padding(
            padding: const EdgeInsets.fromLTRB(
              10,
              8,
              10,
              10,
            ),

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
                        item['location'],

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

                // LABEL KATEGORI

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
                    category == 'Alam'
                        ? 'Wisata Alam'
                        : category,

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
    );
  }

  // ==========================================
  // BOTTOM NAVIGATION
  // ==========================================

  Widget _buildBottomNavigation() {
    final items = [
      {
        'icon': Icons.home_outlined,
        'label': 'Beranda',
      },
      {
        'icon': Icons.location_on_outlined,
        'label': 'Lokasi',
      },
      {
        'icon': Icons.favorite_border,
        'label': 'Favorit',
      },
      {
        'icon': Icons.person_outline,
        'label': 'Profil',
      },
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,

        border: Border(
          top: BorderSide(
            color: Color(0xFFEEEEEE),
          ),
        ),
      ),

      child: SafeArea(
        top: false,

        child: SizedBox(
          height: 57,

          child: Row(
            children: List.generate(
              items.length,
              (index) {
                final active = index == 0;

                return Expanded(
                  child: InkWell(
                    onTap: () {
                      if (index != 0) {
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
                          items[index]['icon'] as IconData,

                          size: 22,

                          color: active
                              ? primaryBlue
                              : secondaryText,
                        ),

                        const SizedBox(height: 4),

                        Text(
                          items[index]['label'] as String,

                          style: TextStyle(
                            fontSize: 10,

                            color: active
                                ? primaryBlue
                                : secondaryText,

                            fontWeight: active
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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

    // Bentuk gunung dan ombak logo

    path.moveTo(2, 28);
    path.lineTo(20, 7);
    path.quadraticBezierTo(22, 4, 25, 8);
    path.lineTo(39, 25);

    path.moveTo(2, 32);
    path.quadraticBezierTo(13, 24, 22, 29);
    path.quadraticBezierTo(30, 35, 41, 29);

    canvas.drawPath(path, bluePaint);

    // Matahari berwarna oranye

    canvas.drawCircle(
      const Offset(34, 7),
      4.5,
      orangePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant TernateLogoPainter oldDelegate,
  ) {
    return false;
  }
}
