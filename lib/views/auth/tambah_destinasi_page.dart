import 'package:flutter/material.dart';
import 'dart:ui';
class TambahDestinasiPage extends StatefulWidget {
  const TambahDestinasiPage({super.key});

  @override
  State<TambahDestinasiPage> createState() => _TambahDestinasiPageState();
}

class _TambahDestinasiPageState extends State<TambahDestinasiPage> {
  // Simulasi status apakah gambar sudah dipilih atau belum
  bool _hasSelectedImage = true;
  final String _previewImageUrl =
      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/newsOg_2024_6_9_1717902356726-iifq7h.jpeg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0066FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Destinasi',
          style: TextStyle(
            color: Color(0xFF0B2545),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. SECTION UPLOAD FOTO DESTINASI
                      const Text(
                        'Upload Foto Destinasi',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2545),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pilih gambar destinasi yang ingin ditambahkan.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A99AD),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Box Upload dengan Dashed Border
                      GestureDetector(
                        onTap: () {
                          // Aksi pilih gambar dari galeri
                          setState(() {
                            _hasSelectedImage = true;
                          });
                        },
                        child: CustomPaint(
                          painter: DashedRectPainter(
                            color: const Color(0xFFC3D8F6),
                            strokeWidth: 1.2,
                            gap: 5.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 28),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F7FE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.image_rounded,
                                  size: 48,
                                  color: Color(0xFF0066FF),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Pilih Gambar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0B2545),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Klik untuk mengunggah foto destinasi',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF8A99AD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 2. SECTION PRATINJAU FOTO
                      const Text(
                        'Pratinjau Foto',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0B2545),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Card Wrapper Pratinjau Foto
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFEDF2F7)),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _hasSelectedImage
                              ? Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    // Gambar Pratinjau
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        _previewImageUrl,
                                        width: 170,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          width: 170,
                                          height: 100,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.image,
                                              color: Colors.grey),
                                        ),
                                      ),
                                    ),

                                    // Tombol Silang Merah (Hapus Gambar)
                                    Positioned(
                                      top: 6,
                                      right: 6,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _hasSelectedImage = false;
                                          });
                                        },
                                        child: Container(
                                          width: 22,
                                          height: 22,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.cancel,
                                            color: Color(0xFFE53935),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  width: 170,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey.shade200),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Belum ada foto',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. TOMBOL SIMPAN (BOTTOM FIXED)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Aksi simpan destinasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Foto destinasi berhasil disimpan!'),
                        backgroundColor: Color(0xFF0066FF),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.save_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066FF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter untuk Membuat Garis Putus-putus (Dashed Border)
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final DashedPath painter = DashedPath();
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = painter.buildDashedPath(path, gap);

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DashedPath {
  Path buildDashedPath(Path source, double dashWidth) {
    final Path path = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double length = dashWidth;
        if (draw) {
          path.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return path;
  }
}