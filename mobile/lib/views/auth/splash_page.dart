import 'package:flutter/material.dart';
import 'package:ternatespot/views/auth/login_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Gambar Latar Belakang Penuh
          Image.asset(
            'Asset/Image/Background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // 2. Custom Painter
          const Positioned.fill(
            child: CustomPaint(
              painter: RealisticIslandPainter(),
            ),
          ),

          // 3. Overlay Gradient Tipis
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.transparent,
                    Colors.black.withOpacity(0.35),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // 4. Konten Utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo Card Putih
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomPaint(
                        size: const Size(40, 40),
                        painter: LogoPainter(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Judul TernateSpot
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(
                          text: 'Ternate',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Spot',
                          style: TextStyle(color: Color(0xFFB3CDE0)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Badge Subtitle
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'WISATA KOTA TERNATE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tagline Deskripsi
                  const Text(
                    'Jelajahi Ternate,\nTemukan Spotmu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Tombol "Mulai Jelajah"
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));// Aksi navigasi ke halaman berikutnya
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text(
                                'Mulai Jelajah',
                                style: TextStyle(
                                  color: Color(0xFF0052CC),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0066FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Footer Teks Versi (Sudah Diperbaiki)
                  Text(
                    'v1.0.0. " Penjata Meluku Utara',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter untuk Logo
class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintStroke = Paint()
      ..color = const Color(0xFF3B82F6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pathGunung = Path()
      ..moveTo(size.width * 0.15, size.height * 0.7)
      ..lineTo(size.width * 0.5, size.height * 0.25)
      ..lineTo(size.width * 0.85, size.height * 0.7);
    canvas.drawPath(pathGunung, paintStroke);

    final pathLaut = Path()
      ..moveTo(size.width * 0.1, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.65,
        size.width * 0.6,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.9,
        size.width * 0.9,
        size.height * 0.8,
      );
    canvas.drawPath(pathLaut, paintStroke);

    final paintMatahari = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.32),
      4.5,
      paintMatahari,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RealisticIslandPainter extends CustomPainter {
  const RealisticIslandPainter();

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}