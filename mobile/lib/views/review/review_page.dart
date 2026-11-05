import 'package:flutter/material.dart';

//tambahn import
import '../../controller/ulasan_controller.dart';
import '../../model/ulasan_model.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// [ReviewPage] adalah halaman stateless yang menampilkan ringkasan ulasan,
/// statistik rating, filter ulasan, serta daftar ulasan dari pengguna.
class ReviewPage extends StatefulWidget {
  final int idDestinasi;

  const ReviewPage({super.key, required this.idDestinasi});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // Menghubungkan View dengan Controller
  final controller = UlasanController();

  // Menampung data ulasan dari Supabase
  List<Ulasan> daftarUlasan = [];

  // Status loading
  bool loading = true;

  // Menampung pesan error
  String? pesanError;

  // Menyimpan filter ulasan yang sedang dipilih
  String filterAktif = 'Semua';

  // Controller untuk input komentar
  final komentarInput = TextEditingController();

  // Menyimpan rating yang dipilih user
  int ratingInput = 5;

  // Status proses penyimpanan ulasan
  bool menyimpan = false;

  // Mengambil ID user yang sedang login
  String? get idUserLogin => Supabase.instance.client.auth.currentUser?.id;

  // Mengambil ulasan yang berstatus aktif
  List<Ulasan> get ulasanAktif {
    return daftarUlasan.where((u) => u.status == true).toList();
  }

  // Mengambil ulasan sesuai filter yang dipilih
  List<Ulasan> get ulasanTampil {
    List<Ulasan> hasil = List.from(ulasanAktif);

    if (filterAktif == 'Terbaru') {
      hasil.sort((a, b) {
        return (b.tanggalDitambah ?? DateTime(2000)).compareTo(
          a.tanggalDitambah ?? DateTime(2000),
        );
      });
    } else if (filterAktif == 'Bintang 5') {
      hasil = hasil.where((u) => u.rating == 5).toList();
    }

    return hasil;
  }

  // Menghitung jumlah seluruh ulasan aktif
  int get totalUlasan => ulasanAktif.length;

  // Menghitung rata-rata rating
  double get rataRataRating {
    if (totalUlasan == 0) return 0;

    final totalRating = ulasanAktif.fold<int>(
      0,
      (total, u) => total + u.rating,
    );

    return totalRating / totalUlasan;
  }

  // Menghitung jumlah ulasan berdasarkan bintang
  int jumlahRating(int bintang) {
    return ulasanAktif.where((u) => u.rating == bintang).length;
  }

  // Menghitung persentase rating
  double persentaseRating(int bintang) {
    if (totalUlasan == 0) return 0;

    return jumlahRating(bintang) / totalUlasan;
  }

  // Dijalankan pertama kali ketika halaman dibuka
  @override
  void initState() {
    super.initState();
    ambilUlasan();
  }

