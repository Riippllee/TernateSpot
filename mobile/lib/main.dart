import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'views/auth/daftar_page.dart';
<<<<<<< HEAD
import 'views/auth/splash_page.dart';
=======
import 'views/auth/login_page.dart';
>>>>>>> c068207932ff65f4c48bfa2fd8cb28f243f0eda0

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Koneksi Flutter dengan Supabase
  await Supabase.initialize(
    url: 'https://ciarqtbkgdmupfiuuvab.supabase.co',
    publishableKey: 'sb_publishable_xh9OxC4GQLHuhv46L8MjQQ_5TeP1IG_',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD

      // Halaman pertama yang dibuka
      home: SplashPage(),
=======
      home: LoginPage(), // Menampilkan LoginPage di emulator
>>>>>>> c068207932ff65f4c48bfa2fd8cb28f243f0eda0
    );
  }
}