import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/destinasi_controller.dart';
import '../../models/destinasi_model.dart';
import '../../models/kategori_model.dart';

class DestinasiListPage extends StatefulWidget {
  const DestinasiListPage({Key? key}) : super(key: key);

  @override
  State<DestinasiListPage> createState() => _DestinasiListPageState();
}

class _DestinasiListPageState extends State<DestinasiListPage> {
  final DestinasiController _controller = DestinasiController();
  final ImagePicker _picker = ImagePicker();
  
  List<DestinasiModel> _listDestinasi = [];
  List<KategoriModel> _listKategori = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  Uint8List? _selectedImageBytes; 
  bool _isUploading = false;

  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();
  final _kategoriIdController = TextEditingController(text: '1');
  final _kategoriNamaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _deskripsiController.dispose();
    _latController.dispose();
    _longController.dispose();
    _kategoriIdController.dispose();
    _kategoriNamaController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final destinasi = await _controller.getDestinasi();
      final kategori = await _controller.getKategori();
      setState(() {
        _listDestinasi = destinasi;
        _listKategori = kategori;
        _isLoading = false;
        if (_listKategori.isNotEmpty) {
          _kategoriIdController.text = _listKategori.first.idKategori.toString();
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print(e);
    }
  }

  void _showTambahKategoriDialog() {
    _kategoriNamaController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Kategori Baru'),
        content: TextField(
          controller: _kategoriNamaController,
          decoration: const InputDecoration(labelText: 'Nama Kategori (misal: Pantai)', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (_kategoriNamaController.text.isNotEmpty) {
                try {
                  await _controller.tambahKategori(_kategoriNamaController.text);
                  if (mounted) Navigator.pop(context);
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kategori berhasil ditambahkan!')));
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
                  }
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  Future<void> _uploadAndSave() async {
    if (_selectedImageBytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih gambar dulu!')));
      }
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload gambar
      await _controller.uploadGambar(_selectedImageBytes!, 'foto-destinasi');
      
      final safeKategoriId = int.tryParse(_kategoriIdController.text) ?? 1;
      final safeLat = double.tryParse(_latController.text) ?? 0.0;
      final safeLong = double.tryParse(_longController.text) ?? 0.0;

      final success = await _controller.tambahDestinasiLengkap(
        idKategori: safeKategoriId,
        nama: _namaController.text,
        deskripsi: _deskripsiController.text,
        alamat: _alamatController.text,
        latitude: safeLat,
        longitude: safeLong,
        fotoBytes: _selectedImageBytes!,
      );
      
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil ditambahkan!')));
        }
        _resetForm();
        if (mounted) Navigator.pop(context); 
        _loadData(); 
      } else {
        throw Exception('Gagal menyimpan ke database.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isUploading = false);
    }

    setState(() {
      _isUploading = false;
    });
  }

  void _resetForm() {
    _namaController.clear();
    _alamatController.clear();
    _deskripsiController.clear();
    _latController.clear();
    _longController.clear();
    setState(() => _selectedImageBytes = null);
  }

  Future<void> _hapusDestinasi(int id) async {
    try {
      await _controller.hapusDestinasi(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil dihapus!')));
      }
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal hapus: $e')));
      }
    }
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Tambah Destinasi Baru'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: _namaController, decoration: const InputDecoration(labelText: 'Nama Destinasi *', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  TextField(controller: _alamatController, decoration: const InputDecoration(labelText: 'Alamat *', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  TextField(controller: _deskripsiController, decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder()), maxLines: 2),
                  const SizedBox(height: 8),
                  TextField(controller: _latController, decoration: const InputDecoration(labelText: 'Latitude (pakai titik)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  TextField(controller: _longController, decoration: const InputDecoration(labelText: 'Longitude (pakai titik)', border: OutlineInputBorder()), keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _kategoriIdController, 
                    decoration: InputDecoration(
                      labelText: 'ID Kategori *', 
                      border: const OutlineInputBorder(),
                      helperText: _listKategori.isNotEmpty 
                          ? 'Tersedia: ${_listKategori.map((k) => '${k.idKategori}=${k.namaKategori}').join(', ')}' 
                          : '⚠️ Tambah kategori dulu via tombol di atas!',
                    ), 
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  
                  _selectedImageBytes == null
                      ? const Text('Belum ada gambar dipilih', style: TextStyle(color: Colors.grey))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(_selectedImageBytes!, height: 100, width: double.infinity, fit: BoxFit.cover),
                        ),
                  const SizedBox(height: 8),
                  
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pilih Gambar'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
              _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(onPressed: _uploadAndSave, child: const Text('Simpan')),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Test (Web Ready)'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: _showTambahKategoriDialog,
            tooltip: 'Tambah Kategori',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : _listDestinasi.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada destinasi.\n1. Tambah Kategori di atas.\n2. Tambah Destinasi di bawah.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _listDestinasi.length,
                      itemBuilder: (context, index) {
                        final item = _listDestinasi[index];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.fotoUtama, 
                                width: 60, 
                                height: 60, 
                                fit: BoxFit.cover, 
                                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                              ),
                            ),
                            title: Text(item.namaDestinasi, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${item.alamat}\nKategori ID: ${item.idKategori}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Hapus Destinasi?'),
                                    content: Text('Yakin ingin menghapus ${item.namaDestinasi}?'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context, true), 
                                        child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) _hapusDestinasi(item.idDestinasi);
                              },
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }
}