  // READ: Mengambil data ulasan melalui Controller
  Future<void> ambilUlasan() async {
    setState(() {
      loading = true;
      pesanError = null;
    });

    try {
      // Meminta Controller mengambil data dari Supabase
      final data = await controller.lihatUlasan(widget.idDestinasi);

      if (!mounted) return;

      setState(() {
        daftarUlasan = data;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        pesanError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // Menampilkan pesan berhasil atau gagal
  void tampilPesan(String pesan) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  // CREATE: Menambahkan ulasan baru
  Future<void> simpanUlasan(BuildContext dialogContext) async {
    // Validasi komentar
    if (komentarInput.text.trim().isEmpty) {
      tampilPesan('Komentar tidak boleh kosong');
      return;
    }

    // Validasi login
    if (idUserLogin == null) {
      tampilPesan('Silakan login terlebih dahulu');
      return;
    }

    setState(() {
      menyimpan = true;
    });

    try {
      await controller.tambahUlasan(
        idDestinasi: widget.idDestinasi,
        rating: ratingInput,
        komentar: komentarInput.text.trim(),
      );

      if (!mounted) return;

      // Mengosongkan input komentar setelah berhasil
      komentarInput.clear();

      Navigator.pop(dialogContext);

      tampilPesan('Ulasan berhasil ditambahkan');
      await ambilUlasan();
    } catch (e) {
      tampilPesan('Gagal menambahkan ulasan: $e');
    } finally {
      if (mounted) {
        setState(() {
          menyimpan = false;
        });
      }
    }
  }

  // Menampilkan form tambah ulasan
  Future<void> bukaFormTambahUlasan() async {
    komentarInput.clear();
    ratingInput = 5;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Tulis Ulasan'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Memilih rating ulasan
                    DropdownButtonFormField<int>(
                      value: ratingInput,
                      decoration: const InputDecoration(
                        labelText: 'Rating',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(
                        5,
                        (index) => DropdownMenuItem(
                          value: index + 1,
                          child: Text('${index + 1} Bintang'),
                        ),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          ratingInput = value ?? 5;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    // Input komentar ulasan
                    TextField(
                      controller: komentarInput,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Tulis komentar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),

                ElevatedButton(
                  onPressed: menyimpan
                      ? null
                      : () => simpanUlasan(dialogContext),
                  child: menyimpan
                      ? const CircularProgressIndicator()
                      : const Text('Kirim Ulasan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // DELETE: Menghapus ulasan milik user
  Future<void> hapusUlasan(int idUlasan) async {
    try {
      await controller.hapusUlasan(idUlasan);

      tampilPesan('Ulasan berhasil dihapus');

      // Memuat ulang daftar ulasan
      await ambilUlasan();
    } catch (e) {
      tampilPesan('Gagal menghapus ulasan: $e');
    }
  }

  //konfirmais hps
  Future<void> konfirmasiHapus(int idUlasan) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Ulasan'),
        content: const Text('Apakah kamu yakin ingin menghapus ulasan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      await hapusUlasan(idUlasan);
    }
  }

  // UPDATE: Mengedit ulasan milik user
  Future<void> editUlasan(Ulasan ulasan) async {
    komentarInput.text = ulasan.komentar;
    ratingInput = ulasan.rating;

    final hasil = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit Ulasan'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    value: ratingInput,
                    decoration: const InputDecoration(
                      labelText: 'Rating',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      5,
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1} Bintang'),
                      ),
                    ),
                    onChanged: (value) {
                      setDialogState(() {
                        ratingInput = value ?? 5;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: komentarInput,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Komentar',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (hasil != true) return;

    if (komentarInput.text.trim().isEmpty) {
      tampilPesan('Komentar tidak boleh kosong');
      return;
    }

    try {
      await controller.ubahUlasan(
        Ulasan(
          idUlasan: ulasan.idUlasan,
          idUser: ulasan.idUser,
          idDestinasi: ulasan.idDestinasi,
          rating: ratingInput,
          komentar: komentarInput.text.trim(),
          status: ulasan.status,
        ),
      );

      tampilPesan('Ulasan berhasil diperbarui');
      await ambilUlasan();
    } catch (e) {
      tampilPesan('Gagal mengubah ulasan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warna latar belakang utama halaman (abu-abu sangat muda)
      backgroundColor: const Color(0xFFF8F9FA),

      // ==========================================
      // APP BAR (Bagian Atas Halaman)
      // ==========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
        // Tombol kembali (Back Button)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),

        // Judul halaman
        title: const Text(
          'Ulasan & Reviews',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        // Aksi/Tombol tambahan di kanan AppBar
        actions: [
          // Tombol bagikan
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {},
          ),
          // Tombol menu opsi (titik tiga)
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),

      // ==========================================
      // BODY (Konten Utama yang Bisa Di-scroll)
      // ==========================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------------------------------------------
            // 1. CARD RINGKASAN RATING & PROGRESS BAR
            // ----------------------------------------------------
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // --- Kotak Angka Rating Keseluruhan ---
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // Angka rata-rata rating dari database
                              Text(
                                rataRataRating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // 5 Bintang kecil warna emas
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Keterangan batas rating
                              const Text(
                                'dari 5.0',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // --- Progress Bar Breakdown Rating (1-5 Bintang) ---
                        Expanded(
                          child: Column(
                            children: [
                              _buildRatingBar(
                                '5',
                                persentaseRating(5),
                                '${(persentaseRating(5) * 100).toStringAsFixed(0)}%',
                              ),
                              _buildRatingBar(
                                '4',
                                persentaseRating(4),
                                '${(persentaseRating(4) * 100).toStringAsFixed(0)}%',
                              ),
                              _buildRatingBar(
                                '3',
                                persentaseRating(3),
                                '${(persentaseRating(3) * 100).toStringAsFixed(0)}%',
                              ),
                              _buildRatingBar(
                                '2',
                                persentaseRating(2),
                                '${(persentaseRating(2) * 100).toStringAsFixed(0)}%',
                              ),
                              _buildRatingBar(
                                '1',
                                persentaseRating(1),
                                '${(persentaseRating(1) * 100).toStringAsFixed(0)}%',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1), // Garis pembatas horizontal
                    const SizedBox(height: 12),

                    // --- Informasi Tambahan (Jumlah Ulasan & Tingkat Kepuasan) ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Jumlah pengulas terverifikasi
                        Row(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '$totalUlasan ulasan pelancong\nterverifikasi',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        // Persentase pelanggan yang senang
                        Row(
                          children: [
                            Icon(
                              Icons.thumb_up_alt_outlined,
                              size: 16,
                              color: Colors.green,
                            ),
                            SizedBox(width: 6),
                            Text(
                              '98%\nSenang',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ----------------------------------------------------
            // 2. TAB FILTER ULASAN (Horizontal Scroll)
            // ----------------------------------------------------
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    'Semua ($totalUlasan)',
                    isSelected: filterAktif == 'Semua',
                    onTap: () {
                      setState(() {
                        filterAktif = 'Semua';
                      });
                    },
                  ),

                  const SizedBox(width: 8),

                  _buildFilterChip(
                    'Terbaru',
                    isSelected: filterAktif == 'Terbaru',
                    onTap: () {
                      setState(() {
                        filterAktif = 'Terbaru';
                      });
                    },
                  ),

                  const SizedBox(width: 8),

                  _buildFilterChip(
                    '★ Bintang 5',
                    isSelected: filterAktif == 'Bintang 5',
                    onTap: () {
                      setState(() {
                        filterAktif = 'Bintang 5';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ----------------------------------------------------
            // 3. DAFTAR KARTU ULASAN PENGGUNA
            // ----------------------------------------------------
            // DAFTAR ULASAN DARI SUPABASE
            if (loading)
              const Center(child: CircularProgressIndicator())
            else if (pesanError != null)
              Center(child: Text('Gagal mengambil ulasan: $pesanError'))
            else if (ulasanTampil.isEmpty)
              const Center(child: Text('Belum ada ulasan'))
            else
              ...ulasanTampil.map((ulasan) {
                // Memeriksa apakah ulasan milik user yang sedang login
                final milikSendiri = ulasan.idUser == idUserLogin;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildReviewCard(
                    name: ulasan.namaUser ?? 'Pengguna',
                    fotoProfil: ulasan.fotoProfil,
                    isVerified: false,
                    userCategory: '',
                    date: ulasan.tanggalDitambah?.toLocal().toString() ?? '-',
                    rating: ulasan.rating.toString(),
                    comment: ulasan.komentar,
                    likesCount: 0,
                    milikSendiri: milikSendiri,
                    onEdit: () {
                      editUlasan(ulasan);
                    },
                    onDelete: () {
                      if (ulasan.idUlasan != null) {
                        konfirmasiHapus(ulasan.idUlasan!);
                      }
                    },
                  ),
                );
              }),
          ],
        ),
      ),

      // Tombol untuk menulis ulasan
      floatingActionButton: FloatingActionButton.extended(
        onPressed: bukaFormTambahUlasan,
        backgroundColor: const Color(0xFF0056C6),
        icon: const Icon(Icons.rate_review, color: Colors.white),
        label: const Text(
          'Tulis Ulasan',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Menghapus controller komentar ketika halaman ditutup
    komentarInput.dispose();
    super.dispose();
  }

  // ==========================================
  // HELPER WIDGETS (Fungsi Pembantu UI)
  // ==========================================

  /// Membangun satu baris progress bar statistik rating bintang.
  /// - [starText]: Label angka bintang (misal: "5")
  /// - [percent]: Nilai persentase dalam bentuk desimal 0.0 - 1.0 (misal: 0.85 untuk 85%)
  /// - [percentText]: Teks persentase yang ditampilkan di ujung kanan (misal: "85%")
  Widget _buildRatingBar(String starText, double percent, String percentText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          Text(starText, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 2),
          const Icon(Icons.star, size: 10, color: Colors.amber),
          const SizedBox(width: 6),

          // Progress bar horizontal
          Expanded(
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade200,
              color: Colors.amber,
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),

          // Teks persentase
          SizedBox(
            width: 26,
            child: Text(
              percentText,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  /// Membangun tombol chip/kategori filter ulasan.
  /// - [label]: Teks filter
  /// - [isSelected]: Menentukan apakah chip sedang aktif/dipilih
  /// - [onTap]: Aksi ketika chip diklik
  Widget _buildFilterChip(
    String label, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0056C6) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Membangun kartu ulasan individu dari seorang pengguna.
  /// - [name]: Nama pengguna
  /// - [isVerified]: Menampilkan centang biru jika `true`
  /// - [userCategory]: Kategori pengguna (misal: "Wisatawan Lokal"), dikosongkan jika tidak ada
  /// - [date]: Waktu pembuatan ulasan
  /// - [rating]: Nilai rating yang diberikan (misal: "5.0")
  /// - [comment]: Isi teks ulasan
  /// - [likesCount]: Jumlah orang yang merasa ulasan ini membantu
  Widget _buildReviewCard({
    required String name,
    String? fotoProfil,
    required bool isVerified,
    required String userCategory,
    required String date,
    required String rating,
    required String comment,
    required int likesCount,
    required bool milikSendiri,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Baris Atas: Foto Profil, Nama, Lencana, Tanggal, & Badge Rating ---
            Row(
              children: [
                // Avatar Pengguna
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                // Informasi Nama, Status Terverifikasi, Kategori, & Tanggal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama + Icon Centang Terverifikasi
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          if (isVerified) const SizedBox(width: 4),
                          if (isVerified)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 14,
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),

                      // Kategori Pengguna + Tanggal
                      Row(
                        children: [
                          if (userCategory.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                userCategory,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          Text(
                            date,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Badge Nilai Rating Pengguna (Kuning Emas)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // --- Teks Isi Ulasan ---
            Text(
              comment,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),

            // --- Baris Bawah: Tombol "Membantu" (Like) & Tombol Bagikan Ulasan ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Badge Membantu
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.thumb_up,
                        size: 12,
                        color: Color(0xFF1A73E8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Membantu ($likesCount)',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF1A73E8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol Edit dan Hapus hanya untuk pemilik ulasan
                if (milikSendiri)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: onEdit,
                        tooltip: 'Edit ulasan',
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 18,
                        ),
                        onPressed: onDelete,
                        tooltip: 'Hapus ulasan',
                      ),
                    ],
                  )
                else
                  IconButton(
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
