// Mengimpor library Material Flutter.
// Library ini digunakan untuk membuat tampilan aplikasi,
// seperti halaman, tombol, teks, dan komponen lainnya.
import 'package:flutter/material.dart';
// Mengimpor library Supabase.
// Library ini digunakan untuk menghubungkan aplikasi
// Flutter dengan layanan Supabase.
import 'package:supabase_flutter/supabase_flutter.dart';
// Mengimpor halaman Management User.
// File ini berisi tampilan untuk mengelola data pengguna.
import 'views/auth/admin/management_user_page.dart';

// Fungsi main adalah titik awal ketika aplikasi dijalankan.
// Future<void> digunakan karena proses inisialisasi
// Supabase membutuhkan proses asynchronous (async).
Future<void> main() async {
  // Memastikan semua komponen Flutter siap digunakan
  // sebelum aplikasi mulai dijalankan.
  WidgetsFlutterBinding.ensureInitialized();

  // Koneksi Flutter dengan Supabase
  await Supabase.initialize(
    // URL menunjukkan alamat proyek Supabase.
    url: 'https://ciarqtbkgdmupfiuuvab.supabase.co',
     // publishableKey digunakan untuk mengenali proyek
     // saat aplikasi melakukan permintaan ke Supabase.
    publishableKey: 'sb_publishable_xh9OxC4GQLHuhv46L8MjQQ_5TeP1IG_',
  );

  // Menjalankan aplikasi dengan widget utama MainApp.
  // const digunakan karena MainApp tidak memerlukan
  // pembuatan ulang objek pada bagian ini.
  runApp(const MainApp());
}

// MainApp adalah widget utama aplikasi TernateSpot.
// StatelessWidget digunakan karena konfigurasi utama
// pada widget ini tidak menyimpan state yang berubah.
class MainApp extends StatelessWidget {
  // Constructor untuk membuat objek MainApp.
  // super.key meneruskan key ke kelas induknya.
  const MainApp({super.key});

  // Fungsi build digunakan untuk menyusun tampilan widget.
  // Flutter memanggil fungsi ini untuk membuat antarmuka.
  @override
  Widget build(BuildContext context) {
    // MaterialApp mengatur konfigurasi utama aplikasi,
    // termasuk judul dan halaman yang pertama dibuka.
    return MaterialApp(
      // Menghilangkan tulisan DEBUG di pojok aplikasi
      // ketika dijalankan dalam mode pengembangan.
      debugShowCheckedModeBanner: false,
      // Menentukan nama aplikasi.
      title: 'TernateSpot',

       // Halaman pertama yang dibuka
       home: const ManagementUserPage(),
    );
  }
}