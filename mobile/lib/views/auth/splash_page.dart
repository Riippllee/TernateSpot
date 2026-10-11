import 'package:flutter/material.dart';
import '../review/review_page.dart';

/// Class [SplashPage] berfungsi sebagai halaman pembuka (Splash Screen) aplikasi.
/// Menampilkan latar belakang gambar, logo kustom, teks promosi, dan tombol navigasi.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold adalah struktur dasar layout visual dalam Material Design.
      body: Stack(
        // Stack digunakan untuk menumpuk elemen secara z-axis (berlapis dari belakang ke depan).
        children: [
          // =========================================================================
          // LAPISAN 1: GAMBAR LATAR BELAKANG FULLSCREEN
          // =========================================================================
          Positioned.fill(
            // Positioned.fill memastikan widget mengisi seluruh area layar yang tersedia.
            child: Image.asset(
              'Asset/Image/Background.jpg',
              fit: BoxFit.cover, // Memastikan gambar memenuhi seluruh layar tanpa merusak rasio gambar.
            ),
          ),

          // =========================================================================
          // LAPISAN 2: OVERLAY TRANSPARAN (DARK FILTER)
          // =========================================================================
          Positioned.fill(
            child: Container(
              // Memberikan warna hitam transparan (opacity 15%) di atas gambar
              // agar teks di atasnya tetap terbaca jelas (meningkatkan kontras).
              color: Colors.black.withOpacity(0.15),
            ),
          ),

          // =========================================================================
          // LAPISAN 3: KONTEN UTAMA (UI Teks, Logo, dan Tombol)
          // =========================================================================
          SafeArea(
            // SafeArea menghindari konten tertutup oleh notch, status bar, atau navigasi sistem HP.
            child: Padding(
              // Menambahkan margin/jarak di sekeliling konten internal.
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                // Column menyusun widget secara vertikal dari atas ke bawah.
                // mainAxisAlignment: spaceBetween membagi ruang agar elemen atas, tengah, dan bawah terpisah seimbang.
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Penyeimbang tata letak paling atas
                  const SizedBox(height: 20),

                  // -----------------------------------------------------------------
                  // BAGIAN TENGAH: LOGO, JUDUL, BADGE, & SLOGAN
                  // -----------------------------------------------------------------
                  Column(
                    mainAxisSize: MainAxisSize.min, // Ukuran kolom mengikuti tinggi konten di dalamnya
                    children: [
                      // 1. WIDGET LOGO UTAMA
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24), // Sudut melengkung (rounded corner)
                          boxShadow: [
                            // Efek bayangan halus di belakang kotak logo
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        // CustomPaint menggambar grafik vektor kustom (Gunung, Matahari, Ombak)
                        child: CustomPaint(
                          painter: TernateLogoPainter(),
                        ),
                      ),
                      const SizedBox(height: 20), // Spasi antar elemen

                      // 2. JUDUL APLIKASI ("TernateSpot")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Menyusun teks tepat di tengah
                        children: const [
                          Text(
                            'Ternate',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Spot',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF60A5FA), // Warna biru muda sebagai penanda aksen
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 3. BADGE TEKS ("WISATA KOTA TERNATE")
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25), // Latar transparan seperti kaca (frosted glass)
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'WISATA KOTA TERNATE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1, // Jarak antar huruf diperlebar
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 4. TEKS SUB-DESKRIPSI / SLOGAN
                      const Text(
                        'Jelajahi Ternate,\nTemukan Spotmu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 1.3, // Jarak vertikal antar baris kalimat
                        ),
                      ),
                    ],
                  ),

                  // -----------------------------------------------------------------
                  // BAGIAN BAWAH: TOMBOL AKSI & INFO VERSI
                  // -----------------------------------------------------------------
                  Column(
                    children: [
                      // 1. TOMBOL "MULAI JELAJAH"
                      SizedBox(
                        width: double.infinity, // Membuat tombol memenuhi lebar layar
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.pushReplacement berpindah ke ReviewPage sekaligus 
                            // menghapus SplashPage dari tumpukan navigasi (sehingga tidak bisa di-back).
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ReviewPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28), // Bentuk kapsul (pill shape)
                            ),
                            padding: const EdgeInsets.only(left: 24, right: 8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Label Tombol
                              const Text(
                                'Mulai Jelajah',
                                style: TextStyle(
                                  color: Color(0xFF1E3A8A), // Biru gelap
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Ikon Panah Kanan dalam Lingkaran Biru
                              Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2563EB), // Biru terang
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 2. TEKS KETERANGAN VERSI APLIKASI
                      Text(
                        'v1.0.0. " Permata Maluku Utara',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
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
}

// =============================================================================
// CLASS CUSTOM PAINTER UNTUK LOGO VEKTOR
// =============================================================================
/// Class [TernateLogoPainter] digunakan untuk menggambar kustom grafik logo 
/// berupa gabungan: Matahari Oranye, Segitiga Gunung Biru, dan Gelombang Laut Biru.
class TernateLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // -------------------------------------------------------------------------
    // ELEMEN 1: MATAHARI JINGGA / ORANYE
    // -------------------------------------------------------------------------
    final sunPaint = Paint()
      ..color = const Color(0xFFF97316) // Warna oranye terang
      ..style = PaintingStyle.fill;      // Tipe cat: Blok padat (fill)

    // Menggambar lingkaran matahari di koordinat (72% lebar, 28% tinggi) dari canvas
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.28),
      size.width * 0.11, // Radius lingkaran
      sunPaint,
    );

    // -------------------------------------------------------------------------
    // ELEMEN 2: GARIS SEGITIGA GUNUNG (Simbol Gunung Gamalama)
    // -------------------------------------------------------------------------
    final mountainPaint = Paint()
      ..color = const Color(0xFF2563EB) // Warna biru utama
      ..style = PaintingStyle.stroke    // Tipe cat: Garis tepi (stroke)
      ..strokeWidth = 4.5               // Ketebalan garis
      ..strokeCap = StrokeCap.round     // Ujung garis dibuat membulat
      ..strokeJoin = StrokeJoin.round;  // Sudut pertemuan garis dibuat membulat

    final mountainPath = Path();
    mountainPath.moveTo(size.width * 0.20, size.height * 0.58); // Titik awal (Kiri Bawah Gunung)
    mountainPath.lineTo(size.width * 0.48, size.height * 0.22); // Garis ke Puncak Gunung
    mountainPath.lineTo(size.width * 0.78, size.height * 0.58); // Garis ke Kanan Bawah Gunung

    canvas.drawPath(mountainPath, mountainPaint);

    // -------------------------------------------------------------------------
    // ELEMEN 3: GARIS GELOMBANG LAUT (Simbol Perairan Ternate)
    // -------------------------------------------------------------------------
    final wavePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;

    final wavePath = Path();
    wavePath.moveTo(size.width * 0.15, size.height * 0.72); // Titik awal garis laut

    // Menggambar kurva lengkung S pertama (lengkung bawah)
    wavePath.quadraticBezierTo(
      size.width * 0.32, size.height * 0.62, // Control Point 1 (titik tarik lengkungan)
      size.width * 0.48, size.height * 0.74, // End Point 1
    );

    // Menggambar kurva lengkung S kedua (lengkung atas)
    wavePath.quadraticBezierTo(
      size.width * 0.64, size.height * 0.86, // Control Point 2
      size.width * 0.85, size.height * 0.72, // End Point 2
    );

    canvas.drawPath(wavePath, wavePaint);
  }

  // Mengontrol apakah grafik perlu digambar ulang.
  // Diisi `false` karena logo ini bersifat statis.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}