import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/test/log_admin_test.dart'; //tes log admin

// import 'views/test/ulasan_test.dart'; //tes ulasan

// import 'views/test/rekomendasi_test.dart'; //tes rekomendasi

void main() async {
  //bagian penting jangan otak atik ini supabase punya
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ciarqtbkgdmupfiuuvab.supabase.co',
    publishableKey: 'sb_publishable_xh9OxC4GQLHuhv46L8MjQQ_5TeP1IG_',
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  //Ntr Frontend kalau dah clone, ubah yang ini yee kalo mau cek widgate yang kalian buat
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LogAdminTest()); //log admin
    // return MaterialApp(home: RekomendasiTest()); //rekomendasi
    // return MaterialApp(home: UlasanTest()); //ulasan

    //     home: Scaffold(
    //   appBar: AppBar(title: const Text('TernateSpot')),
    //   body: const Center(child: Text('Supabase Terhubung!')),
    // ),
  }
}
