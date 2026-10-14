import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//CRUD
import 'views/rekomendasi/rekomendasi_page.dart'; // rekkomendasi

// import 'views/log_admin/log_admin_page.dart'; //log admin

// import 'views/ulasan/ulasan_test.dart'; //ulasan

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
    // return const MaterialApp(debugShowCheckedModeBanner: false,
    //home: const UlasanTest());

    //REKOMENDASI CRUD
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //ks ilang tulisan debug
      home: RekomendasiCrudPage(),
    );

    //LOG ADMIN CRUD
    // return const MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: LogAdminPage(),
    // );
  }
}
//-------------------------------------------------------------------Ini yang test--------------------
//    home: Scaffold(
//   appBar: AppBar(title: const Text( d'TernateSpot')),
//   body: const Center(child: Text('Supabase Terhubung!')),

//TES INSERT (import)
// import 'views/test/log_admin_test.dart'; //test log admin
// import 'views/test/rekomendasi_test.dart'; //tes rekomendasi
// import 'views/test/ulasan_test.dart'; //tes ulasan

//TEST INSERT (return)
// return MaterialApp(home: LogAdminTest()); //log admin test
// return MaterialApp(home: RekomendasiTest()); //tes rekomendasi
// return MaterialApp(home: UlasanTest()); //tes ulasan
