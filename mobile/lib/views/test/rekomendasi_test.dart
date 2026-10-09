import 'package:flutter/material.dart';

import '../../controller/rekomendasi_controller.dart';
import '../../model/rekomendasi_model.dart';

class RekomendasiTest extends StatefulWidget {
  const RekomendasiTest({super.key});

  @override
  State<RekomendasiTest> createState() => _RekomendasiTestState();
}

class _RekomendasiTestState extends State<RekomendasiTest> {
  // Memanggil controller rekomendasi
  final controller = RekomendasiController();

  // Menampung hasil data
  List<Rekomendasi> data = [];

  // Fungsi untuk mengetes READ rekomendasi
  Future<void> ambilRekomendasi() async {
    print("Mulai ambil rekomendasi");

    // View memanggil Controller
    final hasil = await controller.lihatRekomendasi();

    print("Jumlah rekomendasi: ${hasil.length}");

    setState(() {
      data = hasil;
    });
  }

  @override
  void initState() {
    super.initState();

    // otomatis menjalankan test saat halaman dibuka
    ambilRekomendasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Rekomendasi")),

      body: ListView.builder(
        itemCount: data.length,

        itemBuilder: (context, index) {
          final rekomendasi = data[index];

          return ListTile(
            title: Text("Destinasi ID : ${rekomendasi.idDestinasi}"),

            subtitle: Text("Prioritas : ${rekomendasi.prioritas}"),
          );
        },
      ),
    );
  }
}
