import 'package:flutter/material.dart';

// Memanggil controller ulasan
// Controller bertugas menjadi penghubung View dengan Service
import '../../controller/ulasan_controller.dart';

// Memanggil model ulasan
// Digunakan untuk menampung data dari Supabase
import '../../model/ulasan_model.dart';

class UlasanTest extends StatefulWidget {
  const UlasanTest({super.key});

  @override
  State<UlasanTest> createState() => _UlasanTestState();
}

class _UlasanTestState extends State<UlasanTest> {
  // Membuat object controller ulasan
  // agar View dapat meminta data melalui Controller
  final controller = UlasanController();

  // Menyimpan hasil data ulasan
  List<Ulasan> data = [];

  // ===============================
  // TEST READ ULASAN
  // ===============================
  //
  // Fungsi ini digunakan untuk mengecek:
  //
  // View
  //  ↓
  // Controller
  //  ↓
  // Service
  //  ↓
  // Supabase
  //
  // apakah sudah berhasil mengambil data

  Future<void> ambilUlasan() async {
    print("Mulai mengambil data ulasan");

    try {
      // View memanggil Controller
      // Controller akan memanggil Service
      final hasil = await controller.lihatUlasan();

      // Menampilkan jumlah data di console

      print("Jumlah ulasan : ${hasil.length}");

      // Menampilkan isi data satu per satu
      for (var ulasan in hasil) {
        print("Destinasi ID : ${ulasan.idDestinasi}");

        print("Rating : ${ulasan.rating}");

        print("Komentar : ${ulasan.komentar}");
      }

      // Menampilkan data ke halaman test

      setState(() {
        data = hasil;
      });
    } catch (e) {
      // Jika gagal, tampilkan error

      print("Error Ulasan : $e");
    }
  }

  @override
  void initState() {
    super.initState();

    // Saat halaman dibuka,
    // langsung menjalankan test

    ambilUlasan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Ulasan MSCV")),

      body: data.isEmpty
          ? const Center(child: Text("Belum ada data ulasan"))
          : ListView.builder(
              itemCount: data.length,

              itemBuilder: (context, index) {
                final ulasan = data[index];

                return Card(
                  child: ListTile(
                    title: Text("Rating : ${ulasan.rating}"),

                    subtitle: Text(ulasan.komentar),
                  ),
                );
              },
            ),
    );
  }
}
