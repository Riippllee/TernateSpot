// Mengambil library Flutter untuk membuat tampilan, tombol, teks, 
// kolom input, ikon, dan komponen lainnya.
import 'package:flutter/material.dart';

// Mengambil library Supabase untuk menjalankan proses pendaftaran akun
import 'package:supabase_flutter/supabase_flutter.dart';

// Membuat halaman pendaftaran akun TernateSpot.
class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  // Menghubungkan halaman dengan bagian yang mengatur perubahan tampilan.
  @override
  State<DaftarPage> createState() => _DaftarPageState();
}
class _DaftarPageState extends State<DaftarPage> {

  // Digunakan untuk memeriksa apakah semua kolom sudah diisi dengan benar
  final _formKey = GlobalKey<FormState>();

  // Menyimpan teks yang dimasukkan pengguna pada setiap kolom.
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final konfirmasiController = TextEditingController();

  // Mengatur apakah password ditampilkan atau disembunyikan.
  bool passwordVisible = false;
  bool konfirmasiVisible = false;
  //Menyimpan status persetujuan syarat dan ketentuan.
  bool setuju = false;
  // Menandai apakah proses pendaftaran sedang berlangsung.
  bool loading = false;

  // Membersihkan controller ketika halaman tidak digunakan lagi.
  // Tujuannya agar sumber daya yang digunakan tidak terbuang.
  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    passwordController.dispose();
    konfirmasiController.dispose();
    super.dispose();
  }

  // Fungsi yang dijalankan ketika pengguna menekan tombol Daftar Sekarang.
  Future<void> daftarAkun() async {
    // Memeriksa semua kolom. Jika ada yang tidak sesuai, 
    // proses pendaftaran langsung dihentikan.
    if (!_formKey.currentState!.validate()) return;
    // Memeriksa apakah pengguna sudah menyetujui syarat dan ketentuan yang telah di tentukan
    if (!setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Silakan setujui Syarat & Ketentuan terlebih dahulu.',
          ),
        ),
      );
      return;
    }

    // Mengubah status menjadi loading agar pengguna tahu 
    // bahwa aplikasi sedang memproses pendaftaran.
    setState(() {
      loading = true;
    });

    try {
      // Mengirim email, password, dan nama pengguna ke Supabase 
      // untuk membuat akun baru.
      final response = await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        data: {
          // Menyimpan nama lengkap sebagai informasi tambahan akun.
          'nama_lengkap': namaController.text.trim(),
        },
      );

      // Memastikan halaman masih terbuka sebelum menampilkan pesan.
      if (!mounted) return;

      // Jika Supabase mengembalikan data pengguna, 
      // aplikasi menampilkan pesan bahwa pendaftaran telah berhasil
      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Pendaftaran berhasil! Silakan cek email untuk konfirmasi.',
            ),
          ),
        );
      }
    } on AuthException catch (e) {

      // Menampilkan pesan jika terjadi kesalahan saat proses
      // pendaftaran melalui Supabase.
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    } catch (e) {
      // Menampilkan pesan jika terjadi kesalahan lainnya.
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    } finally {
      // Menghentikan loading setelah proses selesai,
      // baik pendaftaran berhasil maupun mengalami kesalahan.
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // Membuat pengaturan tampilan kolom input supaya semuanya seragam.
  // Petunjuk, ikon, dan ikon tambahan bisa diatur sesuai kebutuhan.  
  InputDecoration inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      // Menampilkan petunjuk di dalam kolom sebelum diisi
      hintText: hint,
      // Mengatur warna dan ukuran tulisan petunjuk.
      hintStyle: const TextStyle(
        color: Color(0xFFB8C0CC),
        fontSize: 13,
      ),

      // Menampilkan ikon di sebelah kiri kolom.
      prefixIcon: Icon(
        icon,
        size: 18,
        color: const Color(0xFFB8C0CC),
      ),

      // Menampilkan ikon tambahan di sebelah kanan, 
      // misalnya ikon mata pada kolom password.
      suffixIcon: suffixIcon,
      // Memberikan warna putih pada latar kolom.
      filled: true,
      fillColor: Colors.white,
      // Mengatur jarak teks dari tepi kolom.
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 15,
      ),

      // Mengatur bentuk sudut dan garis kolom input.
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE4E9F2),
        ),
      ),

      // Mengatur garis kolom ketika belum dipilih.
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFFE4E9F2),
        ),
      ),

      // Mengubah warna garis ketika kolom sedang dipilih.
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF1769E0),
          width: 1.5,
        ),
      ),
    );
  }

  // Menyusun seluruh tampilan halaman pendaftaran.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Memberikan warna latar belakang halaman.
      backgroundColor: const Color(0xFFF7F9FE),
      // Menjaga tampilan agar tidak tertutup bagian sistem HP.
      body: SafeArea(
        child: Center(
          // Membuat halaman bisa digulir jika isinya terlalu panjang.
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),

            // Mengelompokkan kolom input agar dapat diperiksa
            // menggunakan _formKey.
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LOGO dan nama TernateSpot.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.landscape_outlined,
                          color: Color(0xFF1769E0),
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 5),

                      // Membuat tulisan TernateSpot dengan dua warna.
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'ternate',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Spot',
                              style: TextStyle(
                                color: Color(0xFF1769E0),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // JUDUL halaman pendaftaran
                  const Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF171717),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Menjelaskan tujuan pengguna membuat akun.
                  const Text(
                    'Daftar untuk mulai menjelajahi pesona\n'
                    'rempah Kota Ternate',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Color(0xFF9299A6),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // TAB MASUK / DAFTAR
                  Container(
                    height: 42,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2ECFC),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Text(
                              'Daftar Akun',
                              style: TextStyle(
                                color: Color(0xFF1769E0),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // NAMA LENGKAP
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nama Lengkap',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  // Kolom untuk memasukkan nama lengkap. 
                  // Jika kosong, pengguna diminta mengisinya.
                  TextFormField(
                    controller: namaController,
                    textInputAction: TextInputAction.next,
                    decoration: inputDecoration(
                      hint: 'Masukkan nama lengkap anda',
                      icon: Icons.person_outline,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama lengkap wajib diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Membuat label EMAIL
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  // Kolom untuk memasukkan email pengguna.
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: inputDecoration(
                      hint: 'nama@email.com',
                      icon: Icons.email_outlined,
                    ),
                    validator: (value) {
                      // Email tidak boleh kosong.
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }

                      // Pemeriksaan sederhana untuk tanda @.
                      if (!value.contains('@')) {
                        return 'Masukkan email yang valid';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // KATA SANDI
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Kata Sandi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  // Kolom untuk membuat password.
                  // Password disembunyikan jika passwordVisible bernilai false.
                  TextFormField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    textInputAction: TextInputAction.next,
                    decoration: inputDecoration(
                      hint: 'Minimal 6 karakter',
                      icon: Icons.lock_outline,

                      // Tombol mata untuk melihat atau menyembunyikan password.
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 18,
                          color: const Color(0xFF9AA3B2),
                        ),
                      ),
                    ),

                    validator: (value) {
                      // Password tidak boleh kosong.
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi wajib diisi';
                      }

                      // Password harus terdiri dari minimal 6 karakter.
                      if (value.length < 6) {
                        return 'Minimal 6 karakter';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // KONFIRMASI KATA SANDI
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Konfirmasi Kata Sandi',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 7),

                  // Kolom untuk mengetik ulang password. 
                  // Password harus sama dengan kolom sebelumnya.
                  TextFormField(
                    controller: konfirmasiController,
                    obscureText: !konfirmasiVisible,
                    textInputAction: TextInputAction.done,
                    decoration: inputDecoration(
                      hint: 'Ulangi kata sandi',
                      icon: Icons.verified_user_outlined,
                      // Tombol untuk melihat atau menyembunyikan 
                      // password konfirmasi.
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            konfirmasiVisible = !konfirmasiVisible;
                          });
                        },
                        icon: Icon(
                          konfirmasiVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 18,
                          color: const Color(0xFF9AA3B2),
                        ),
                      ),
                    ),

                    validator: (value) {
                      // Konfirmasi password tidak boleh kosong.
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi kata sandi';
                      }
                      // Memastikan password yang diketik sama.
                      if (value != passwordController.text) {
                        return 'Kata sandi tidak sama';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  // CHECKBOX
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: Checkbox(
                          value: setuju,
                          // Menyimpan perubahan saat checkbox dicentang 
                          // atau dilepas.
                          onChanged: (value) {
                            setState(() {
                              setuju = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF1769E0),
                        ),
                      ),

                      const SizedBox(width: 5),
                      // Menampilkan teks persetujuan dengan warna tertentu.
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF8A919E),
                              height: 1.3,
                            ),
                            children: [
                              TextSpan(
                                text: 'Saya menyetujui ',
                              ),
                              TextSpan(
                                text: 'Syarat & Ketentuan',
                                style: TextStyle(
                                  color: Color(0xFF1769E0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' serta ',
                              ),
                              TextSpan(
                                text: 'Kebijakan Privasi',
                                style: TextStyle(
                                  color: Color(0xFF1769E0),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' TernateSpot.',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Membuat tomboL DAFTAR SEKARANG
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(

                      // Tombol tidak bisa ditekan selama proses berlangsung. 
                      // Jika tidak loading, tombol menjalankan daftarAkun().
                      onPressed: loading ? null : daftarAkun,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1769E0),
                        disabledBackgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      
                      // Menampilkan loading atau tulisan tombol,
                      // sesuai keadaan proses pendaftaran.
                      child: loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Daftar Sekarang',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 17,
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // PEMBATAS, Membuat garis pemisah antara pendaftaran biasa
                  // dan pilihan pendaftaran menggunakan Google.
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'atau daftar dengan',
                          style: TextStyle(
                            color: Color(0xFFADB3BD),
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Membuat tombol GOOGLE
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Pendaftaran dengan Google belum diaktifkan.',
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFE2E6ED),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'G',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Google',
                            style: TextStyle(
                              color: Color(0xFF555B65),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // SUDAH PUNYA AKUN, Menampilkan ajakan masuk bagi pengguna
                  // yang sudah memiliki akun.
                  // Pada kode ini, tulisan belum menjalankan navigasi.
                  const Text.rich(
                    TextSpan(
                      style: TextStyle(
                        color: Color(0xFF9299A6),
                        fontSize: 11,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sudah punya akun? ',
                        ),
                        TextSpan(
                          text: 'Masuk Sekarang',
                          style: TextStyle(
                            color: Color(0xFF1769E0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Membuat tombol untuk menjelajahi aplikasi sebagai tamu.
                  // onPressed masih kosong, jadi tombol belum menjalankan aksi.
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.account_circle_outlined,
                      size: 17,
                      color: Color(0xFF87909E),
                    ),
                    label: const Text(
                      'Jelajah sebagai Tamu',
                      style: TextStyle(
                        color: Color(0xFF87909E),
                        fontSize: 11,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFEAF0F9),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}