import 'package:flutter/material.dart';

import '../../controller/ulasan_controller.dart';
import '../../model/ulasan_model.dart';

class UlasanTest extends StatefulWidget {
  const UlasanTest({super.key});

  @override
  State<UlasanTest> createState() => _UlasanTestState();
}

class _UlasanTestState extends State<UlasanTest> {
  // Memanggil controller ulasan untuk menghubungkan View dengan Controller
  final controller = UlasanController();

  // Menampung data ulasan yang diambil dari Supabase
  List<Ulasan> data = [];

  String pesan = "";

  // Fungsi untuk mengambil data ulasan dari Supabase melalui Controller
  Future<void> ambilUlasan() async {
    print("Mulai ambil ulasan");

    try {
      // View memanggil Controller
      final hasil = await controller.lihatUlasan();

      print("Jumlah ulasan: ${hasil.length}");

      setState(() {
        data = hasil;
      });
    } catch (e) {
      setState(() {
        pesan = "Gagal mengambil ulasan: $e";
      });
    }
  }

  // Fungsi untuk mengubah data ulasan yang sudah ada
  Future<void> ubahUlasan(Ulasan ulasan) async {
    final komentarEdit = TextEditingController(text: ulasan.komentar);
    final ratingEdit = TextEditingController(text: ulasan.rating.toString());

    bool statusEdit = ulasan.status;

    final simpan = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Edit Ulasan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Input perubahan rating ulasan
                  TextField(
                    controller: ratingEdit,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Rating 1-5"),
                  ),

                  // Input perubahan komentar ulasan
                  TextField(
                    controller: komentarEdit,
                    decoration: const InputDecoration(labelText: "Komentar"),
                  ),

                  // Mengatur status aktif/nonaktif ulasan
                  SwitchListTile(
                    title: const Text("Status Aktif"),
                    value: statusEdit,
                    onChanged: (value) {
                      setDialogState(() {
                        statusEdit = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Simpan"),
                ),
              ],
            );
          },
        );
      },
    );

    if (simpan == true) {
      final ratingBaru = int.tryParse(ratingEdit.text.trim());

      if (ratingBaru == null ||
          ratingBaru < 1 ||
          ratingBaru > 5 ||
          komentarEdit.text.trim().isEmpty) {
        setState(() {
          pesan = "Rating harus 1-5 dan komentar tidak kosong";
        });
      } else {
        final ulasanBaru = Ulasan(
          idUlasan: ulasan.idUlasan,
          idUser: ulasan.idUser,
          idDestinasi: ulasan.idDestinasi,
          rating: ratingBaru,
          komentar: komentarEdit.text.trim(),
          status: statusEdit,
        );

        await controller.ubahUlasan(ulasanBaru);

        setState(() {
          pesan = "Ulasan berhasil diubah";
        });

        await ambilUlasan();
      }
    }

    ratingEdit.dispose();
    komentarEdit.dispose();
  }

  // Fungsi untuk menghapus data ulasan berdasarkan ID ulasan
  Future<void> hapusUlasan(int id) async {
    try {
      // Controller menjalankan proses DELETE melalui Service
      await controller.hapusUlasan(id);

      setState(() {
        pesan = "Ulasan berhasil dihapus";
      });

      // Memuat ulang data setelah berhasil hapus
      await ambilUlasan();
    } catch (e) {
      setState(() {
        pesan = "Gagal menghapus ulasan: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // Menjalankan READ otomatis ketika halaman pertama kali dibuka
    ambilUlasan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD Ulasan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Menampilkan pesan hasil proses CRUD
            if (pesan.isNotEmpty) Text(pesan),

            const Divider(),

            // Menampilkan seluruh data ulasan dari Supabase
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final ulasan = data[index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("User : ${ulasan.idUser}"),
                        Text("Destinasi : ${ulasan.idDestinasi}"),
                        Text("Rating : ${ulasan.rating}"),
                        Text("Komentar : ${ulasan.komentar}"),
                        Text(
                          "Status : ${ulasan.status ? "Aktif" : "Nonaktif"}",
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            // Tombol untuk membuka form edit ulasan
                            ElevatedButton(
                              onPressed: () {
                                ubahUlasan(ulasan);
                              },
                              child: const Text("Edit"),
                            ),

                            const SizedBox(width: 10),

                            // Tombol untuk menghapus ulasan
                            ElevatedButton(
                              onPressed: () {
                                hapusUlasan(ulasan.idUlasan!);
                              },
                              child: const Text("Hapus"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
