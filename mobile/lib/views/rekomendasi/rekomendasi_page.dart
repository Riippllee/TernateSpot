import 'package:flutter/material.dart';

import '../../controller/rekomendasi_controller.dart';
import '../../model/rekomendasi_model.dart';

// HALAMAN CRUD REKOMENDASI
class RekomendasiCrudPage extends StatefulWidget {
  const RekomendasiCrudPage({super.key});

  @override
  State<RekomendasiCrudPage> createState() => _RekomendasiCrudPageState();
}

class _RekomendasiCrudPageState extends State<RekomendasiCrudPage> {
  // Membuat objek Controller rekomendasi
  final controller = RekomendasiController();

  // Menampung data rekomendasi dari Supabase
  List<Rekomendasi> daftarRekomendasi = [];

  // Mengatur input form
  final idDestinasiInput = TextEditingController();
  final prioritasInput = TextEditingController();

  // Menyimpan status rekomendasi
  bool statusAktif = true;

  // Jika null berarti tambah, jika ada ID berarti edit
  int? idSedangEdit;

  // Menentukan apakah hanya rekomendasi aktif yang tampil
  bool hanyaAktif = false;

  // Status proses dan pesan hasil
  bool loading = false;
  String pesan = '';

  // READ: MENGAMBIL DATA REKOMENDASI
  Future<void> ambilRekomendasi() async {
    setState(() {
      loading = true;
      pesan = '';
    });

    try {
      // View > Controller > Service > Supabase
      final hasil = await controller.lihatRekomendasi();
      if (!mounted) return;
      setState(() {
        daftarRekomendasi = hasil;
      });
      debugPrint('Jumlah rekomendasi: ${hasil.length}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        pesan = 'Gagal mengambil rekomendasi: $e';
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // MEMBERSIHKAN FORM TAMBAH / EDIT
  void bersihkanForm() {
    idDestinasiInput.clear();
    prioritasInput.clear();

    setState(() {
      idSedangEdit = null;
      statusAktif = true;
    });
  }

  // CREATE DAN UPDATE REKOMENDASI
  Future<void> simpanRekomendasi() async {
    // Mengubah teks input menjadi angka
    final idDestinasi = int.tryParse(idDestinasiInput.text.trim());
    final prioritas = int.tryParse(prioritasInput.text.trim());

    // Memastikan input tidak kosong atau tidak valid
    if (idDestinasi == null ||
        idDestinasi <= 0 ||
        prioritas == null ||
        prioritas < 1) {
      setState(() {
        pesan =
            'ID destinasi dan prioritas harus '
            'berupa angka positif.';
      });

      return;
    }

    // Menyimpan mode sebelum operasi dijalankan
    final sedangEdit = idSedangEdit != null;

    setState(() => loading = true);

    try {
      // Membuat objek Model sesuai kolom database
      final rekomendasi = Rekomendasi(
        idRekomendasi: idSedangEdit,
        idDestinasi: idDestinasi,
        prioritas: prioritas,
        status: statusAktif,
      );

      if (sedangEdit) {
        // UPDATE: mengubah rekomendasi yang sudah ada
        await controller.ubahRekomendasi(rekomendasi);
      } else {
        // CREATE: menambahkan rekomendasi baru
        await controller.tambahRekomendasi(rekomendasi);
      }

      if (!mounted) return;

      // Membersihkan form setelah operasi berhasil
      bersihkanForm();

      // Mengambil data terbaru dari Supabase
      await ambilRekomendasi();

      if (!mounted) return;

      setState(() {
        pesan = sedangEdit
            ? 'Rekomendasi berhasil diperbarui.'
            : 'Rekomendasi berhasil ditambahkan.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        pesan = 'Gagal menyimpan rekomendasi: $e';
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // EDIT: MENGISI FORM DENGAN DATA LAMA
  void mulaiEdit(Rekomendasi rekomendasi) {
    // Menampilkan data lama ke dalam input form
    idDestinasiInput.text = rekomendasi.idDestinasi.toString();

    prioritasInput.text = rekomendasi.prioritas.toString();

    setState(() {
      idSedangEdit = rekomendasi.idRekomendasi;
      statusAktif = rekomendasi.status;
      pesan = '';
    });
  }

  // DELETE: MENGHAPUS REKOMENDASI
  Future<void> hapusRekomendasi(int id) async {
    // Menampilkan dialog konfirmasi
    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Rekomendasi'),
        content: const Text('Yakin ingin menghapus rekomendasi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (yakin != true || !mounted) return;

    setState(() => loading = true);

    try {
      // Menghapus berdasarkan primary key id_rekomendasi
      await controller.hapusRekomendasi(id);

      if (!mounted) return;

      // Jika data yang sedang diedit dihapus,
      // kosongkan form agar tidak mengedit data lama
      if (idSedangEdit == id) {
        bersihkanForm();
      }

      // Memperbarui daftar setelah DELETE
      await ambilRekomendasi();

      if (!mounted) return;

      setState(() {
        pesan = 'Rekomendasi berhasil dihapus.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        pesan = 'Gagal menghapus rekomendasi: $e';
      });
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  // KEADAAN AWAL
  @override
  void initState() {
    super.initState();

    // Otomatis mengambil data rekomendasi
    ambilRekomendasi();
  }

  // Membersihkan controller input saat halaman ditutup
  @override
  void dispose() {
    idDestinasiInput.dispose();
    prioritasInput.dispose();
    super.dispose();
  }

  // VIEW: TAMPILAN HALAMAN CRUD
  @override
  Widget build(BuildContext context) {
    // Menentukan data yang ditampilkan (TRUE)
    final dataTampil = hanyaAktif
        ? daftarRekomendasi.where((item) => item.status).toList()
        : daftarRekomendasi;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Rekomendasi'),
        actions: [
          // Tombol mengambil ulang data dari Supabase
          IconButton(
            tooltip: 'Refresh',
            onPressed: loading ? null : ambilRekomendasi,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // FORM TAMBAH DAN EDIT
            Text(
              idSedangEdit == null ? 'Tambah Rekomendasi' : 'Edit Rekomendasi',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            // Input ID destinasi yang sudah ada
            // Contoh dari database kamu: 11
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

            // Input urutan prioritas rekomendasi
            TextField(
              controller: prioritasInput,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Prioritas',
                hintText: 'Contoh: 1',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // Mengatur status aktif / nonaktif
            SwitchListTile(
              title: const Text('Status Aktif'),
              subtitle: const Text('Aktif = rekomendasi dapat ditampilkan'),
              value: statusAktif,
              onChanged: loading
                  ? null
                  : (value) {
                      setState(() {
                        statusAktif = value;
                      });
                    },
            ),

            const SizedBox(height: 12),

            // Tombol CREATE atau UPDATE
            ElevatedButton(
              onPressed: loading ? null : simpanRekomendasi,
              child: Text(
                idSedangEdit == null
                    ? 'TAMBAH REKOMENDASI'
                    : 'SIMPAN PERUBAHAN',
              ),
            ),

            // Tombol membatalkan mode edit
            if (idSedangEdit != null)
              TextButton(
                onPressed: loading ? null : bersihkanForm,
                child: const Text('BATAL EDIT'),
              ),

            const SizedBox(height: 12),

            // Pesan berhasil atau error
            if (pesan.isNotEmpty) Text(pesan),

            // Indikator saat proses database berlangsung
            if (loading) const LinearProgressIndicator(),

            const SizedBox(height: 24),

            // FILTER READ: SEMUA / AKTIF
            const Text(
              'Daftar Rekomendasi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => hanyaAktif = false);
                    },
                    child: const Text('LIHAT SEMUA'),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => hanyaAktif = true);
                    },
                    child: const Text('HANYA AKTIF'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // MENAMPILKAN DAFTAR REKOMENDASI
            if (dataTampil.isEmpty && !loading)
              const Text('Belum ada rekomendasi'),

            ...dataTampil.map((rekomendasi) {
              return Card(
                child: ListTile(
                  // Menampilkan foreign key destinasi
                  title: Text('Destinasi ID: ${rekomendasi.idDestinasi}'),

                  // Menampilkan prioritas dan status
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prioritas: ${rekomendasi.prioritas}\n'
                        'Status: ${rekomendasi.status ? "Aktif" : "Nonaktif"}',
                      ),
                      Text('Tanggal Ditambah: ${rekomendasi.tanggalDitambah}'),
                    ],
                  ),

                  // Tombol edit dan hapus
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol UPDATE
                      IconButton(
                        tooltip: 'Edit',
                        icon: const Icon(Icons.edit),
                        onPressed: loading
                            ? null
                            : () => mulaiEdit(rekomendasi),
                      ),

                      // Tombol DELETE
                      IconButton(
                        tooltip: 'Hapus',
                        icon: const Icon(Icons.delete),
                        onPressed: loading || rekomendasi.idRekomendasi == null
                            ? null
                            : () =>
                                  hapusRekomendasi(rekomendasi.idRekomendasi!),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
