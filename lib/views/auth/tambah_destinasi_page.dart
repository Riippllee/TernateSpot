import 'dart:ui';
// Mengimpor fitur gambar tingkat rendah, termasuk Canvas, Path, dan Paint untuk membuat garis putus-putus.
import 'package:flutter/material.dart';
// Mengimpor komponen antarmuka Flutter seperti Scaffold, TextField, Icon, dan tombol.

class TambahDestinasiPage extends StatefulWidget {
// Membuat halaman tambah destinasi yang dapat memperbarui tampilannya saat state berubah.
  const TambahDestinasiPage({super.key});
  // Konstruktor halaman; key diteruskan ke kelas induk Flutter.

  @override
  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
  State<TambahDestinasiPage> createState() => _TambahDestinasiPageState();
  // Menghubungkan widget halaman dengan kelas yang menyimpan state dan logikanya.
}
// Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

class _TambahDestinasiPageState extends State<TambahDestinasiPage> {
// Menyimpan data formulir dan membangun tampilan halaman tambah destinasi.
  final TextEditingController _nameController = TextEditingController();
  // Mengontrol dan membaca teks yang dimasukkan pada kolom nama destinasi.
  final TextEditingController _locationController = TextEditingController();
  // Mengontrol dan membaca teks yang dimasukkan pada kolom lokasi.
  final TextEditingController _descController = TextEditingController();
  // Mengontrol dan membaca teks deskripsi destinasi.

  String? _selectedCategory = 'Pantai';
  // Menyimpan kategori yang dipilih; nilai awalnya adalah Pantai.
  final List<String> _categories = ['Pantai', 'Danau & Air', 'Sejarah & Benteng'];
  // Menyediakan daftar kategori yang dapat dipilih pada formulir.

  bool _hasSelectedImage = true;
  // Menandai apakah pratinjau foto sedang ditampilkan.
  final String _previewImageUrl =
  // Mendefinisikan alamat gambar yang dipakai sebagai pratinjau.
      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/newsOg_2024_6_9_1717902356726-iifq7h.jpeg';
      // URL gambar contoh yang dimuat dari internet.
  final String _fileName = 'foto_destinasi.jpg';
  // Menyimpan nama file foto yang ditampilkan pada pratinjau.

  @override
  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
  void dispose() {
  // Membersihkan resource controller saat halaman tidak lagi digunakan.
    _nameController.dispose();
    // Melepaskan resource controller nama agar tidak terjadi kebocoran memori.
    _locationController.dispose();
    // Melepaskan resource controller lokasi.
    _descController.dispose();
    // Melepaskan resource controller deskripsi.
    super.dispose();
    // Memanggil proses pembersihan dari kelas induk.
  }
  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

