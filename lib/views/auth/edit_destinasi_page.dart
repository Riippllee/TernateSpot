import 'package:flutter/material.dart';

class EditDestinasiPage extends StatefulWidget {
  final String destinationTitle;

  const EditDestinasiPage({
    super.key,
    this.destinationTitle = 'Pantai Sulamadaha',
  });

  @override
  State<EditDestinasiPage> createState() => _EditDestinasiPageState();
}

class _EditDestinasiPageState extends State<EditDestinasiPage> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  String _selectedCategory = 'Pantai';
  bool _isPublicActive = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.destinationTitle);
    _descController = TextEditingController(
      text:
          'Pantai Sulamadaha terkenal dengan julukan "Pantai Air Kaca" karena kejernihan air lautnya di Teluk Saomadoro. Pengunjung dapat menikmati sensasi menaiki kano transparan seolah melayang di atas air, snorkeling menikmati terumbu karang alami, serta',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
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
                  // Label Foto Utama
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.image_outlined,
                              color: Color(0xFF0066FF), size: 18),
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

                  // Display Gambar Utama Sampul
                  Container(
                    height: 175,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/Pantai.jpeg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Badge Foto Sampul Utama
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
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

                        // Tombol Hapus Sampul (Pojok Kanan Atas)
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

                        // Tombol Ganti Foto & Nama File (Bawah)
                        Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.camera_alt_rounded,
                                        size: 14, color: Color(0xFF0066FF)),
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

                  // Foto Pendukung (Galeri Tambahan)
                  const Text(
                    'Foto Pendukung (Galeri Tambahan)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _buildGalleryItem(
                        'https://indotimur.com/images/nits/2023/08/preview_brtcc0hw_gzrlhpmv.jpg',
                      ),
                      const SizedBox(width: 8),
                      _buildGalleryItem(
                        'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/newsOg_2024_6_9_1717902356726-iifq7h.jpeg',
                      ),
                      const SizedBox(width: 8),

                      // Tombol Upload (Border Putus-putus)
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, color: Colors.grey, size: 18),
                            SizedBox(height: 2),
                            Text(
                              'Upload',
                              style:
                                  TextStyle(fontSize: 9, color: Colors.grey),
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
                  // Label Header Informasi Utama
                  Row(
                    children: const [
                      Icon(Icons.info_rounded,
                          color: Color(0xFF0066FF), size: 18),
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

                  // Input 1: Nama Destinasi Wisata
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
                        fontSize: 13, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      suffixIcon: const Icon(Icons.edit_outlined,
                          size: 16, color: Colors.grey),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
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

                  // Input 2: Kategori Wisata
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
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    items: ['Pantai', 'Danau & Air', 'Sejarah & Benteng']
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedCategory = val);
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
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
                  const SizedBox(height: 4),
                  const Text(
                    'Kategori membantu filter di aplikasi traveler.',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),

                  const SizedBox(height: 14),

                  // Input 3: Status Publikasi
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
                      // Opsi 1: Aktif / Publik
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
                                      ? const Icon(Icons.check,
                                          size: 12, color: Colors.white)
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

                      // Opsi 2: Draft / Arsip
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

                  // Input 4: Deskripsi Destinasi
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
                    maxLines: 5,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black87, height: 1.4),
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
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Item Galeri Pendukung
  Widget _buildGalleryItem(String url) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            url,
            width: 62,
            height: 62,
            fit: BoxFit.cover,
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
            child: const Icon(
              Icons.close,
              size: 10,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}