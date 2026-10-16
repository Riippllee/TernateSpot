import 'package:flutter/material.dart';

import '../../controller/favorit_controller.dart';
import '../../model/favorit_model.dart';

// Halaman untuk menguji fitur Favorit
class FavoritPage extends StatefulWidget {
  const FavoritPage({super.key});

  @override
  State<FavoritPage> createState() => _FavoritPageState();
}

class _FavoritPageState extends State<FavoritPage> {
  // Menghubungkan View dengan Controller
  final controller = FavoritController();

  // Menampung daftar favorit dari Supabase
  List<Favorit> daftarFavorit = [];

  // Menyimpan input ID destinasi
  final idDestinasiInput = TextEditingController();

  // Status proses pengambilan dan penyimpanan data
  bool loading = true;
  bool menyimpan = false;
  String? pesanError;

  @override
  void initState() {
    super.initState();

    // Mengambil data saat halaman pertama dibuka
    ambilFavorit();
  }

  // READ: mengambil favorit dari Supabase
  Future<void> ambilFavorit() async {
    if (mounted) {
      setState(() {
        loading = true;
        pesanError = null;
      });
    }

    try {
      final data = await controller.lihatFavorit();

      if (!mounted) return;

      setState(() {
        daftarFavorit = data;
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

  // Menampilkan pesan hasil operasi
  void tampilPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  // CREATE: menyimpan favorit ke Supabase
  Future<void> tambahFavorit() async {
    final idDestinasi = int.tryParse(idDestinasiInput.text.trim());

    // Validasi agar ID destinasi tidak kosong/salah
    if (idDestinasi == null || idDestinasi <= 0) {
      tampilPesan('Masukkan ID destinasi yang valid');
      return;
    }

    setState(() {
      menyimpan = true;
    });

    try {
      await controller.tambahFavorit(idDestinasi);

      // Mengosongkan input setelah berhasil
      idDestinasiInput.clear();

      tampilPesan('Favorit berhasil ditambahkan');

      // Mengambil ulang data dari Supabase
      await ambilFavorit();
    } catch (e) {
      tampilPesan('Gagal menambah favorit: $e');
    } finally {
      if (mounted) {
        setState(() {
          menyimpan = false;
        });
      }
    }
  }

  // DELETE: menghapus favorit dari Supabase
  Future<void> hapusFavorit(int idFavorit) async {
    try {
      await controller.hapusFavorit(idFavorit);

      tampilPesan('Favorit berhasil dihapus');

      // Refresh daftar setelah penghapusan
      await ambilFavorit();
    } catch (e) {
      tampilPesan('Gagal menghapus favorit: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Destinasi'),
        centerTitle: true,

        // Tombol refresh data
        actions: [
          IconButton(onPressed: ambilFavorit, icon: const Icon(Icons.refresh)),
        ],
      ),

      body: Column(
        children: [
          // ==========================
          // FORM TAMBAH FAVORIT
          // ==========================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Tambah Favorit',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: idDestinasiInput,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ID Destinasi',
                    hintText: 'Contoh: 11',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: menyimpan ? null : tambahFavorit,
                  icon: const Icon(Icons.favorite),
                  label: Text(menyimpan ? 'Menyimpan...' : 'Tambah Favorit'),
                ),
              ],
            ),
          ),

          const Divider(),

          // ==========================
          // DAFTAR FAVORIT
          // ==========================
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Favorit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Menampilkan loading, error, atau daftar data
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : pesanError != null
                ? Center(child: Text(pesanError!))
                : daftarFavorit.isEmpty
                ? const Center(child: Text('Belum ada favorit'))
                : ListView.builder(
                    itemCount: daftarFavorit.length,

                    itemBuilder: (context, index) {
                      final favorit = daftarFavorit[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),

                        child: ListTile(
                          leading: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),

                          title: Text('Destinasi ID: ${favorit.idDestinasi}'),

                          subtitle: Text(
                            'Ditambahkan: '
                            '${favorit.tanggalDitambah?.toLocal().toString() ?? "-"}',
                          ),

                          // Tombol hapus favorit
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: favorit.idFavorit == null
                                ? null
                                : () => hapusFavorit(favorit.idFavorit!),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Membersihkan controller ketika halaman ditutup
  @override
  void dispose() {
    idDestinasiInput.dispose();
    super.dispose();
  }
}
