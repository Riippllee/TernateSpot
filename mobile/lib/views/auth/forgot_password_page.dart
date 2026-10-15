import 'package:flutter/material.dart';

/// Class [ForgotPasswordPage] merupakan StatefulWidget untuk menampilkan halaman Lupa Kata Sandi.
/// Menggunakan StatefulWidget karena memiliki state lokal yaitu [TextEditingController] 
/// untuk menangani input dari pengguna secara dinamis.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Controller untuk mengambil teks yang diketik pengguna pada kolom Email/No. Handphone
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    // Membebaskan memori controller saat halaman dihancurkan (mencegah memory leak)
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang utama halaman berwarna putih
      
      // =======================================================================
      // BAGIAN APPBAR (HEADER ATAS)
      // =======================================================================
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 238, 238), // Warna latar header
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
        
        // Tombol kembali (Back Button) di sebelah kiri atas
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context), // Kembali ke halaman sebelumnya (Login)
        ),
        
        // Judul halaman di bagian tengah
        title: const Text(
          'Lupa Kata Sandi',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // =======================================================================
      // BAGIAN BODY (KONTEN UTAMA HALAMAN)
      // =======================================================================
      body: SafeArea(
        // SafeArea memastikan konten tidak tertutup notch atau status bar HP
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Margin/jarak di sekeliling konten
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat elemen memenuhi lebar halaman
            children: [
              const SizedBox(height: 12),

              // ---------------------------------------------------------------
              // 1. IKON LOKASI LUPA SANDI (Ikon Gembok di Dalam Lingkaran Biru Muda)
              // ---------------------------------------------------------------
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEBF2FF), // Warna latar lingkaran biru muda
                    shape: BoxShape.circle,    // Bentuk container lingkaran
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded, // Ikon gembok atur ulang kata sandi
                    size: 48,
                    color: Color(0xFF0066FF), // Warna ikon biru utama
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ---------------------------------------------------------------
              // 2. JUDUL TEKS & DESKRIPSI INSTRUKSI
              // ---------------------------------------------------------------
              const Text(
                'Atur Ulang Kata Sandi',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masukkan email atau nomor handphone terdaftar kamu. Kami akan mengirimkan kode/tautan untuk mengatur ulang kata sandi.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 32),

              // ---------------------------------------------------------------
              // 3. LABEL & KOLOM INPUT (TextField Email / No. Handphone)
              // ---------------------------------------------------------------
              const Text(
                'Email atau No. Handphone',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              
              TextField(
                controller: _inputController, // Menghubungkan input teks dengan controller
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'nama@email.com atau 0812...', // Teks petunjuk sebelum diketik
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  prefixIcon: const Icon(
                    Icons.contact_mail_outlined, // Ikon di dalam sebelah kiri kolom input
                    color: Colors.grey,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50, // Warna latar kolom input
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  
                  // Desain bingkai (border) kolom input saat diam
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  
                  // Desain bingkai saat kolom aktif/diisi
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ---------------------------------------------------------------
              // 4. TOMBOL "KIRIM TAUTAN ATUR ULANG"
              // ---------------------------------------------------------------
              ElevatedButton(
                onPressed: () {
                  // Validasi 1: Jika kolom input masih kosong
                  if (_inputController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Harap masukkan email atau nomor handphone!'),
                      ),
                    );
                    return;
                  }

                  // Validasi 2: Jika kolom input sudah diisi
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tautan / kode atur ulang kata sandi telah dikirim!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066FF), // Warna biru tombol
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Sudut tombol melengkung (kapsul)
                  ),
                  elevation: 2, // Bayangan tipis di bawah tombol
                ),
                child: const Text(
                  'Kirim Tautan Atur Ulang',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}