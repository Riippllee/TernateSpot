import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/services/destinasi_service.dart';
import '/models/destinasi_model.dart';

class TestDestinasiWebPage extends StatefulWidget {
  const TestDestinasiWebPage({super.key});

  @override
  State<TestDestinasiWebPage> createState() => _TestDestinasiWebPageState();
}

class _TestDestinasiWebPageState extends State<TestDestinasiWebPage> {
  final DestinasiService _service = DestinasiService();
  final ImagePicker _picker = ImagePicker();

  List<DestinasiModel> _listDestinasi = [];

  Uint8List? _selectedImage;

  bool _isLoading = true;
  bool _isUploading = false;

  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final deskripsiController = TextEditingController();
  final latController = TextEditingController();
  final longController = TextEditingController();
  final kategoriController = TextEditingController(text: "1");

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getAllDestinasi();

      setState(() {
        _listDestinasi = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print(e);
    }
  }

  // ==============================
  // PILIH GAMBAR UNTUK WEB
  // ==============================

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        _selectedImage = bytes;
      });
    }
  }

  // ==============================
  // SIMPAN DATA
  // ==============================

  Future<void> _saveData() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih gambar terlebih dahulu")),
      );

      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload gambar
      final url = await _service.uploadGambar(
        _selectedImage!,
        "foto-destinasi",
      );

      final destinasi = DestinasiModel(
        idDestinasi: 0,

        idKategori: int.parse(kategoriController.text),

        namaDestinasi: namaController.text,

        deskripsi: deskripsiController.text,

        alamat: alamatController.text,

        latitude: double.parse(latController.text),

        longitude: double.parse(longController.text),

        fotoUtama: url,

        status: true,

        tanggalDaftar: DateTime.now(),

        tanggalPerubahan: DateTime.now(),
      );

      await _service.tambahDestinasi(destinasi);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Destinasi berhasil ditambahkan")),
      );

      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error : $e")));
    }

    setState(() {
      _isUploading = false;
    });
  }

  void _showForm() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Destinasi"),

          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama Destinasi",
                  ),
                ),

                TextField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: "Alamat"),
                ),

                TextField(
                  controller: deskripsiController,
                  decoration: const InputDecoration(labelText: "Deskripsi"),
                ),

                TextField(
                  controller: latController,
                  decoration: const InputDecoration(labelText: "Latitude"),
                ),

                TextField(
                  controller: longController,
                  decoration: const InputDecoration(labelText: "Longitude"),
                ),

                TextField(
                  controller: kategoriController,
                  decoration: const InputDecoration(labelText: "ID Kategori"),
                ),

                const SizedBox(height: 15),

                _selectedImage == null
                    ? const Text("Belum ada gambar")
                    : Image.memory(_selectedImage!, height: 120),

                ElevatedButton(
                  onPressed: _pickImage,

                  child: const Text("Pilih Gambar"),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),

              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: _isUploading ? null : _saveData,

              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Destinasi Web")),

      floatingActionButton: FloatingActionButton(
        onPressed: _showForm,

        child: const Icon(Icons.add),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _listDestinasi.length,

              itemBuilder: (context, index) {
                final item = _listDestinasi[index];

                return Card(
                  child: ListTile(
                    leading: Image.network(
                      item.fotoUtama,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),

                    title: Text(item.namaDestinasi),

                    subtitle: Text(item.alamat),
                  ),
                );
              },
            ),
    );
  }
}
