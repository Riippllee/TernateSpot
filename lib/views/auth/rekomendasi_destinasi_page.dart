import 'package:flutter/material.dart';

class RekomendasiDestinasiPage extends StatefulWidget {
  const RekomendasiDestinasiPage({super.key});

  @override
  State<RekomendasiDestinasiPage> createState() => _RekomendasiDestinasiPageState();
}

class _RekomendasiDestinasiPageState extends State<RekomendasiDestinasiPage> {
  int _selectedFilterIndex = 0;

  final List<String> _filters = [
    'Semua',
    'Populer',
    'Bahari',
    'Budaya',
    'Gunung',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Rekomendasi Destinasi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD 1: PUBLIC & SLOT PROGRESS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDF2F7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0052CC),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'PUBLIC',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0052CC),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.cloud_done_outlined,
                                size: 13, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(
                              'Sinkron Otomatis',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: const [
                              Text(
                                '6',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                ' / 6',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Slot carousel beranda terisi\noptimal',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.file_download_outlined,
                            size: 16, color: Colors.white),
                        label: const Text(
                          'Publikasikan',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: Color(0xFFE2E8F0),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF0066FF)),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // GRID REKOMENDASI 6 ITEM
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.86,
              children: [
                _buildRecommendationCard(
                  tag: '#1 Utama',
                  tagBgColor: Colors.white,
                  tagTextColor: const Color(0xFF0066FF),
                  title: 'Pantai Sulamadaha',
                  category: 'Pantai • Kota Ternate',
                  imageUrl:
                      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/Pantai.jpeg',
                ),
                _buildRecommendationCard(
                  tag: '#2 Sejarah',
                  tagBgColor: Colors.white,
                  tagTextColor: const Color(0xFF0066FF),
                  title: 'Benteng Tolluko',
                  category: 'Sejarah • Kota Ternate',
                  imageUrl:
                      'https://indotimur.com/images/nits/2023/08/preview_brtcc0hw_gzrlhpmv.jpg',
                ),
                _buildRecommendationCard(
                  tag: '#3 Pantai',
                  tagBgColor: Colors.white,
                  tagTextColor: const Color(0xFF0066FF),
                  title: 'Pantai Jikomalamo',
                  category: 'Pantai • Kota Ternate',
                  imageUrl:
                      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/Pantai.jpeg',
                ),
                _buildRecommendationCard(
                  tag: '#4 Alam',
                  tagBgColor: Colors.white,
                  tagTextColor: const Color(0xFF0066FF),
                  title: 'Danau Tolire Besar',
                  category: 'Alam • Kota Ternate',
                  imageUrl:
                      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/newsOg_2024_6_9_1717902356726-iifq7h.jpeg',
                ),
                _buildRecommendationCard(
                  tag: '#5 Siap Ditukar',
                  tagBgColor: const Color(0xFFD35400),
                  tagTextColor: Colors.white,
                  title: 'Danau Tolire Kecil',
                  category: 'Alam • Kota Ternate',
                  imageUrl:
                      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/newsOg_2024_6_9_1717902356726-iifq7h.jpeg',
                  isSwapIconHighlight: true,
                ),
                _buildRecommendationCard(
                  tag: '#6 Baru Ditautkan',
                  tagBgColor: Colors.white,
                  tagTextColor: const Color(0xFF0066FF),
                  title: 'Kedaton Kesultanan',
                  category: 'Sejarah • Kota Ternate',
                  imageUrl:
                      'https://indotimur.com/images/nits/2023/08/preview_brtcc0hw_gzrlhpmv.jpg',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // BANNER TOAST BIRU (URUNGKAN)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0066FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF0066FF),
                      size: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Danau Toba berhasil dipasang ke Slo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'URUNGKAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // KATALOG DESTINASI TERSEDIA SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.insert_drive_file_outlined,
                        color: Color(0xFF27AE60),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Katalog Destinasi Tersedia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '42 Destinasi Total',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // SEARCH BAR
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama pulau, gunung, atau kota...',
                hintStyle:
                    TextStyle(color: Colors.grey.shade400, fontSize: 12),
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey.shade400, size: 18),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // CHIP FILTER HORIZONTAL
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0066FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0066FF)
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET PEMBANTU UNTUK KARTU REKOMENDASI
  Widget _buildRecommendationCard({
    required String tag,
    required Color tagBgColor,
    required Color tagTextColor,
    required String title,
    required String category,
    required String imageUrl,
    bool isSwapIconHighlight = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDF2F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar dengan Overlay Tag dan Title
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 100,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
              ),

              // Tag Atas (Misal: #1 Utama)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: tagTextColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Judul Tempat di Bawah Gambar
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black87,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Area Info Kategori & Tombol Aksi Bottom
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Tombol Tukar (Swap)
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: isSwapIconHighlight
                        ? const Color(0xFFEBF2FF)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    isSwapIconHighlight ? Icons.sync : Icons.swap_horiz_rounded,
                    size: 14,
                    color: isSwapIconHighlight
                        ? const Color(0xFF0066FF)
                        : Colors.black87,
                  ),
                ),

                const SizedBox(width: 4),

                // Tombol Hapus (Silang)
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}