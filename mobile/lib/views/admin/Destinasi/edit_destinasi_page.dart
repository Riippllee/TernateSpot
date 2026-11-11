import 'package:flutter/material.dart';
import 'package:ternatespot/controllers/destinasi_controller.dart';
import 'package:ternatespot/models/destinasi_model.dart';

import 'coordinate_map_picker.dart';

import 'package:latlong2/latlong.dart';

import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class EditDestinasiPage extends StatefulWidget {
  final DestinasiModel destinasi;

  const EditDestinasiPage({super.key, required this.destinasi});

  @override
  State<EditDestinasiPage> createState() => _EditDestinasiPageState();
}

class _EditDestinasiPageState extends State<EditDestinasiPage> {
  final DestinasiController _controller = DestinasiController();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _addressController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  int? _selectedCategoryId;
  bool _isPublicActive = true;

  final ImagePicker _picker = ImagePicker();

  Uint8List? _fotoBaruBytes;
  String? _fotoBaruName;

  late double _mapLatitude;
  late double _mapLongitude;

  final List<Uint8List> _fotoGaleriBaruBytes = [];
  final List<String> _fotoGaleriBaruNames = [];

  //fungsi pilih foto galeri
  Future<void> _pilihFotoGaleriBaru() async {
    try {
      final fotoDipilih = await _picker.pickMultiImage(imageQuality: 85);

      if (fotoDipilih.isEmpty) return;

      int dilewati = 0;

      for (final foto in fotoDipilih) {
        final ukuran = await foto.length();
        final ekstensi = foto.name.split('.').last.toLowerCase();

        if (ukuran > 5 * 1024 * 1024 ||
            !['jpg', 'jpeg', 'png'].contains(ekstensi)) {
          dilewati++;
          continue;
        }

        final bytes = await foto.readAsBytes();

        if (!mounted) return;

        _fotoGaleriBaruBytes.add(bytes);
        _fotoGaleriBaruNames.add(foto.name);
      }

      if (!mounted) return;

      setState(() {});

      if (dilewati > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$dilewati foto dilewati karena format atau ukuran tidak sesuai.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih foto galeri: $e')));
    }
  }

  //Fungsi pilih foto
  Future<void> _pilihFotoBaru() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (foto == null) return;

      final ukuran = await foto.length();

      if (ukuran > 5 * 1024 * 1024) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ukuran foto maksimal 5 MB.')),
        );
        return;
      }

      final ekstensi = foto.name.split('.').last.toLowerCase();

      if (!['jpg', 'jpeg', 'png'].contains(ekstensi)) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto harus berformat JPG atau PNG.')),
        );
        return;
      }

      final bytes = await foto.readAsBytes();

      if (!mounted) return;

      setState(() {
        _fotoBaruBytes = bytes;
        _fotoBaruName = foto.name;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memilih foto: $e')));
    }
  }

  // Memindahkan peta sesuai koordinat yang diketik admin.
  void _updateMapFromText() {
    final lat = double.tryParse(_latitudeController.text.trim());
    final lng = double.tryParse(_longitudeController.text.trim());

    if (lat == null || lng == null) return;

    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      return;
    }

    setState(() {
      _mapLatitude = lat;
      _mapLongitude = lng;
    });
  }

  // Mengisi koordinat ketika admin memilih titik pada peta.
  void _updateTextFromMap(LatLng point) {
    _latitudeController.text = point.latitude.toStringAsFixed(6);
    _longitudeController.text = point.longitude.toStringAsFixed(6);

    setState(() {
      _mapLatitude = point.latitude;
      _mapLongitude = point.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refreshPage);
    _controller.loadKategori();
    _controller.loadGaleri(widget.destinasi.idDestinasi);
    _mapLatitude = widget.destinasi.latitude;
    _mapLongitude = widget.destinasi.longitude;

    _selectedCategoryId = widget.destinasi.idKategori;
    _nameController = TextEditingController(
      text: widget.destinasi.namaDestinasi,
    );

    _descController = TextEditingController(text: widget.destinasi.deskripsi);

    _addressController = TextEditingController(text: widget.destinasi.alamat);

    _latitudeController = TextEditingController(
      text: widget.destinasi.latitude.toString(),
    );

    _longitudeController = TextEditingController(
      text: widget.destinasi.longitude.toString(),
    );

    _isPublicActive = widget.destinasi.status;
  }

  void _refreshPage() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _controller.removeListener(_refreshPage);
    _controller.dispose();
    super.dispose();
  }

  //hapus galeri

  Future<void> _hapusFotoGaleri(int idGaleri) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Foto Galeri?'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus foto ini dari galeri destinasi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    final berhasil = await _controller.hapusGaleri(
      idGaleri,
      widget.destinasi.idDestinasi,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          berhasil
              ? 'Foto galeri berhasil dihapus.'
              : (_controller.errorMessage ?? 'Gagal menghapus foto galeri.'),
        ),
      ),
    );
  }
  //simpan perubahan

  bool _isSaving = false;

  Future<void> _simpanPerubahan() async {
    final nama = _nameController.text.trim();
    final deskripsi = _descController.text.trim();
    final alamat = _addressController.text.trim();

    final latitude = double.tryParse(_latitudeController.text.trim());
    final longitude = double.tryParse(_longitudeController.text.trim());

    if (nama.isEmpty ||
        deskripsi.isEmpty ||
        alamat.isEmpty ||
        _selectedCategoryId == null ||
        latitude == null ||
        longitude == null ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi data dan masukkan koordinat yang valid.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final lama = widget.destinasi;

      // Gunakan URL foto lama secara default.
      String fotoUrl = lama.fotoUtama;
      // Jika admin memilih foto baru, upload ke Supabase Storage.
      if (_fotoBaruBytes != null) {
        final hasilUpload = await _controller.uploadGambar(_fotoBaruBytes!);

        if (!mounted) return;

        if (hasilUpload == null || hasilUpload.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _controller.errorMessage ?? 'Gagal mengunggah foto baru.',
              ),
            ),
          );
          return;
        }

        fotoUrl = hasilUpload;
      }

      final destinasiBaru = DestinasiModel(
        idDestinasi: lama.idDestinasi,
        idKategori: _selectedCategoryId!,
        namaDestinasi: nama,
        deskripsi: deskripsi,
        alamat: alamat,
        latitude: latitude,
        longitude: longitude,
        fotoUtama: fotoUrl,
        status: _isPublicActive,
        tanggalDaftar: lama.tanggalDaftar,
        tanggalPerubahan: DateTime.now(),
      );

      final berhasil = await _controller.updateDestinasi(
        lama.idDestinasi,
        destinasiBaru,
      );

      int galeriBerhasil = 0;
      int galeriGagal = 0;

      if (berhasil && _fotoGaleriBaruBytes.isNotEmpty) {
        for (final fotoBytes in _fotoGaleriBaruBytes) {
          try {
            // Upload gambar ke Supabase Storage.
            final urlGambar = await _controller.uploadGambar(fotoBytes);

            if (urlGambar == null || urlGambar.isEmpty) {
              galeriGagal++;
              continue;
            }

            // Simpan URL gambar ke tabel galeri_destinasi.
            final tersimpan = await _controller.tambahGaleriDenganUpload(
              lama.idDestinasi,
              urlGambar,
              '',
            );

            if (tersimpan) {
              galeriBerhasil++;
            } else {
              galeriGagal++;
            }
          } catch (e) {
            galeriGagal++;
            debugPrint('Gagal menyimpan foto galeri: $e');
          }
        }
      }
      if (!mounted) return;

      if (berhasil) {
        if (galeriGagal > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Perubahan destinasi tersimpan. '
                '$galeriBerhasil foto galeri berhasil, '
                '$galeriGagal foto gagal disimpan.',
              ),
            ),
          );

          await _controller.loadGaleri(lama.idDestinasi);
          return;
        }

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _controller.errorMessage ?? 'Gagal memperbarui destinasi.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan perubahan: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Material(
              color: const Color(0xFFF0F3F7),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black87,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          'Edit Destinasi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // CARD 1: FOTO UTAMA & GALERI PENDUKUNG
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDF2F7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.image_outlined,
                            color: Color(0xFF0066FF),
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'FOTO UTAMA DESTINASI',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(width: 2),
                          Text(
                            '*',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'JPG/PNG maks. 5MB',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Display Gambar Utama
                  Container(
                    height: 175,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: _fotoBaruBytes != null
                          ? DecorationImage(
                              image: MemoryImage(_fotoBaruBytes!),
                              fit: BoxFit.cover,
                            )
                          : widget.destinasi.fotoUtama.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(widget.destinasi.fotoUtama),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0066FF).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Foto Sampul Utama',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              size: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: _pilihFotoBaru,
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.camera_alt_rounded,
                                        size: 14,
                                        color: Color(0xFF0066FF),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Ganti Foto',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'sulamadaha_teluk_kaca.jpg',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 11,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 4,
                                        color: Colors.black54,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Foto Pendukung (Galeri Tambahan)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pilihFotoGaleriBaru,
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_controller.isLoadingGaleri)
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_controller.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              _controller.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        else if (_controller.listGaleri.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Belum ada foto galeri.',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 70,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _controller.listGaleri.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final galeri = _controller.listGaleri[index];

                                return _buildGalleryItem(
                                  galeri.urlGambar,
                                  galeri.idGaleri,
                                );
                              },
                            ),
                          ),

                        if (_fotoGaleriBaruBytes.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Foto baru (belum disimpan)',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 70,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _fotoGaleriBaruBytes.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    _fotoGaleriBaruBytes[index],
                                    width: 62,
                                    height: 62,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),

                        // Tombol upload sementara, belum diaktifkan.
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.grey, size: 18),
                              SizedBox(height: 2),
                              Text(
                                'Upload',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 2: INFORMASI UTAMA
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDF2F7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.info_rounded,
                        color: Color(0xFF0066FF),
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'INFORMASI UTAMA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Nama Destinasi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Nama Destinasi Wisata ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Wajib diisi',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      suffixIcon: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Kategori Wisata
                  Row(
                    children: const [
                      Text(
                        'Kategori Wisata ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  _controller.isLoadingKategori
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
                          key: ValueKey(_selectedCategoryId),
                          initialValue:
                              _controller.listKategori.any(
                                (kategori) =>
                                    kategori.idKategori == _selectedCategoryId,
                              )
                              ? _selectedCategoryId
                              : null,
                          hint: const Text('Pilih kategori wisata'),
                          items: _controller.listKategori.map((kategori) {
                            return DropdownMenuItem<int>(
                              value: kategori.idKategori,
                              child: Text(
                                kategori.namaKategori,
                                style: const TextStyle(fontSize: 13),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                  const SizedBox(height: 4),
                  const Text(
                    'Kategori membantu filter di aplikasi traveler.',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),

                  const SizedBox(height: 14),

                  // Status Publikasi
                  Row(
                    children: const [
                      Text(
                        'Status Publikasi ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPublicActive = true),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _isPublicActive
                                  ? const Color(0xFFE8F8F0)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isPublicActive
                                    ? const Color(0xFF2ECC71)
                                    : Colors.grey.shade200,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isPublicActive
                                        ? const Color(0xFF2ECC71)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: _isPublicActive
                                          ? const Color(0xFF2ECC71)
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  child: _isPublicActive
                                      ? const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Aktif / Publik',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Terlihat oleh wisatawan',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Color(0xFF27AE60),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isPublicActive = false),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: !_isPublicActive
                                  ? const Color(0xFFF1F5F9)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: !_isPublicActive
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade200,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Draft / Arsip',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Disembunyikan',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Deskripsi Destinasi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text(
                            'Deskripsi Destinasi ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'Maks. 1.200 karakter',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _descController,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 3: LOKASI & KOORDINAT PETA
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDF2F7)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.map_rounded,
                            color: Color(0xFF0066FF),
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'LOKASI & KOORDINAT PETA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF2FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'GPS Valid',
                          style: TextStyle(
                            color: Color(0xFF0066FF),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Alamat Lengkap
                  Row(
                    children: const [
                      Text(
                        'Alamat Lengkap ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _addressController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      suffixIcon: const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  CoordinateMapPicker(
                    latitude: _mapLatitude,
                    longitude: _mapLongitude,
                    onLocationChanged: _updateTextFromMap,
                  ),

                  const SizedBox(height: 14),

                  // Latitude & Longitude Inputs
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Latitude (Lintang)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _latitudeController,
                              onChanged: (_) => _updateMapFromText(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Longitude (Bujur)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _longitudeController,
                              onChanged: (_) => _updateMapFromText(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // CARD 4: RIWAYAT AUDIT SISTEM
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'RIWAYAT AUDIT SISTEM',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'ID Destinasi:',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '#DST-12',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Editor Terakhir (id_user):',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Admin_TernateSpot',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tanggal Daftar:',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '12 Jan 2024, 09:30',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Pembaruan Terakhir:',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Hari ini, 16:45 WIT',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TOMBOL HAPUS DESTINASI WISATA INI
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Hapus Destinasi Wisata Ini',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // BOTTOM BUTTONS: BATAL & SIMPAN PERUBAHAN
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _simpanPerubahan,
                      icon: const Icon(
                        Icons.save_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0066FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryItem(String url, int idGaleri) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            url,
            width: 62,
            height: 62,
            fit: BoxFit.cover,

            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;

              return Container(
                width: 62,
                height: 62,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              );
            },

            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 62,
                height: 62,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey.shade500,
                  size: 24,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () => _hapusFotoGaleri(idGaleri),
              child: const Icon(Icons.close, size: 10, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
