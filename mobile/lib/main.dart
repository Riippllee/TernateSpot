import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/admin/test_user_management_page.dart.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestUserManagementPage(), // Menampilkan LoginPage di emulator
    );
  }
}
