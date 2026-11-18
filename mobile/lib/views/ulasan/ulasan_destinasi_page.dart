import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/ulasan_user_controller.dart';
import '../../models/ulasan_user_model.dart';

// =====================================================
// HALAMAN ULASAN DESTINASI
// =====================================================

class UlasanDestinasiPage extends StatefulWidget {
  final int idDestinasi;
  final String namaDestinasi;

  const UlasanDestinasiPage({
    super.key,
    required this.idDestinasi,
    this.namaDestinasi = 'Destinasi',
  });

  @override
  State<UlasanDestinasiPage> createState() => _UlasanDestinasiPageState();
}

class _UlasanDestinasiPageState extends State<UlasanDestinasiPage> {
  final UlasanUserController _controller = UlasanUserController();

  late final StreamSubscription<AuthState> _authSubscription;

  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF7F8FC);

  bool get _isLoggedIn => Supabase.instance.client.auth.currentUser != null;

  @override
  void initState() {
    super.initState();

    _controller.loadData(widget.idDestinasi);

    // Mengikuti perubahan autentikasi dari fitur Profil.
    // Tidak membuat proses login baru di halaman ulasan.
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      authState,
    ) {
      if (!mounted) return;

      final event = authState.event;

      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.signedOut) {
        setState(() {});

        unawaited(_controller.refreshData(widget.idDestinasi));
      }
    });
  }

  @override
  void didUpdateWidget(covariant UlasanDestinasiPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.idDestinasi != widget.idDestinasi) {
      _controller.loadData(widget.idDestinasi);
    }
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  // =====================================================
  // NOTIFIKASI
  // =====================================================

  void _showMessage(String message, {Color backgroundColor = primaryColor}) {
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // =====================================================
  // MEMBUKA FORM TAMBAH / EDIT ULASAN
  // =====================================================

  Future<void> _bukaFormUlasan() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      _showMessage(
        'Silakan login terlebih dahulu untuk memberikan ulasan.',
        backgroundColor: Colors.blueGrey,
      );
      return;
    }

    final hasil = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return UlasanFormSheet(
          controller: _controller,
          idDestinasi: widget.idDestinasi,
          ulasan: _controller.ulasanSaya,
        );
      },
    );

    if (!mounted) return;

    if (hasil == true) {
      _showMessage('Ulasan berhasil disimpan.', backgroundColor: Colors.green);
    }
  }

  // =====================================================
  // MENGHAPUS ULASAN
  // =====================================================

  Future<void> _hapusUlasan(UlasanUserModel ulasan) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Hapus Ulasan?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Apakah kamu yakin ingin menghapus ulasan ini? '
            'Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (konfirmasi != true || !mounted) return;

    final berhasil = await _controller.hapusUlasan(
      idDestinasi: widget.idDestinasi,
      idUlasan: ulasan.idUlasan,
    );

    if (!mounted) return;

    _showMessage(
      berhasil
          ? 'Ulasan berhasil dihapus.'
          : _controller.errorMessage ?? 'Gagal menghapus ulasan.',
      backgroundColor: berhasil ? Colors.green : Colors.red,
    );
  }

  // =====================================================
  // FORMAT TANGGAL
  // =====================================================

  String _formatTanggal(DateTime tanggal) {
    final t = tanggal.toLocal();

    final hari = t.day.toString().padLeft(2, '0');
    final bulan = t.month.toString().padLeft(2, '0');

    return '$hari/$bulan/${t.year}';
  }

  // =====================================================
  // TAMPILAN UTAMA
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF172B4D),
        title: const Text(
          'Ulasan Pengunjung',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          if (_controller.isLoading && _controller.ringkasanRating == null) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (_controller.errorMessage != null &&
              _controller.ringkasanRating == null) {
            return _buildErrorState();
          }

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () {
              return _controller.refreshData(widget.idDestinasi);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1080),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.namaDestinasi,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172B4D),
                          ),
                        ),

                        const SizedBox(height: 7),

                        const Text(
                          'Bagikan pengalamanmu dan lihat '
                          'pengalaman pengunjung lainnya.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        if (_controller.errorMessage != null)
                          _buildInlineError(),

                        _buildRingkasanRating(),

                        const SizedBox(height: 18),

                        // AKSES MEMBERIKAN ULASAN
                        if (_isLoggedIn)
                          _buildTombolUlasan()
                        else
                          _buildInfoLogin(),

                        const SizedBox(height: 28),

                        // HEADER DAFTAR ULASAN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Ulasan Pengunjung',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF172B4D),
                              ),
                            ),
                            Text(
                              '${_controller.jumlahUlasan} ulasan',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        // DAFTAR ULASAN
                        if (_controller.listUlasan.isEmpty)
                          _buildUlasanKosong()
                        else
                          ..._controller.listUlasan.map((ulasan) {
                            final userId =
                                Supabase.instance.client.auth.currentUser?.id;

                            final milikSaya =
                                userId != null && userId == ulasan.idUser;

                            return _buildKartuUlasan(ulasan, milikSaya);
                          }),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =====================================================
  // ERROR STATE
  // =====================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, color: Colors.grey, size: 52),
            const SizedBox(height: 15),
            const Text(
              'Gagal Memuat Ulasan',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _controller.errorMessage ??
                  'Terjadi kesalahan saat mengambil data.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () {
                _controller.loadData(widget.idDestinasi);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // ERROR KECIL SAAT REFRESH
  // =====================================================

  Widget _buildInlineError() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _controller.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // RINGKASAN RATING
  // =====================================================

  Widget _buildRingkasanRating() {
    final rataRata = _controller.rataRataRating;
    final jumlah = _controller.jumlahUlasan;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // NILAI RATA-RATA
          SizedBox(
            width: 105,
            child: Column(
              children: [
                Text(
                  rataRata.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
                _buildBintang(rataRata),
                const SizedBox(height: 6),
                Text(
                  '$jumlah ulasan',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // DISTRIBUSI RATING
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final bintang = 5 - index;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        child: Text(
                          '$bintang',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      const Icon(Icons.star, color: Colors.amber, size: 16),

                      const SizedBox(width: 8),

                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _controller.persentaseRating(bintang),
                            minHeight: 7,
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.amber,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      SizedBox(
                        width: 20,
                        child: Text(
                          '${_controller.jumlahRating(bintang)}',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // WIDGET BINTANG
  // =====================================================

  Widget _buildBintang(double rating, {double size = 18}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final nilai = index + 1;

        IconData icon;

        if (rating >= nilai) {
          icon = Icons.star;
        } else if (rating >= nilai - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return Icon(icon, color: Colors.amber, size: size);
      }),
    );
  }

  // =====================================================
  // INFORMASI LOGIN
  // =====================================================

  Widget _buildInfoLogin() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lock_outline, color: primaryColor),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              'Ulasan dapat dibaca tanpa login. '
              'Login diperlukan untuk memberikan ulasan.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // TOMBOL TAMBAH / EDIT ULASAN
  // =====================================================

  Widget _buildTombolUlasan() {
    final sudahMengulas = _controller.ulasanSaya != null;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _bukaFormUlasan,
        icon: Icon(
          sudahMengulas ? Icons.edit_outlined : Icons.rate_review_outlined,
        ),
        label: Text(sudahMengulas ? 'Edit Ulasan Saya' : 'Tulis Ulasan'),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // AVATAR PENGULAS
  // =====================================================

  String _inisialNama(String nama) {
    final bersih = nama.trim();

    if (bersih.isEmpty) return 'P';

    final bagian = bersih.split(RegExp(r'\s+'));

    if (bagian.length == 1) {
      return bagian.first.substring(0, 1).toUpperCase();
    }

    return '${bagian[0][0]}${bagian[1][0]}'.toUpperCase();
  }

  Widget _avatarFallback(String nama) {
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      color: Colors.blue.shade50,
      child: Text(
        _inisialNama(nama),
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget _buildAvatar(String nama, String? fotoProfil) {
    final foto = fotoProfil?.trim();

    return CircleAvatar(
      radius: 23,
      backgroundColor: Colors.blue.shade50,
      child: ClipOval(
        child: foto == null || foto.isEmpty
            ? _avatarFallback(nama)
            : Image.network(
                foto,
                width: 46,
                height: 46,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _avatarFallback(nama);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return _avatarFallback(nama);
                },
              ),
      ),
    );
  }

  // =====================================================
  // KARTU ULASAN
  // =====================================================

  Widget _buildKartuUlasan(UlasanUserModel ulasan, bool milikSaya) {
    final nama = ulasan.namaPengguna.trim().isEmpty
        ? 'Pengunjung'
        : ulasan.namaPengguna;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(nama, ulasan.fotoProfil),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milikSaya ? 'Anda' : nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF172B4D),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _formatTanggal(ulasan.tanggalDitambah),
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // MENU EDIT DAN HAPUS
              if (milikSaya)
                PopupMenuButton<String>(
                  tooltip: 'Kelola ulasan',
                  onSelected: (value) {
                    if (value == 'edit') {
                      _bukaFormUlasan();
                    } else if (value == 'hapus') {
                      _hapusUlasan(ulasan);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 19),
                          SizedBox(width: 9),
                          Text('Edit Ulasan'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'hapus',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 19,
                          ),
                          SizedBox(width: 9),
                          Text(
                            'Hapus Ulasan',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 13),

          _buildBintang(ulasan.rating.toDouble(), size: 18),

          const SizedBox(height: 10),

          Text(
            ulasan.komentar,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // JIKA BELUM ADA ULASAN
  // =====================================================

  Widget _buildUlasanKosong() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey),

          SizedBox(height: 12),

          Text(
            'Belum Ada Ulasan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Belum ada pengunjung yang memberikan ulasan '
            'untuk destinasi ini. Jadilah yang pertama!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// FORM TAMBAH DAN EDIT ULASAN
// =====================================================

class UlasanFormSheet extends StatefulWidget {
  final UlasanUserController controller;
  final int idDestinasi;
  final UlasanUserModel? ulasan;

  const UlasanFormSheet({
    super.key,
    required this.controller,
    required this.idDestinasi,
    this.ulasan,
  });

  @override
  State<UlasanFormSheet> createState() => _UlasanFormSheetState();
}

class _UlasanFormSheetState extends State<UlasanFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _komentarController;

  int _rating = 5;

  static const Color primaryColor = Color(0xFF2563EB);

  bool get _modeEdit => widget.ulasan != null;

  @override
  void initState() {
    super.initState();

    _rating = widget.ulasan?.rating ?? 5;

    _komentarController = TextEditingController(
      text: widget.ulasan?.komentar ?? '',
    );
  }

  @override
  void dispose() {
    _komentarController.dispose();
    super.dispose();
  }

  // =====================================================
  // MENGIRIM ULASAN
  // =====================================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (widget.controller.isSubmitting) return;

    bool berhasil;

    if (_modeEdit) {
      berhasil = await widget.controller.updateUlasan(
        idDestinasi: widget.idDestinasi,
        idUlasan: widget.ulasan!.idUlasan,
        rating: _rating,
        komentar: _komentarController.text,
      );
    } else {
      berhasil = await widget.controller.tambahUlasan(
        idDestinasi: widget.idDestinasi,
        rating: _rating,
        komentar: _komentarController.text,
      );
    }

    if (!mounted) return;

    if (berhasil) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              widget.controller.errorMessage ?? 'Ulasan gagal disimpan.',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  // =====================================================
  // TAMPILAN FORM
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 22,
          bottom: MediaQuery.of(context).viewInsets.bottom + 25,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // HANDLE BOTTOM SHEET
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // JUDUL
              Text(
                _modeEdit ? 'Edit Ulasan' : 'Bagikan Pengalamanmu',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172B4D),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Berikan penilaian dan ceritakan pengalamanmu '
                'mengunjungi destinasi ini.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 25),

              // LABEL RATING
              const Center(
                child: Text(
                  'Berapa rating yang kamu berikan?',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 12),

              // PILIH BINTANG
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final nilai = index + 1;

                    return IconButton(
                      tooltip: '$nilai bintang',
                      onPressed: () {
                        setState(() {
                          _rating = nilai;
                        });
                      },
                      icon: Icon(
                        nilai <= _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 38,
                      ),
                    );
                  }),
                ),
              ),

              Center(
                child: Text(
                  '$_rating dari 5 bintang',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ),

              const SizedBox(height: 25),

              // KOMENTAR
              const Text(
                'Ceritakan pengalamanmu',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _komentarController,
                maxLines: 5,
                minLines: 3,
                maxLength: 1000,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Bagaimana pengalamanmu mengunjungi tempat ini?',
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: const Color(0xFFF7F8FC),
                  contentPadding: const EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Komentar tidak boleh kosong.';
                  }

                  if (value.trim().length > 1000) {
                    return 'Komentar maksimal 1000 karakter.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              // TOMBOL KIRIM
              SizedBox(
                width: double.infinity,
                height: 50,
                child: AnimatedBuilder(
                  animation: widget.controller,
                  builder: (context, child) {
                    final isSubmitting = widget.controller.isSubmitting;

                    return ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.blue.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _modeEdit ? 'Simpan Perubahan' : 'Kirim Ulasan',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
