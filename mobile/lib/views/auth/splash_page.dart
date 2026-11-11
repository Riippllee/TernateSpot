import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ternatespot/views/auth/login_page.dart';
import 'package:ternatespot/views/test/test_profile_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Tunggu 2 detik agar splash screen terlihat
    await Future.delayed(const Duration(seconds: 2));

    // Cek apakah ada session yang aktif di Supabase
    final session = Supabase.instance.client.auth.currentSession;

    if (mounted) {
      if (session != null) {
        print('✅ Session ditemukan di SplashPage, user sudah login');
        // User sudah login → Arahkan ke TestProfilePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TestProfilePage()),
        );
      } else {
        print('❌ Tidak ada session di SplashPage, arahkan ke Login');
        // User belum login → Arahkan ke LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0066FF), // Warna biru TernateSpot
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.landscape_rounded,
              color: Colors.white,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'ternateSpot',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'WISATA KOTA TERNATE',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}