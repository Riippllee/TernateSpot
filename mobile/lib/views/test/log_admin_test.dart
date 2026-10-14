import 'package:flutter/material.dart';

import '../../../../../../controller/log_admin_controller.dart';
import '../../../../../../model/log_admin_model.dart'; //  menyimpan data log admin dalam bentuk object Dart

// LogAdminTest merupakan halaman tampilan (View)
class LogAdminTest extends StatefulWidget {
  const LogAdminTest({super.key});

  @override
  State<LogAdminTest> createState() => _LogAdminTestState();
}

// State digunakan karena halaman ini memiliki data yang dapat berubah
class _LogAdminTestState extends State<LogAdminTest> {
  // Membuat objek Controller
  final controller = LogAdminController();

  // Menyimpan daftar data log admin yang diterima dari Supabase
  // Awalnya masih kosong sebelum data berhasil diambil
  List<LogAdmin> logs = [];

  // Fungsi yang dijalankan pertama kali ketika halaman dibuka
  @override
  void initState() {
    super.initState();

    ambilLog();
  }

  // Fungsi untuk mengambil data log admin melalui Controller
  Future<void> ambilLog() async {
    print("Mulai ambil log");

    final data = await controller.lihatLog();

    // Menampilkan jumlah data yang berhasil diterima
    print("Jumlah log: ${data.length}");

    // Memperbarui nilai state agar tampilan Flutter
    // melakukan proses rebuild dengan data terbaru
    setState(() {
      logs = data;
    });
  }

  // Membuat tampilan halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Log Admin")),

      // Data ditampilkan berdasarkan jumlah data pada List logs
      body: ListView.builder(
        itemCount: logs.length,

        itemBuilder: (context, index) {
          // Mengambil data log berdasarkan posisi index
          final log = logs[index];

          // Menampilkan setiap data log dalam bentuk ListTile
          return ListTile(
            // Menampilkan isi aktivitas admin
            title: Text(log.aktivitas),

            // Menampilkan waktu aktivitas dilakukan
            subtitle: Text(log.tanggalAktivitas.toString()),
          );
        },
      ),
    );
  }
}
