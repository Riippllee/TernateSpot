// Mengimpor komponen Material Design Flutter, seperti Scaffold, AppBar, TextField, dan Icon.
import 'package:flutter/material.dart';

// Widget halaman untuk mengedit informasi destinasi. StatefulWidget dipakai karena isi form dapat berubah.
class EditDestinasiPage extends StatefulWidget {
  // Menyimpan judul destinasi yang dikirim dari halaman sebelumnya; nilainya tidak dapat diubah.
  final String destinationTitle;

  // Konstruktor halaman; menerima judul destinasi secara opsional.
  const EditDestinasiPage({
    // Key membantu Flutter mengenali widget saat susunan widget berubah.
    super.key,
    // Jika judul tidak dikirim, gunakan Pantai Sulamadaha sebagai nilai bawaan.
    this.destinationTitle = 'Pantai Sulamadaha',
  });

  @override
  // Menghubungkan widget ini dengan objek State yang mengelola data dan tampilan dinamis.
  State<EditDestinasiPage> createState() => _EditDestinasiPageState();
}

// State halaman: menyimpan nilai input dan status pilihan yang bisa berubah.
class _EditDestinasiPageState extends State<EditDestinasiPage> {
  // Controller untuk membaca dan mengatur teks pada kolom nama destinasi.
  late TextEditingController _nameController;
  // Controller untuk membaca dan mengatur teks pada kolom deskripsi.
  late TextEditingController _descController;
  // Kategori yang sedang dipilih; nilai awalnya adalah Pantai.
  String _selectedCategory = 'Pantai';
  // true berarti destinasi aktif/publik, false berarti draft/arsip.
  bool _isPublicActive = true;

  @override
  // Dipanggil saat State pertama kali dibuat untuk menyiapkan nilai awal form.
  void initState() {
    // Menjalankan proses inisialisasi milik kelas induk.
    super.initState();
    // Mengisi kolom nama menggunakan judul yang diterima oleh widget.
    _nameController = TextEditingController(text: widget.destinationTitle);
    // Membuat controller deskripsi dan mengisi teks deskripsi awal.
    _descController = TextEditingController(
      text:
          'Pantai Sulamadaha terkenal dengan julukan "Pantai Air Kaca" karena kejernihan air lautnya di Teluk Saomadoro. Pengunjung dapat menikmati sensasi menaiki kano transparan seolah melayang di atas air, snorkeling menikmati terumbu karang alami, serta',
    );
  }

  @override
  // Dipanggil ketika halaman dilepas; resource controller harus dibersihkan.
  void dispose() {
    // Melepaskan resource controller nama agar tidak terjadi kebocoran memori.
    _nameController.dispose();
    // Melepaskan resource controller deskripsi.
    _descController.dispose();
    // Menyelesaikan proses pembersihan dari kelas induk.
    super.dispose();
  }

