import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6FB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Destinasi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // =================================================================
            // 1. HEADER GAMBAR UTAMA (FOTO PANTAI JERNIN)
            // =================================================================
            SizedBox(
              height: 250,
              child: Stack(
                children: [
                  // Foto Pantai Sulamadaha Jernih via Network URL
                  Positioned.fill(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1000&auto=format&fit=crop',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Tombol Share & Favorite
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.share_outlined, color: Colors.black87, size: 18),
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.favorite, color: Colors.red, size: 20),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Indikator Titik Slider
                  Positioned(
                    bottom: 28,
                    left: 20,
                    child: Row(
                      children: List.generate(
                        5,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 4),
                          width: index == 0 ? 10 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: index == 0 ? Colors.white : Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Badge Foto "1/5 Foto"
                  Positioned(
                    bottom: 24,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.collections_outlined, color: Color(0xFF2563EB), size: 13),
                          SizedBox(width: 4),
                          Text(
                            '1/5 Foto',
                            style: TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =================================================================
            // 2. KONTEN DETAIL INFORMASI DESTINASI
            // =================================================================
            Transform.translate(
              offset: const Offset(0, -16),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0EDFF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.waves, color: Color(0xFF2563EB), size: 13),
                              SizedBox(width: 6),
                              Text(
                                'Wisata Pantai & Bahari',
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEAD5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star, color: Color(0xFFF97316), size: 14),
                              SizedBox(width: 4),
                              Text(
                                '4.7',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF9A3412),
                                ),
                              ),
                              Text(
                                ' (620)',
                                style: TextStyle(fontSize: 11, color: Color(0xFFC2410C)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    const Text(
                      'Pantai Sulamadaha',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),

                    const Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Color(0xFF2563EB), size: 16),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Desa Sulamadaha, Ternate Barat, Kota Ternate,...',
                            style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Tentang Destinasi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pantai Sulamadaha dikenal luas sebagai surga bahari terindah di Ternate dengan air laut sebening kaca kristal, kerap dijuluki Teluk Saomadoro atau Danau...',
                      style: TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Text(
                          'Baca Selengkapnya',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Color(0xFF2563EB), size: 16),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // =========================================================
                    // 3. PETA LOKASI KUSTOM FLUTTER
                    // =========================================================
                    const Text(
                      'Peta Lokasi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                        height: 190,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                color: const Color(0xFF93E5F5),
                              ),
                            ),
                            Positioned(
                              top: -15,
                              left: 110,
                              child: Container(
                                width: 85,
                                height: 75,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC8F5C4),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -45,
                              left: 30,
                              right: 30,
                              child: Container(
                                height: 145,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFC8F5C4),
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(90)),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 22,
                              left: 115,
                              child: Row(
                                children: [
                                  const Text(
                                    'Hiri Island',
                                    style: TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(color: Colors.teal, shape: BoxShape.circle),
                                    child: const Icon(Icons.navigation, color: Colors.white, size: 10),
                                  ),
                                ],
                              ),
                            ),
                            const Positioned(
                              top: 42,
                              left: 95,
                              child: Text(
                                'Mount Hiri',
                                style: TextStyle(fontSize: 9, color: Colors.black45),
                              ),
                            ),
                            Positioned(
                              top: 85,
                              left: 120,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(color: Color(0xFFA855F7), shape: BoxShape.circle),
                                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 10),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Pantai Jikomalamo - Kota...\nTernate, Maluku Utara',
                                    style: TextStyle(fontSize: 8, color: Color(0xFFA855F7), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 120,
                              left: 185,
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(color: Color(0xFFA855F7), shape: BoxShape.circle),
                                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 10),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Batu Angus',
                                    style: TextStyle(fontSize: 8, color: Color(0xFFA855F7), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC).withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFFE4E6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Color(0xFFE11D48),
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Text(
                                        'Pantai Sulamadaha',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: const Row(
                                        children: [
                                          Text(
                                            'Lihat',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF2563EB),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Icon(
                                            Icons.chevron_right,
                                            size: 16,
                                            color: Color(0xFF2563EB),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}