import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import halaman Beranda USER
import 'views/auth/beranda_page.dart';

void main() async {
  // Inisialisasi Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Koneksi Supabase (tetap dipertahankan)
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TernateSpot',

      // Langsung menampilkan Beranda USER
      home: const BerandaPage(),
    );
  }
}
