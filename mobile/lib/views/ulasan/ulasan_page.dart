import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controller/ulasan_controller.dart';
import '../../model/ulasan_model.dart';

// Halaman CRUD Ulasan untuk USER
class UlasanPage extends StatefulWidget {
  const UlasanPage({super.key});

  @override
  State<UlasanPage> createState() => _UlasanPageState();
}

class _UlasanPageState extends State<UlasanPage> {
  // Menghubungkan View dengan Controller
  final controller = UlasanController();

  // Menyimpan data ulasan dari Supabase
  List<Ulasan> daftarUlasan = [];

  // Controller untuk input form
  final idDestinasiInput = TextEditingController();
  final komentarInput = TextEditingController();

  int rating = 5;
  int? idSedangEdit;

  bool loading = true;
  bool menyimpan = false;
  String? pesanError;

  // Mengambil ID user yang sedang login
  String? get idUserLogin => Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    ambilUlasan();
  }

  // READ: mengambil data ulasan dari Supabase
  Future<void> ambilUlasan() async {
    setState(() {
      loading = true;
      pesanError = null;
    });

    try {
      final data = await controller.lihatUlasan();

      if (!mounted) return;

      setState(() {
        daftarUlasan = data;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        pesanError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // Menampilkan pesan berhasil atau gagal
  void tampilPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  // CREATE dan UPDATE: menyimpan data ulasan
  Future<void> simpanUlasan() async {
    final idDestinasi = int.tryParse(idDestinasiInput.text.trim());

    // Validasi input sebelum dikirim ke Supabase
    if (idDestinasi == null || idDestinasi <= 0) {
      tampilPesan('Masukkan ID destinasi yang valid');
      return;
    }

    if (komentarInput.text.trim().isEmpty) {
      tampilPesan('Komentar tidak boleh kosong');
      return;
    }

    if (idUserLogin == null) {
      tampilPesan('Silakan login terlebih dahulu');
      return;
    }

    setState(() {
      menyimpan = true;
    });

    try {
      if (idSedangEdit == null) {
        // CREATE: menambahkan ulasan baru
        await controller.tambahUlasan(
          idDestinasi: idDestinasi,
          rating: rating,
          komentar: komentarInput.text.trim(),
        );

        tampilPesan('Ulasan berhasil ditambahkan');
      } else {
        // UPDATE: mengubah ulasan yang dipilih
        final ulasan = Ulasan(
          idUlasan: idSedangEdit,
          idUser: idUserLogin!,
          idDestinasi: idDestinasi,
          rating: rating,
          komentar: komentarInput.text.trim(),
          status: true,
        );

        await controller.ubahUlasan(ulasan);

        tampilPesan('Ulasan berhasil diperbarui');
      }

      // Mengosongkan form setelah berhasil
      resetForm();

      // Mengambil ulang data dari database
      await ambilUlasan();
    } catch (e) {
      tampilPesan('Gagal menyimpan ulasan: $e');
    } finally {
      if (mounted) {
        setState(() {
          menyimpan = false;
        });
      }
    }
  }

  // Mengisi form dengan data yang ingin diubah
  void editUlasan(Ulasan ulasan) {
    setState(() {
      idSedangEdit = ulasan.idUlasan;
      idDestinasiInput.text = ulasan.idDestinasi.toString();
      komentarInput.text = ulasan.komentar;
      rating = ulasan.rating;
    });
  }

  // DELETE: menghapus ulasan berdasarkan ID
  Future<void> hapusUlasan(int idUlasan) async {
    try {
      await controller.hapusUlasan(idUlasan);

      tampilPesan('Ulasan berhasil dihapus');

      await ambilUlasan();
    } catch (e) {
      tampilPesan('Gagal menghapus ulasan: $e');
    }
  }

  // Mengembalikan form ke kondisi awal
  void resetForm() {
    setState(() {
      idSedangEdit = null;
      idDestinasiInput.clear();
      komentarInput.clear();
      rating = 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Ulasan User'),
        actions: [
          IconButton(onPressed: ambilUlasan, icon: const Icon(Icons.refresh)),
        ],
      ),

      body: Column(
        children: [
          // FORM INPUT ULASAN
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  idSedangEdit == null ? 'Tambah Ulasan' : 'Edit Ulasan',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: idDestinasiInput,
                  keyboardType: TextInputType.number,
                  readOnly: idSedangEdit != null,
                  decoration: const InputDecoration(
                    labelText: 'ID Destinasi',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                // Memilih rating dari 1 sampai 5
                DropdownButtonFormField<int>(
                  value: rating,
                  decoration: const InputDecoration(
                    labelText: 'Rating',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(
                    5,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1} Bintang'),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      rating = value ?? 5;
                    });
                  },
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: komentarInput,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Komentar',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: menyimpan ? null : simpanUlasan,
                  child: Text(
                    idSedangEdit == null ? 'Tambah Ulasan' : 'Simpan Perubahan',
                  ),
                ),

                if (idSedangEdit != null)
                  TextButton(
                    onPressed: resetForm,
                    child: const Text('Batal Edit'),
                  ),
              ],
            ),
          ),

          const Divider(),

          // DAFTAR ULASAN
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : pesanError != null
                ? Center(child: Text(pesanError!))
                : daftarUlasan.isEmpty
                ? const Center(child: Text('Belum ada ulasan'))
                : ListView.builder(
                    itemCount: daftarUlasan.length,
                    itemBuilder: (context, index) {
                      final ulasan = daftarUlasan[index];

                      // Memeriksa kepemilikan ulasan
                      final milikSendiri = ulasan.idUser == idUserLogin;

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text('Destinasi ID: ${ulasan.idDestinasi}'),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rating: ${ulasan.rating}/5'),
                              Text(ulasan.komentar),
                              Text(
                                'Tanggal: '
                                '${ulasan.tanggalDitambah?.toLocal().toString() ?? "-"}',
                              ),
                            ],
                          ),

                          // Edit dan hapus hanya untuk pemilik
                          trailing: milikSendiri
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => editUlasan(ulasan),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: ulasan.idUlasan == null
                                          ? null
                                          : () => hapusUlasan(ulasan.idUlasan!),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    idDestinasiInput.dispose();
    komentarInput.dispose();
    super.dispose();
  }
}
