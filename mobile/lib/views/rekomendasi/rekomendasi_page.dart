import 'package:flutter/material.dart';

import '../../controller/rekomendasi_controller.dart';
import '../../model/rekomendasi_model.dart';

// Halaman untuk menampilkan rekomendasi aktif
class RekomendasiPage extends StatefulWidget {
  const RekomendasiPage({super.key});

  @override
  State<RekomendasiPage> createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  // Menghubungkan View dengan Controller
  final controller = RekomendasiController();

  // Menyimpan data rekomendasi dari Supabase
  List<Rekomendasi> daftarRekomendasi = [];

  // Menandakan proses pengambilan data
  bool loading = true;

  // Menyimpan pesan error
  String? pesanError;

  @override
  void initState() {
    super.initState();
    ambilRekomendasi();
  }

  // READ: mengambil data melalui Controller
  Future<void> ambilRekomendasi() async {
    setState(() {
      loading = true;
      pesanError = null;
    });

    try {
      final data = await controller.lihatRekomendasiAktif();

      if (!mounted) return;

      setState(() {
        daftarRekomendasi = data;
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

  // Membuat tampilan halaman rekomendasi
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Destinasi'),
        centerTitle: true,

        // Tombol refresh data dari Supabase
        actions: [
          IconButton(
            onPressed: ambilRekomendasi,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : pesanError != null
          ? Center(child: Text('Gagal mengambil data: $pesanError'))
          : daftarRekomendasi.isEmpty
          ? const Center(child: Text('Belum ada rekomendasi aktif'))
          : Column(
              children: [
                // Menampilkan jumlah rekomendasi
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Total Rekomendasi Aktif: '
                    '${daftarRekomendasi.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Menampilkan daftar rekomendasi
                Expanded(
                  child: ListView.builder(
                    itemCount: daftarRekomendasi.length,
                    itemBuilder: (context, index) {
                      final rekomendasi = daftarRekomendasi[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const Icon(
                            Icons.place,
                            color: Colors.purple,
                            size: 32,
                          ),

                          title: Text(
                            'Destinasi ID: '
                            '${rekomendasi.idDestinasi}',
                          ),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prioritas: '
                                '${rekomendasi.prioritas}',
                              ),

                              const Text('Status: Aktif'),

                              Text(
                                'Tanggal Ditambah: '
                                '${rekomendasi.tanggalDitambah?.toLocal().toString() ?? "-"}',
                              ),
                            ],
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
}
