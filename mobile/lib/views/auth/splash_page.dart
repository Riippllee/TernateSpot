import 'package:flutter/material.dart';
import 'package:ternatespot/views/home/home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  void _goToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background Pemandangan Gunung Gamalama & Pantai Ternate
          Positioned.fill(
            child: CustomPaint(
              painter: _RealisticIslandPainter(),
            ),
          ),

          // Overlay Gradient Tipis
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.08),
                    Colors.transparent,
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.35),
                  ],
                  stops: const [0.0, 0.35, 0.70, 1.0],
                ),
              ),
            ),
          ),

          // Konten Utama
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo Box
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(60, 60),
                      painter: _LogoPainter(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Judul "TernateSpot"
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 36,
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

                // Tagline Pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'WISATA KOTA TERNATE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Tagline Utama
                const Text(
                  'Jelajahi Ternate,\nTemukan Spotmu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    fontFamily: 'Poppins',
                  ),
                ),

                const Spacer(flex: 3),

                // Gelombang Transparan
                SizedBox(
                  width: screenWidth,
                  height: 40,
                  child: CustomPaint(
                    size: Size(screenWidth, 40),
                    painter: _WavePainter(),
                  ),
                ),

                const SizedBox(height: 12),

                // Tombol "Mulai Jelajah"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _goToHome(context),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        height: 58,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Mulai Jelajah',
                              style: TextStyle(
                                color: Color(0xFF1D61E7),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1D61E7),
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
                  ),
                ),

                const SizedBox(height: 24),

                // Footer
                Text(
                  'v1.0.0 • "Penjata Metuku Utara"',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RealisticIslandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1E6DB3),
          Color(0xFF3383CA),
          Color(0xFF5CA3DE),
          Color(0xFF8DC0EC),
        ],
        stops: [0.0, 0.4, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.48));

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.48), skyPaint);

    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(Offset(w * 0.15, h * 0.28), 65, cloudPaint);
    canvas.drawCircle(Offset(w * 0.85, h * 0.32), 80, cloudPaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.36), 50, cloudPaint);

    final seaPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1B5985),
          Color(0xFF124368),
          Color(0xFF0C304B),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.45, w, h * 0.55));

    canvas.drawRect(Rect.fromLTWH(0, h * 0.45, w, h * 0.55), seaPaint);

    final mountainPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF3B5B42),
          Color(0xFF2C4A33),
          Color(0xFF1E3825),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.26, w, h * 0.32));

    final mountainPath = Path();
    mountainPath.moveTo(-w * 0.1, h * 0.55);
    mountainPath.cubicTo(w * 0.15, h * 0.48, w * 0.33, h * 0.34, w * 0.47, h * 0.27);
    mountainPath.lineTo(w * 0.53, h * 0.27);
    mountainPath.cubicTo(w * 0.67, h * 0.34, w * 0.85, h * 0.48, w * 1.1, h * 0.55);
    mountainPath.lineTo(w * 1.1, h * 0.65);
    mountainPath.lineTo(-w * 0.1, h * 0.65);
    mountainPath.close();

    canvas.drawPath(mountainPath, mountainPaint);

    final ridgePaint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    final ridgePath = Path();
    ridgePath.moveTo(w * 0.50, h * 0.27);
    ridgePath.cubicTo(w * 0.44, h * 0.38, w * 0.38, h * 0.46, w * 0.20, h * 0.55);
    ridgePath.lineTo(w * 0.58, h * 0.55);
    ridgePath.close();

    canvas.drawPath(ridgePath, ridgePaint);

    final hillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2D5032),
          Color(0xFF19321D),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.48, w, h * 0.25));

    final hillPath = Path();
    hillPath.moveTo(-w * 0.05, h * 0.55);
    hillPath.cubicTo(w * 0.20, h * 0.49, w * 0.40, h * 0.51, w * 0.55, h * 0.53);
    hillPath.cubicTo(w * 0.70, h * 0.48, w * 0.88, h * 0.49, w * 1.05, h * 0.53);
    hillPath.lineTo(w * 1.05, h * 0.68);
    hillPath.lineTo(-w * 0.05, h * 0.68);
    hillPath.close();

    canvas.drawPath(hillPath, hillPaint);

    final shorePaint = Paint()..color = const Color(0xFF22281D);
    final shorePath = Path();
    shorePath.moveTo(w * 0.55, h * 0.55);
    shorePath.quadraticBezierTo(w * 0.72, h * 0.60, w * 0.82, h * 0.68);
    shorePath.quadraticBezierTo(w * 0.90, h * 0.74, w * 1.0, h * 0.78);
    shorePath.lineTo(w * 1.0, h * 0.82);
    shorePath.lineTo(w * 0.50, h * 0.58);
    shorePath.close();

    canvas.drawPath(shorePath, shorePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const primaryBlue = Color(0xFF1D61E7);

    final sunPaint = Paint()
      ..color = const Color(0xFFFF9800)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.32),
      size.width * 0.12,
      sunPaint,
    );

    final mountainPaint = Paint()
      ..color = primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final mountainPath = Path();
    mountainPath.moveTo(size.width * 0.18, size.height * 0.62);
    mountainPath.lineTo(size.width * 0.45, size.height * 0.30);
    mountainPath.lineTo(size.width * 0.72, size.height * 0.62);

    canvas.drawPath(mountainPath, mountainPaint);

    final wavePaint = Paint()
      ..color = primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final wavePath = Path();
    wavePath.moveTo(size.width * 0.15, size.height * 0.75);
    wavePath.quadraticBezierTo(
      size.width * 0.35,
      size.height * 0.65,
      size.width * 0.55,
      size.height * 0.75,
    );
    wavePath.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.85,
      size.width * 0.88,
      size.height * 0.75,
    );

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.fill;

    final wavePath = Path();
    wavePath.moveTo(0, size.height * 0.4);
    wavePath.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width * 0.6,
      size.height * 0.5,
    );
    wavePath.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.8,
      size.width,
      size.height * 0.5,
    );
    wavePath.lineTo(size.width, size.height);
    wavePath.lineTo(0, size.height);
    wavePath.close();

    canvas.drawPath(wavePath, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}