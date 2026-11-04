import 'package:flutter/material.dart';

/// Halaman Edit Destinasi (`EditDestinasiPage`)
class EditDestinasiPage extends StatefulWidget {
  const EditDestinasiPage({super.key});

  @override
  State<EditDestinasiPage> createState() => _EditDestinasiPageState();
}

class _EditDestinasiPageState extends State<EditDestinasiPage> {
  // Controller untuk Form Field
  final TextEditingController _namaController =
      TextEditingController(text: 'Pantai Sulamadaha');
  final TextEditingController _deskripsiController = TextEditingController(
    text:
        'Pantai Sulamadaha terkenal dengan julukan "Pantai Air Kaca" karena kejernihan air lautnya di Teluk Saomadoro. Pengunjung dapat menikmati sensasi menaiki kano transparan seolah melayang di atas air, snorkeling menikmati terumbu karang alami, serta...',
  );

  String _selectedKategori = 'Pantai';
  String _selectedStatus = 'Aktif / Publik';

  final List<String> _kategoriList = [
    'Pantai',
    'Gunung',
    'Sejarah',
    'Kuliner',
    'Budaya'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Destinasi',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // =================================================================
            // KARTU 1: FOTO UTAMA & GALERI PENDUKUNG
            // =================================================================
            _buildCardWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.image_outlined,
                              color: Color(0xFF2563EB), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'FOTO UTAMA DESTINASI',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          Text(' *',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Text(
                        'JPG/PNG maks. 5MB',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Area Foto Sampul Utama
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Image.asset(
                          'Asset/Image/Background.jpg',
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Foto Sampul Utama',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black.withOpacity(0.5),
                            child: const Icon(Icons.delete_outline,
                                color: Colors.white, size: 16),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.camera_alt_outlined,
                                    size: 14, color: Color(0xFF1E293B)),
                                label: const Text(
                                  'Ganti Foto',
                                  style: TextStyle(
                                      color: Color(0xFF1E293B),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'sulamadaha_teluk_kaca.jpg',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      color: Colors.black.withOpacity(0.5), // Sudah diperbaiki dari Colors.black50
                                    )
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

                  const Text(
                    'Foto Pendukung (Galeri Tambahan)',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      _buildGalleryThumbnail('Asset/Image/Background.jpg'),
                      const SizedBox(width: 8),
                      _buildGalleryThumbnail('Asset/Image/Background.jpg'),
                      const SizedBox(width: 8),
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Colors.blueAccent.withOpacity(0.5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, color: Colors.blueAccent, size: 20),
                            SizedBox(height: 2),
                            Text(
                              'Upload',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w500),
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

            // =================================================================
            // KARTU 2: INFORMASI UTAMA FORMULIR
            // =================================================================
            _buildCardWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.info_outline,
                          color: Color(0xFF2563EB), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'INFORMASI UTAMA',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  _buildFieldHeader('Nama Destinasi Wisata',
                      isRequired: true, extraText: 'Wajib diisi'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _namaController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      fillColor: const Color(0xFFF8FAFC),
                      filled: true,
                      suffixIcon: const Icon(Icons.edit,
                          size: 18, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildFieldHeader('Kategori Wisata', isRequired: true),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedKategori,
                    items: _kategoriList
                        .map((kategori) => DropdownMenuItem(
                              value: kategori,
                              child: Text(kategori),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedKategori = val);
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      fillColor: const Color(0xFFF8FAFC),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Kategori membantu filter di aplikasi traveler.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  _buildFieldHeader('Status Publikasi', isRequired: true),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(
                              () => _selectedStatus = 'Aktif / Publik'),
                          child: _buildStatusCard(
                            title: 'Aktif / Publik',
                            subtitle: 'Terlihat oleh wisatawan',
                            isSelected: _selectedStatus == 'Aktif / Publik',
                            selectedColor: const Color(0xFF10B981),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(
                              () => _selectedStatus = 'Draft / Arsip'),
                          child: _buildStatusCard(
                            title: 'Draft / Arsip',
                            subtitle: 'Disembunyikan',
                            isSelected: _selectedStatus == 'Draft / Arsip',
                            selectedColor: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildFieldHeader('Deskripsi Destinasi',
                      isRequired: true, extraText: 'Maks. 1.200 karakter'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _deskripsiController,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 13, height: 1.4),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      fillColor: const Color(0xFFF8FAFC),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
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

  // =========================================================================
  // HELPER WIDGETS
  // =========================================================================

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFieldHeader(String title,
      {bool isRequired = false, String extraText = ''}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155)),
            ),
            if (isRequired)
              const Text(' *',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
          ],
        ),
        if (extraText.isNotEmpty)
          Text(extraText,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildGalleryThumbnail(String imagePath) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              Image.asset(imagePath, width: 65, height: 65, fit: BoxFit.cover),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: CircleAvatar(
            radius: 9,
            backgroundColor: Colors.black.withOpacity(0.6),
            child: const Icon(Icons.close, color: Colors.white, size: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required Color selectedColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? selectedColor.withOpacity(0.08)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? selectedColor : const Color(0xFFE2E8F0),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? selectedColor : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? selectedColor : const Color(0xFF334155),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}