  @override
  // Menyusun seluruh tampilan halaman berdasarkan state saat ini.
  Widget build(BuildContext context) {
    // Scaffold menyediakan kerangka dasar halaman: app bar dan area isi.
    // Kerangka halaman yang berisi AppBar dan konten utama.
    return Scaffold(
      // Memberi warna latar abu-abu kebiruan yang lembut pada halaman.
      backgroundColor: const Color(0xFFF4F7FA),
      // Membuat bilah atas halaman.
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
                // Menutup halaman edit dan kembali ke halaman sebelumnya saat tombol ditekan.
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
          // Judul yang ditampilkan pada AppBar.
          'Edit Destinasi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // Membuat isi halaman dapat digulir jika kontennya melebihi tinggi layar.
      body: SingleChildScrollView(
        // Memberi jarak 16 piksel di sekeliling konten.
        padding: const EdgeInsets.all(16.0),
        // Menyusun kartu-kartu form secara vertikal dari atas ke bawah.
        child: Column(
          children: [
            // Kartu pertama menampilkan foto sampul destinasi dan galeri foto pendukung.
            // CARD 1: FOTO UTAMA & GALERI PENDUKUNG
            // Container membungkus bagian UI agar mudah diberi padding dan dekorasi.
            Container(
              padding: const EdgeInsets.all(16),
              // Mengatur tampilan kotak, termasuk warna, sudut membulat, dan garis tepi.
              decoration: BoxDecoration(
                // Memberi latar putih pada kartu.
                color: Colors.white,
                // Membulatkan sudut kartu sebesar 16 piksel.
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDF2F7)),
              ),
              // Menata isi kartu secara vertikal.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris judul bagian foto utama dan informasi batas format/ukuran file.
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
                            // Label untuk menandai bagian foto sampul destinasi.
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

                  // Menampilkan foto sampul yang saat ini digunakan.
                  // Display Gambar Utama Sampul
                  Container(
                    height: 175,
                    width: double.infinity,
                    // Mengatur latar gambar dan bentuk kotak foto.
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/Pantai.jpeg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Stack memungkinkan label dan tombol ditumpuk di atas gambar.
                    child: Stack(
                      children: [
                        // Label kecil yang diletakkan di atas foto sebagai penanda foto sampul.
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

                        // Ikon hapus dekoratif yang ditempatkan di sudut kanan atas foto.
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

                        // Menampilkan label Ganti Foto dan nama file di bagian bawah foto.
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

                  // Bagian galeri berisi beberapa foto pendukung destinasi.
                  // Foto Pendukung (Galeri Tambahan)
                  const Text(
                    // Judul bagian galeri foto tambahan.
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

                      // Kotak ajakan untuk menambahkan foto ke galeri; pada kode ini masih berupa tampilan UI.
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
                              // Teks pada kotak untuk menambahkan foto.
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

            // Kartu kedua berisi kolom nama, kategori, status publikasi, dan deskripsi.
            // CARD 2: INFORMASI UTAMA
            // Container membungkus bagian UI agar mudah diberi padding dan dekorasi.
            Container(
              padding: const EdgeInsets.all(16),
              // Mengatur tampilan kotak, termasuk warna, sudut membulat, dan garis tepi.
              decoration: BoxDecoration(
                // Memberi latar putih pada kartu.
                color: Colors.white,
                // Membulatkan sudut kartu sebesar 16 piksel.
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEDF2F7)),
              ),
              // Menata isi kartu secara vertikal.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header yang menandai bagian informasi destinasi.
                  // Label Header Informasi Utama
                  Row(
                    children: const [
                      Icon(Icons.info_rounded,
                          color: Color(0xFF0066FF), size: 18),
                      SizedBox(width: 6),
                      Text(
                        // Judul bagian informasi utama.
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

                  // Label dan kolom teks untuk nama destinasi wisata.
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
                    // Mengatur tampilan kolom input, seperti warna latar, ikon, dan border.
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

                  // Label dan dropdown untuk memilih kategori destinasi.
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
                    // Daftar pilihan kategori yang tersedia di dropdown.
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
                    // Callback yang dijalankan saat pengguna memilih kategori lain.
                    onChanged: (val) {
                      if (val != null) {
                        // Memperbarui kategori dan meminta Flutter membangun ulang tampilan.
                        setState(() => _selectedCategory = val);
                      }
                    },
                    // Mengatur tampilan kolom input, seperti warna latar, ikon, dan border.
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

                  // Menyediakan pilihan untuk menampilkan destinasi ke publik atau menyimpannya sebagai draft.
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
                      // Kartu pilihan pertama; destinasi akan ditandai aktif/publik.
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

                      // Kartu pilihan kedua; destinasi ditandai draft/arsip dan disembunyikan.
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

                  // Label dan kolom teks panjang untuk menjelaskan destinasi wisata.
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
                    // Mengatur tampilan kolom input, seperti warna latar, ikon, dan border.
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

// Fungsi pembantu agar setiap foto galeri dibuat dengan tampilan yang sama.
  // Widget Pembantu untuk Item Galeri Pendukung
  // Menerima URL gambar dan mengembalikan widget thumbnail galeri.
  Widget _buildGalleryItem(String url) {
    // Menumpuk gambar dan ikon tutup di atas satu sama lain.
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          // Memuat gambar dari alamat URL internet.
          child: Image.network(
            url,
            width: 62,
            height: 62,
            // Memenuhi kotak thumbnail tanpa mengubah rasio gambar.
            fit: BoxFit.cover,
          ),
        ),
        // Menempatkan ikon secara absolut pada posisi tertentu di atas gambar.
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