  @override
  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
  Widget build(BuildContext context) {
  // Membangun seluruh komponen visual halaman.
    return Scaffold(
    // Menyediakan struktur dasar halaman, termasuk AppBar dan body.
      backgroundColor: Colors.white,
      // Mengatur latar belakang halaman menjadi putih.
      appBar: AppBar(
      // Membuat bilah bagian atas halaman.
        backgroundColor: Colors.white,
        // Mengatur latar belakang halaman menjadi putih.
        elevation: 0,
        // Menghilangkan bayangan AppBar.
        leading: IconButton(
        // Membuat tombol ikon di sisi kiri AppBar.
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0066FF)),
          // Menampilkan ikon panah kembali berwarna biru.
          onPressed: () => Navigator.pop(context),
          // Membatalkan pengisian dan kembali ke halaman sebelumnya.
        ),
        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
        title: const Text(
        // Menampilkan judul halaman.
          'Tambah Destinasi',
          // Teks judul yang terlihat di AppBar.
          style: TextStyle(
          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
            color: Color(0xFF0B2545),
            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
            fontSize: 18,
            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
            fontWeight: FontWeight.bold,
            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
          ),
          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
        ),
        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
      ),
      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
      body: SafeArea(
      // Menjaga konten agar tidak tertutup area sistem seperti notch.
        child: SingleChildScrollView(
        // Membuat isi halaman dapat digulir jika lebih tinggi dari layar.
          padding: const EdgeInsets.all(20.0),
          // Memberi jarak 20 piksel pada semua sisi konten.
          child: Column(
          // Menyusun komponen formulir secara vertikal.
            crossAxisAlignment: CrossAxisAlignment.start,
            // Meratakan isi kolom ke sisi kiri.
            children: [
            // Menampung daftar widget anak.
              // 1. NAMA DESTINASI // Catatan bagian ini menjelaskan tujuan kelompok kode berikutnya.
              const Text(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                'Nama Destinasi',
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                style: TextStyle(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fontSize: 13,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fontWeight: FontWeight.bold,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  color: Color(0xFF0B2545),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              const SizedBox(height: 8),
              // Memberi jarak vertikal 8 piksel.
              TextField(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                controller: _nameController,
                // Menghubungkan kolom nama dengan controller nama.
                style: const TextStyle(fontSize: 13),
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                decoration: InputDecoration(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  hintText: 'Masukkan nama destinasi',
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey.shade400, size: 20),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  filled: true,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fillColor: const Color(0xFFFAFCFE),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  border: OutlineInputBorder(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderRadius: BorderRadius.circular(10),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  enabledBorder: OutlineInputBorder(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderRadius: BorderRadius.circular(10),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

              const SizedBox(height: 16),
              // Memberi jarak vertikal 16 piksel.

              // 2. KATEGORI // Catatan bagian ini menjelaskan tujuan kelompok kode berikutnya.
              const Text(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                'Kategori',
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                style: TextStyle(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fontSize: 13,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fontWeight: FontWeight.bold,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  color: Color(0xFF0B2545),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              const SizedBox(height: 8),
              // Memberi jarak vertikal 8 piksel.
              DropdownButtonFormField<String>(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                value: _selectedCategory,
                // Menampilkan kategori yang sedang dipilih pada dropdown.
                items: _categories
                // Menggunakan daftar kategori sebagai pilihan dropdown.
                    .map((cat) => DropdownMenuItem(
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          value: cat,
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          child: Text(cat, style: const TextStyle(fontSize: 13)),
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        ))
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    .toList(),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                onChanged: (val) {
                // Menjalankan fungsi ketika pengguna memilih kategori baru.
                  setState(() => _selectedCategory = val);
                  // Menyimpan kategori baru dan memperbarui tampilan.
                },
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                decoration: InputDecoration(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  hintText: 'Pilih kategori',
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  prefixIcon: Icon(Icons.label_outlined, color: Colors.grey.shade400, size: 20),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  filled: true,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fillColor: const Color(0xFFFAFCFE),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  border: OutlineInputBorder(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderRadius: BorderRadius.circular(10),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  enabledBorder: OutlineInputBorder(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderRadius: BorderRadius.circular(10),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              const SizedBox(height: 10),
              // Memberi jarak vertikal 10 piksel.

              // Chip Kategori Cepat
              Row(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                children: _categories.map((cat) {
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  final isSelected = _selectedCategory == cat;
                  // Memeriksa apakah kategori saat ini sedang dipilih.
                  return Padding(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    padding: const EdgeInsets.only(right: 8.0),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    child: GestureDetector(
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                      onTap: () {
                      // Menangani ketukan pengguna pada komponen.
                        setState(() => _selectedCategory = cat);
                        // Mengubah kategori aktif dan menyegarkan tampilan.
                      },
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                      child: Container(
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        decoration: BoxDecoration(
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          color: isSelected ? const Color(0xFF0066FF) : const Color(0xFFF1F5F9),
                          // Memberi warna biru pada kategori terpilih dan abu-abu muda pada lainnya.
                          borderRadius: BorderRadius.circular(20),
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          border: Border.all(
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            color: isSelected ? const Color(0xFF0066FF) : Colors.transparent,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          ),
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        child: Text(
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          cat,
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          style: TextStyle(
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            fontSize: 11,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                            // Mengatur warna teks sesuai status pemilihan kategori.
                          ),
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                      ),
                      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                    ),
                    // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  );
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                }).toList(),
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

              const SizedBox(height: 16),
              // Memberi jarak vertikal 16 piksel.

              // 3. LOKASI // Catatan bagian ini menjelaskan tujuan kelompok kode berikutnya.
              const Text(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                'Lokasi',
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                style: TextStyle(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fontSize: 13,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fontWeight: FontWeight.bold,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  color: Color(0xFF0B2545),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              const SizedBox(height: 8),
              // Memberi jarak vertikal 8 piksel.
              TextField(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                controller: _locationController,
                // Menghubungkan kolom lokasi dengan controller lokasi.
                style: const TextStyle(fontSize: 13),
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                decoration: InputDecoration(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  hintText: 'Contoh: Sulamadaha, Ternate Barat',
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  prefixIcon: Icon(Icons.location_on_outlined, color: Colors.grey.shade400, size: 20),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  filled: true,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fillColor: const Color(0xFFFAFCFE),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  border: OutlineInputBorder(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderRadius: BorderRadius.circular(10),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  enabledBorder: OutlineInputBorder(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderRadius: BorderRadius.circular(10),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

              const SizedBox(height: 18),
              // Memberi jarak vertikal 18 piksel.

              // 4. UPLOAD FOTO DESTINASI // Catatan bagian ini menjelaskan tujuan kelompok kode berikutnya.
              CustomPaint(
              // Menggambar dekorasi khusus di belakang area unggah foto.
                painter: DashedRectPainter(
                // Memakai painter khusus untuk menggambar bingkai putus-putus.
                  color: const Color(0xFFD0E1F9),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  strokeWidth: 1.2,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  gap: 5.0,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                child: Container(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  width: double.infinity,
                  // Membuat widget memenuhi lebar yang tersedia.
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  decoration: BoxDecoration(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    color: const Color(0xFFF4F8FF),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderRadius: BorderRadius.circular(12),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  child: Column(
                  // Menyusun komponen formulir secara vertikal.
                    children: [
                    // Menampung daftar widget anak.
                      const Icon(
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        Icons.image_rounded,
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        size: 42,
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        color: Color(0xFF0066FF),
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                      ),
                      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                      const SizedBox(height: 8),
                      // Memberi jarak vertikal 8 piksel.
                      const Text(
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        'Upload Foto Destinasi',
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        style: TextStyle(
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          fontSize: 14,
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          fontWeight: FontWeight.bold,
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          color: Color(0xFF0B2545),
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                      ),
                      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                      const SizedBox(height: 2),
                      // Memberi jarak vertikal 2 piksel.
                      const Text(
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        'Pilih gambar dari perangkat Anda',
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        style: TextStyle(fontSize: 11, color: Color(0xFF8A99AD)),
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                      ),
                      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                      const SizedBox(height: 12),
                      // Memberi jarak vertikal 12 piksel.
                      OutlinedButton.icon(
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        onPressed: () {
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          setState(() => _hasSelectedImage = true);
                          // Menampilkan pratinjau foto; ini belum membuka pemilih file perangkat.
                        },
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        icon: const Icon(Icons.image_outlined, size: 16, color: Color(0xFF0066FF)),
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        label: const Text(
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          'Pilih Gambar',
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          style: TextStyle(
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            fontSize: 12,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            fontWeight: FontWeight.bold,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            color: Color(0xFF0066FF),
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          ),
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        style: OutlinedButton.styleFrom(
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          backgroundColor: Colors.white,
                          // Mengatur latar belakang halaman menjadi putih.
                          side: const BorderSide(color: Color(0xFF0066FF)),
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          shape: RoundedRectangleBorder(
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            borderRadius: BorderRadius.circular(10),
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          ),
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                      ),
                      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                    ],
                    // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

              const SizedBox(height: 14),
              // Memberi jarak vertikal 14 piksel.

              // PRATINJAU FOTO CARD // Catatan bagian ini menjelaskan tujuan kelompok kode berikutnya.
              Container(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                width: double.infinity,
                // Membuat widget memenuhi lebar yang tersedia.
                padding: const EdgeInsets.all(12),
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                decoration: BoxDecoration(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  color: const Color(0xFFFAFCFE),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  borderRadius: BorderRadius.circular(12),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  border: Border.all(color: const Color(0xFFEDF2F7)),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                child: Align(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  alignment: Alignment.centerLeft,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  child: _hasSelectedImage
                  // Memilih tampilan pratinjau atau pesan belum ada foto berdasarkan state.
                      ? Column(
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Meratakan isi kolom ke sisi kiri.
                          children: [
                          // Menampung daftar widget anak.
                            Stack(
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                              children: [
                              // Menampung daftar widget anak.
                                ClipRRect(
                                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                  borderRadius: BorderRadius.circular(10),
                                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                  child: Image.network(
                                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                    _previewImageUrl,
                                    // Menggunakan URL gambar pratinjau yang sudah didefinisikan.
                                    width: 170,
                                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                    height: 95,
                                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                    fit: BoxFit.cover,
                                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                    errorBuilder: (context, error, stackTrace) => Container(
                                    // Menampilkan widget pengganti jika gambar gagal dimuat.
                                      width: 170,
                                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                      height: 95,
                                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                      color: Colors.grey.shade200,
                                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                      child: const Icon(Icons.image, color: Colors.grey),
                                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                    ),
                                    // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                                  ),
                                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                                ),
                                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                                Positioned(
                                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                  top: 6,
                                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                  right: 6,
                                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                  child: GestureDetector(
                                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                    onTap: () {
                                    // Menangani ketukan pengguna pada komponen.
                                      setState(() => _hasSelectedImage = false);
                                      // Menyembunyikan pratinjau foto ketika ikon hapus ditekan.
                                    },
                                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                    child: Container(
                                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                      width: 20,
                                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                      height: 20,
                                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                      decoration: const BoxDecoration(
                                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                        color: Colors.white,
                                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                        shape: BoxShape.circle,
                                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                      ),
                                      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                                      child: const Icon(
                                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                        Icons.cancel,
                                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                        color: Color(0xFFE53935),
                                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                        size: 18,
                                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                      ),
                                      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                                    ),
                                    // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                                  ),
                                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                                ),
                                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                              ],
                              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                            ),
                            // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                            const SizedBox(height: 6),
                            // Memberi jarak vertikal 6 piksel.
                            Text(
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                              _fileName,
                              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                              style: TextStyle(
                              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                fontSize: 10,
                                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                                color: Colors.grey.shade600,
                                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                              ),
                              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                            ),
                            // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                          ],
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        )
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                      : const Padding(
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          padding: EdgeInsets.symmetric(vertical: 20),
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          child: Center(
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            child: Text(
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                              'Belum ada foto yang dipilih',
                              // Pesan yang muncul jika tidak ada pratinjau foto.
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            ),
                            // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                          ),
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

              const SizedBox(height: 18),
              // Memberi jarak vertikal 18 piksel.

              // 5. DESKRIPSI DESTINASI // Catatan bagian ini menjelaskan tujuan kelompok kode berikutnya.
              const Text(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                'Deskripsi Destinasi',
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                style: TextStyle(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fontSize: 13,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fontWeight: FontWeight.bold,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  color: Color(0xFF0B2545),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              const SizedBox(height: 8),
              // Memberi jarak vertikal 8 piksel.
              TextField(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                controller: _descController,
                // Menghubungkan kolom deskripsi dengan controller deskripsi.
                maxLines: 4,
                // Menyediakan empat baris untuk memasukkan deskripsi.
                style: const TextStyle(fontSize: 12),
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                decoration: InputDecoration(
                // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  hintText: 'Tuliskan deskripsi singkat destinasi',
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  prefixIcon: Padding(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    padding: const EdgeInsets.only(bottom: 50),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    child: Icon(Icons.description_outlined, color: Colors.grey.shade400, size: 20),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  suffix: const Text(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    '0/500',
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  contentPadding: const EdgeInsets.all(12),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  filled: true,
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  fillColor: const Color(0xFFFAFCFE),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  border: OutlineInputBorder(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderRadius: BorderRadius.circular(10),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  enabledBorder: OutlineInputBorder(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderRadius: BorderRadius.circular(10),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    borderSide: BorderSide(color: Colors.grey.shade200),
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                ),
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

              const SizedBox(height: 24),
              // Memberi jarak vertikal 24 piksel sebelum tombol aksi.

              // 6. TOMBOL AKSI BATAL & SIMPAN DESTINASI // Catatan bagian ini menjelaskan tujuan kelompok kode berikutnya.
              Row(
              // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                children: [
                // Menampung daftar widget anak.
                  Expanded(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    child: SizedBox(
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                      height: 44,
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                      child: ElevatedButton.icon(
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        onPressed: () => Navigator.pop(context),
                        // Membatalkan pengisian dan kembali ke halaman sebelumnya.
                        icon: const Icon(Icons.close, size: 16, color: Colors.black87),
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        label: const Text(
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          'Batal',
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          style: TextStyle(
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            fontSize: 12,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            fontWeight: FontWeight.bold,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            color: Colors.black87,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          ),
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        style: ElevatedButton.styleFrom(
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          backgroundColor: const Color(0xFFE2E8F0),
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          elevation: 0,
                          // Menghilangkan bayangan AppBar.
                          shape: RoundedRectangleBorder(
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            borderRadius: BorderRadius.circular(10),
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          ),
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                      ),
                      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                    ),
                    // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  const SizedBox(width: 12),
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                  Expanded(
                  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                    child: SizedBox(
                    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                      height: 44,
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                      child: ElevatedButton.icon(
                      // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        onPressed: () {
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          Navigator.pop(context);
                          // Menutup halaman saat tombol simpan ditekan; data belum disimpan ke database.
                        },
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        icon: const Icon(Icons.save_rounded, size: 16, color: Colors.white),
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                        label: const Text(
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          'Simpan Destinasi',
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          style: TextStyle(
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            fontSize: 12,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            fontWeight: FontWeight.bold,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            color: Colors.white,
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          ),
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        style: ElevatedButton.styleFrom(
                        // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          backgroundColor: const Color(0xFF0066FF),
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          elevation: 0,
                          // Menghilangkan bayangan AppBar.
                          shape: RoundedRectangleBorder(
                          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                            borderRadius: BorderRadius.circular(10),
                            // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
                          ),
                          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                        ),
                        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                      ),
                      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                    ),
                    // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                  ),
                  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
                ],
                // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
              ),
              // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
            ],
            // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
          ),
          // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
        ),
        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
      ),
      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
    );
    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
  }
  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
}
// Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

// Custom Painter untuk Dashed Border // Catatan bagian ini menjelaskan tujuan kelompok kode berikutnya.
class DashedRectPainter extends CustomPainter {
// Membuat painter khusus untuk menggambar bingkai persegi panjang putus-putus.
  final Color color;
  // Menyimpan warna garis bingkai.
  final double strokeWidth;
  // Menyimpan ketebalan garis bingkai.
  final double gap;
  // Menyimpan panjang tiap segmen dan jarak pada garis putus-putus.

  DashedRectPainter({
  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
    required this.color,
    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
    this.strokeWidth = 1.0,
    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
    this.gap = 5.0,
    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
  });
  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

  @override
  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
  void paint(Canvas canvas, Size size) {
  // Menggambar dekorasi pada canvas dengan ukuran yang diberikan.
    final Paint paint = Paint()
    // Membuat objek Paint untuk menentukan gaya garis.
      ..color = color
      // Mengatur warna garis sesuai parameter.
      ..strokeWidth = strokeWidth
      // Mengatur ketebalan garis.
      ..style = PaintingStyle.stroke;
      // Menggambar garis tepi saja, bukan mengisi bentuk.

    final RRect rrect = RRect.fromRectAndRadius(
    // Membuat persegi panjang dengan sudut membulat.
      Rect.fromLTWH(0, 0, size.width, size.height),
      // Menentukan posisi dan ukuran persegi panjang berdasarkan ukuran canvas.
      const Radius.circular(12),
      // Membulatkan sudut bingkai dengan radius 12.
    );
    // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.

    final Path path = Path()..addRRect(rrect);
    // Membuat jalur gambar mengikuti bentuk persegi panjang membulat.

    for (final metric in path.computeMetrics()) {
    // Mengambil informasi panjang jalur untuk membaginya menjadi segmen.
      double distance = 0.0;
      // Memulai posisi gambar dari awal jalur.
      bool draw = true;
      // Menentukan apakah segmen saat ini digambar atau dilewati.
      while (distance < metric.length) {
      // Mengulang sampai seluruh panjang jalur diproses.
        if (draw) {
        // Menggambar segmen hanya ketika penanda draw bernilai true.
          canvas.drawPath(
          // Menggambar bagian jalur ke canvas.
            metric.extractPath(distance, distance + gap),
            // Mengambil segmen jalur dari posisi distance sepanjang gap.
            paint,
            // Menggunakan pengaturan warna dan ketebalan garis.
          );
          // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
        }
        // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
        distance += gap;
        // Memindahkan posisi ke segmen berikutnya.
        draw = !draw;
        // Bergantian antara menggambar segmen dan membuat celah.
      }
      // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
    }
    // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
  }
  // Menutup blok atau pemanggilan widget yang dibuka sebelumnya.

  @override
  // Mengatur properti atau bagian widget sesuai nama dan nilai pada baris ini.
  bool shouldRepaint(CustomPainter oldDelegate) => false;
  // Menyatakan painter tidak perlu menggambar ulang saat delegate tidak berubah.
}
// Menutup blok atau pemanggilan widget yang dibuka sebelumnya.
