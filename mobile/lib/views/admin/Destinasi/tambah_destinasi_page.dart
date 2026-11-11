import 'package:flutter/material.dart';
import 'package:ternatespot/controllers/destinasi_controller.dart';
import 'package:ternatespot/models/destinasi_model.dart';

import 'coordinate_map_picker.dart';

import 'package:latlong2/latlong.dart';

import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class TambahDestinasiPage extends StatefulWidget {
  const TambahDestinasiPage({super.key});

  @override
  State<TambahDestinasiPage> createState() => _TambahDestinasiPageState();
}

class _TambahDestinasiPageState extends State<TambahDestinasiPage> {
  final DestinasiController _controller = DestinasiController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  Uint8List? _fotoUtamaBytes;
  String? _fotoUtamaName;

  final List<Uint8List> _fotoGaleriBytes = [];
  final List<String> _fotoGaleriNames = [];

  int? _selectedCategoryId;
  bool _isPublicActive = true;

  //pengaturan peta
  // Koordinat awal peta, berpusat di kawasan Ternate.
  double _mapLatitude = 0.7900;
  double _mapLongitude = 127.3800;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refreshPage);
    _controller.loadKategori();
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

  //konfigurasi peta
  // Memindahkan pin peta berdasarkan koordinat yang diketik.
  void _updateMapFromText() {
    final lat = double.tryParse(_latitudeController.text.trim());
    final lng = double.tryParse(_longitudeController.text.trim());

    if (lat == null || lng == null) return;
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return;

    setState(() {
      _mapLatitude = lat;
      _mapLongitude = lng;
    });
  }

  // Mengisi kolom koordinat ketika admin mengetuk peta.
  void _updateTextFromMap(LatLng point) {
    _latitudeController.text = point.latitude.toStringAsFixed(6);
    _longitudeController.text = point.longitude.toStringAsFixed(6);

    setState(() {
      _mapLatitude = point.latitude;
      _mapLongitude = point.longitude;
    });
  }

  //pilih foto galeri
  Future<void> _pilihFotoGaleri() async {
    try {
      final List<XFile> fotoDipilih = await _picker.pickMultiImage(
        imageQuality: 85,
      );

      if (fotoDipilih.isEmpty) return;

      for (final foto in fotoDipilih) {
        final ukuran = await foto.length();
        final ekstensi = foto.name.split('.').last.toLowerCase();

        if (ukuran > 5 * 1024 * 1024 ||
            !['jpg', 'jpeg', 'png'].contains(ekstensi)) {
          continue;
        }

        final bytes = await foto.readAsBytes();

        if (!mounted) return;

        _fotoGaleriBytes.add(bytes);
        _fotoGaleriNames.add(foto.name);
      }

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih foto galeri: $e')));
    }
  }

  //pilih foto
  Future<void> _pilihFotoUtama() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (foto == null) return;

      // Maksimal 5 MB.
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
        _fotoUtamaBytes = bytes;
        _fotoUtamaName = foto.name;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memilih foto: $e')));
    }
  }

  //simpan destinasi
  bool _isSaving = false;

  Future<void> _simpanDestinasi() async {
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
          content: Text(
            'Lengkapi semua data dan masukkan koordinat yang valid.',
          ),
        ),
      );
      return;
    }

    if (_fotoUtamaBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih foto utama destinasi terlebih dahulu.'),
        ),
      );
      return;
    }
    setState(() {
      _isSaving = true;
    });

    try {
      // Upload foto utama ke Supabase Storage.
      final String? fotoUrl = await _controller.uploadGambar(_fotoUtamaBytes!);

      if (!mounted) return;

      if (fotoUrl == null || fotoUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _controller.errorMessage ?? 'Gagal mengunggah foto utama.',
            ),
          ),
        );
        return;
      }
      final sekarang = DateTime.now();

      final destinasi = DestinasiModel(
        idDestinasi: 0,
        idKategori: _selectedCategoryId!,
        namaDestinasi: nama,
        deskripsi: deskripsi,
        alamat: alamat,
        latitude: latitude,
        longitude: longitude,
        fotoUtama: fotoUrl,
        status: _isPublicActive,
        tanggalDaftar: sekarang,
        tanggalPerubahan: sekarang,
      );

      final destinasiBaru = await _controller.tambahDestinasiDanAmbilData(
        destinasi,
      );

      final berhasil = destinasiBaru != null;
      if (destinasiBaru != null && _fotoGaleriBytes.isNotEmpty) {
        int berhasilUpload = 0;

        for (final fotoBytes in _fotoGaleriBytes) {
          final urlGambar = await _controller.uploadGambar(fotoBytes);

          if (urlGambar == null || urlGambar.isEmpty) {
            continue;
          }

          final tersimpan = await _controller.tambahGaleriDenganUpload(
            destinasiBaru.idDestinasi,
            urlGambar,
            '',
          );

          if (tersimpan) {
            berhasilUpload++;
          }
        }

        debugPrint(
          'Galeri berhasil disimpan: '
          '$berhasilUpload dari ${_fotoGaleriBytes.length} foto',
        );
      }

      if (!mounted) return;

      if (berhasil) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Destinasi berhasil ditambahkan.')),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _controller.errorMessage ?? 'Gagal menambahkan destinasi.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
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
          'Tambah Destinasi',
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
            // CARD 1: FOTO UTAMA & GALERI PENDUKUNG (KOSONG)
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

                  // Area Upload Foto Utama Kosong
                  InkWell(
                    onTap: _pilihFotoUtama,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      child: _fotoUtamaBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.memory(
                                _fotoUtamaBytes!,
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Color(0xFF0066FF),
                                  size: 30,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Pilih Foto Sampul Utama',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Klik untuk mengunggah gambar destinasi',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
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
                  if (_fotoGaleriBytes.isNotEmpty)
                    SizedBox(
                      height: 70,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _fotoGaleriBytes.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.memory(
                              _fotoGaleriBytes[index],
                              width: 62,
                              height: 62,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  InkWell(
                    onTap: _pilihFotoGaleri,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, color: Colors.grey, size: 18),
                          SizedBox(height: 2),
                          Text(
                            'Upload',
                            style: TextStyle(fontSize: 9, color: Colors.grey),
                          ),
                        ],
                      ),
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
                      hintText: 'Masukkan nama destinasi',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
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
                  DropdownButtonFormField<int>(
                    value: _selectedCategoryId,
                    hint: const Text(
                      'Pilih kategori wisata',
                      style: TextStyle(fontSize: 12),
                    ),
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

                  // Deskripsi
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
                      hintText: 'Tuliskan deskripsi lengkap destinasi...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
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
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Peta Lokasi',
                          style: TextStyle(
                            color: Colors.grey,
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
                      hintText:
                          'Masukkan alamat lengkap (Kelurahan, Kecamatan)...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      suffixIcon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
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

                  // Mini Map Preview
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Contoh: 0.866100',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Contoh: 127.329200',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
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

            const SizedBox(height: 24),

            // BOTTOM BUTTONS: BATAL & SIMPAN
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
                      onPressed: _isSaving ? null : _simpanDestinasi,
                      icon: const Icon(
                        Icons.add,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Simpan Destinasi',
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
}
