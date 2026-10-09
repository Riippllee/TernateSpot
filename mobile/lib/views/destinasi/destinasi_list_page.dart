  import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/services/destinasi_service.dart'; // Panggil Service langsung
import '/models/destinasi_model.dart';

class TestDestinasiPage extends StatefulWidget {
  @override
  _TestDestinasiPageState createState() => _TestDestinasiPageState();
}

class _TestDestinasiPageState extends State<TestDestinasiPage> {
  final DestinasiService _service = DestinasiService();
  final ImagePicker _picker = ImagePicker();
  
  // State Variables (Ini yang akan di-update pakai setState)
  List<DestinasiModel> _listDestinasi = [];
  bool _isLoading = true;
  String? _errorMessage;
  File? _selectedImage;
  bool _isUploading = false;

  // Controller untuk Form Input
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  final _kategoriIdController = TextEditingController(text: '1'); 

  @override
  void initState() {
    super.initState();
    _loadDestinasi(); // Load data saat halaman pertama kali dibuka
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _deskripsiController.dispose();
    _latController.dispose();
    _longController.dispose();
    _kategoriIdController.dispose();
    super.dispose();
  }

  // Fungsi Load Data (Read)
  Future<void> _loadDestinasi() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _service.getAllDestinasi();
      setState(() {
        _listDestinasi = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  // Fungsi Pilih Gambar
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Fungsi Upload & Simpan (Create)
  Future<void> _uploadAndSave() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pilih gambar dulu!')));
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 1. Upload Gambar
      final url = await _service.uploadGambar(_selectedImage!, 'foto-destinasi');
      
      // 2. Buat Model
      final destinasi = DestinasiModel(
        idDestinasi: 0, 
        idKategori: int.parse(_kategoriIdController.text),
        namaDestinasi: _namaController.text,
        deskripsi: _deskripsiController.text,
        alamat: _alamatController.text,
        latitude: double.parse(_latController.text),
        longitude: double.parse(_longController.text),
        fotoUtama: url,
        status: true,
        tanggalDaftar: DateTime.now(),
        tanggalPerubahan: DateTime.now(),
      );

      // 3. Simpan ke Database
      await _service.tambahDestinasi(destinasi);
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil ditambahkan!')));
      _resetForm();
      Navigator.pop(context); 
      _loadDestinasi(); // Refresh list
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isUploading = false);
    }
  }

  void _resetForm() {
    _namaController.clear();
    _alamatController.clear();
    _deskripsiController.clear();
    _latController.clear();
    _longController.clear();
    setState(() => _selectedImage = null);
  }

  // Fungsi Hapus (Delete)
  Future<void> _hapusDestinasi(int id) async {
    try {
      await _service.hapusDestinasi(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Berhasil dihapus!')));
      _loadDestinasi(); // Refresh list setelah hapus
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal hapus: $e')));
    }
  }

  // Tampilkan Dialog Form Tambah
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tambah Destinasi Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _namaController, decoration: InputDecoration(labelText: 'Nama Destinasi')),
              TextField(controller: _alamatController, decoration: InputDecoration(labelText: 'Alamat')),
              TextField(controller: _deskripsiController, decoration: InputDecoration(labelText: 'Deskripsi'), maxLines: 3),
              TextField(controller: _latController, decoration: InputDecoration(labelText: 'Latitude'), keyboardType: TextInputType.number),
              TextField(controller: _longController, decoration: InputDecoration(labelText: 'Longitude'), keyboardType: TextInputType.number),
              TextField(controller: _kategoriIdController, decoration: InputDecoration(labelText: 'ID Kategori (misal: 1)'), keyboardType: TextInputType.number),
              SizedBox(height: 10),
              _selectedImage == null
                  ? Text('Belum ada gambar dipilih')
                  : Image.file(_selectedImage!, height: 100),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Pilih Gambar'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Batal')),
          _isUploading
              ? CircularProgressIndicator()
              : ElevatedButton(onPressed: _uploadAndSave, child: Text('Simpan')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test UI Destinasi (setState)')),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  // Widget Builder untuk Body (Pengganti Consumer)
  Widget _buildBody() {
    // 1. Cek Loading
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // 2. Cek Error
    if (_errorMessage != null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_errorMessage!, textAlign: TextAlign.center, style: TextStyle(color: Colors.red)),
      ));
    }

    // 3. Cek Data Kosong
    if (_listDestinasi.isEmpty) {
      return Center(child: Text('Belum ada destinasi. Klik tombol + untuk menambah.'));
    }

    // 4. Tampilkan List
    return ListView.builder(
      itemCount: _listDestinasi.length,
      itemBuilder: (context, index) {
        final item = _listDestinasi[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Image.network(item.fotoUtama, width: 50, height: 50, fit: BoxFit.cover, 
              errorBuilder: (_, __, ___) => Icon(Icons.broken_image)),
            title: Text(item.namaDestinasi, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.alamat),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Hapus Destinasi?'),
                    content: Text('Yakin ingin menghapus ${item.namaDestinasi}?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Batal')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Hapus', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirm == true) {
                  _hapusDestinasi(item.idDestinasi);
                }
              },
            ),
          ),
        );
      },
    );
  }
}