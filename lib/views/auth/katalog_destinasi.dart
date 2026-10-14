import 'package:flutter/material.dart';
import 'rekomendasi_destinasi_page.dart';
import 'edit_destinasi_page.dart';
import 'tambah_destinasi_page.dart';

// Model Data Destinasi
class DestinationModel {
  final String title;
  final String category;
  final String location;
  final String description;
  final String rating;
  final String reviews;
  final String photoCount;
  final String imageUrl;
  final bool isRecommended;

  DestinationModel({
    required this.title,
    required this.category,
    required this.location,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.photoCount,
    required this.imageUrl,
    required this.isRecommended,
  });
}

class KatalogDestinasiPage extends StatefulWidget {
  const KatalogDestinasiPage({super.key});

  @override
  State<KatalogDestinasiPage> createState() => _KatalogDestinasiPageState();
}

class _KatalogDestinasiPageState extends State<KatalogDestinasiPage> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Semua',
    'Pantai',
    'Danau & Air',
    'Sejarah & Benteng',
  ];

  final List<DestinationModel> _destinations = [
    DestinationModel(
      title: 'Pantai Sulamadaha',
      category: 'PANTAI',
      location: 'Sulamadaha, Ternate Barat',
      description:
          'Pantai dengan air kaca jernih dan spot kano transparan ikonik di Teluk Saomadaha dengan tebing batuan vulkanik.',
      rating: '4.9',
      reviews: '186 ulasan',
      photoCount: '12 Foto',
      imageUrl: 'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/Pantai.jpeg',
      isRecommended: true,
    ),
    DestinationModel(
      title: 'Pantai Kastela',
      category: 'PANTAI',
      location: 'Kastela, Pulau Ternate',
      description:
          'Spot matahari terbenam magis dengan monumen sejarah pendaratan Portugis pertama serta gerbang reruntuhan...',
      rating: '4.7',
      reviews: '124 ulasan',
      photoCount: '9 Foto',
      imageUrl: 'https://indotimur.com/images/nits/2023/08/preview_brtcc0hw_gzrlhpmv.jpg',
      isRecommended: false,
    ),
    DestinationModel(
      title: 'Danau Tolire',
      category: 'DANAU & AIR',
      location: 'Takome, Ternate Barat',
      description:
          'Danau hijau di kaki Gunung Gamalama dengan legenda mistis dan panorama alam khas Ternate.',
      rating: '4.8',
      reviews: '95 ulasan',
      photoCount: '15 Foto',
      imageUrl: 'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/newsOg_2024_6_9_1717902356726-iifq7h.jpeg',
      isRecommended: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0066FF),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Katalog Destinasi',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'Kelola & perbarui spot wisata Kota Ternate',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 10, bottom: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigasi ke Halaman Tambah Destinasi
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TambahDestinasiPage(),
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text(
                'Tambah',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Banner Atur Rekomendasi Beranda
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RekomendasiDestinasiPage(),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0066FF), Color(0xFF2F80ED)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0066FF).withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.star,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Atur Rekomendasi Beranda',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '5 AKTIF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          const Text(
                            'Destinasi terpilih di landing page traveler',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_right,
                          color: Color(0xFF0066FF), size: 18),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari nama destinasi, kecamatan...',
                hintStyle:
                    TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Kategori Chips
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0066FF)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0066FF)
                              : Colors.grey.shade200,
                        ),
                      ),
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade700,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Daftar Card Destinasi
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _destinations.length,
              itemBuilder: (context, index) {
                final destination = _destinations[index];
                return _buildDestinationCard(destination);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard(DestinationModel destination) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
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
          // Gambar dan Info Utama Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Destinasi
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      destination.imageUrl,
                      width: 95,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 95,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.camera_alt,
                              color: Colors.white, size: 10),
                          const SizedBox(width: 4),
                          Text(
                            destination.photoCount,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Detail Info Nama, Lokasi, dan Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEBF2FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        destination.category,
                        style: const TextStyle(
                          color: Color(0xFF0066FF),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      destination.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 12, color: Colors.grey),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            destination.location,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (destination.isRecommended)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF2FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.star,
                                size: 11, color: Color(0xFF0066FF)),
                            SizedBox(width: 4),
                            Text(
                              'Rekomendasi Beranda',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF0066FF),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '+ Jadikan Rekomendasi',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Rating & Ulasan Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                const SizedBox(width: 6),
                const Text(
                  'Rating: ',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  destination.rating,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 12,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                ),
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Color(0xFF0066FF),
                  size: 14,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Ulasan: ',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  destination.reviews,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Deskripsi Destinasi
          Text(
            destination.description,
            style: TextStyle(
                fontSize: 11, color: Colors.grey.shade700, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // Tombol Aksi Bottom (Detail, Edit Destinasi, Hapus)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.visibility_outlined,
                      size: 14, color: Colors.black87),
                  label: const Text(
                    'Detail',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: Colors.grey.shade200),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigasi ke EditDestinasiPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditDestinasiPage(
                          destinationTitle: destination.title,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_note_rounded,
                      size: 16, color: Colors.white),
                  label: const Text(
                    'Edit Destinasi',
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Tombol Hapus (Pink Smooth Rounded)
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: const Center(
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFE53935),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}