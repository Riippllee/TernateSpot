import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ternatespot/controllers/destinasi_user_controller.dart';
import 'package:ternatespot/controllers/ulasan_user_controller.dart';
import 'package:ternatespot/models/destinasi_user_model.dart';
import 'package:ternatespot/models/ulasan_user_model.dart';

class DetailDestinasiPage extends StatefulWidget {
  final int destinasiId;
  final DestinasiUserController controller;

  const DetailDestinasiPage({
    super.key,
    required this.destinasiId,
    required this.controller,
  });

  @override
  State<DetailDestinasiPage> createState() => _DetailDestinasiPageState();
}

class _DetailDestinasiPageState extends State<DetailDestinasiPage> {
  late Future<DestinasiUserModel?> _detailFuture;

  final SupabaseClient _supabase = Supabase.instance.client;

  // CONTROLLER DAN FORM ULASAN
  late final UlasanUserController _ulasanController;
  final TextEditingController _komentarController = TextEditingController();

  int _selectedRating = 5;
  bool _showReviewForm = false;
  bool _isEditingReview = false;

  // STATUS FAVORIT
  bool _isFavorite = false;
  bool _isFavoriteLoading = true;
  bool _isFavoriteProcessing = false;

  // ==========================================
  // WARNA TEMA TERNATESPOT
  // ==========================================

  static const Color primaryColor = Color(0xFF0875ED);
  static const Color darkColor = Color(0xFF172B4D);
  static const Color backgroundColor = Color(0xFFF5F8FC);
  static const Color textColor = Color(0xFF64748B);
  static const Color lightBlueColor = Color(0xFFE5F3FC);

  // ==========================================
  // LIFECYCLE
  // ==========================================

  @override
  void initState() {
    super.initState();
    _ulasanController = UlasanUserController();
    _loadDetail();
    _loadFavoriteStatus();
    _loadUlasan();
  }

  @override
  void didUpdateWidget(covariant DetailDestinasiPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.destinasiId != widget.destinasiId ||
        oldWidget.controller != widget.controller) {
      _loadDetail();
      _loadFavoriteStatus();

      if (oldWidget.destinasiId != widget.destinasiId) {
        _showReviewForm = false;
        _isEditingReview = false;
        _selectedRating = 5;
        _komentarController.clear();
        _loadUlasan();
      }
    }
  }

  @override
  void dispose() {
    _ulasanController.dispose();
    _komentarController.dispose();
    super.dispose();
  }

  // ==========================================
  // MEMUAT DATA ULASAN
  // ==========================================

  void _loadUlasan() {
    _ulasanController.loadData(widget.destinasiId);
  }

  // ==========================================
  // MEMUAT DATA DETAIL
  // ==========================================

  void _loadDetail() {
    _detailFuture = widget.controller.getDetailDestinasi(widget.destinasiId);
  }

  void _retry() {
    setState(() {
      _loadDetail();
    });
  }

  // ==========================================
  // HELPER DATA
  // ==========================================

  String _displayText(String value, String fallback) {
    final result = value.trim();

    if (result.isEmpty || result.toLowerCase() == 'null') {
      return fallback;
    }

    return result;
  }

  bool _hasValidCoordinates(DestinasiUserModel destinasi) {
    return destinasi.latitude.isFinite &&
        destinasi.longitude.isFinite &&
        destinasi.latitude >= -90 &&
        destinasi.latitude <= 90 &&
        destinasi.longitude >= -180 &&
        destinasi.longitude <= 180;
  }

  // ==========================================
  // NOTIFIKASI
  // ==========================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ==========================================
  // MEMBUKA GOOGLE MAPS
  // ==========================================

  Future<void> _openGoogleMaps(DestinasiUserModel destinasi) async {
    if (!_hasValidCoordinates(destinasi)) {
      _showMessage('Koordinat lokasi tidak valid.');
      return;
    }

    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': '${destinasi.latitude},${destinasi.longitude}',
    });

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        _showMessage('Tidak dapat membuka Google Maps.');
      }
    } catch (_) {
      _showMessage('Terjadi kesalahan saat membuka lokasi.');
    }
  }

  // ==========================================
  // MENYALIN INFORMASI DESTINASI
  // ==========================================

  Future<void> _copyLocationInfo(DestinasiUserModel destinasi) async {
    final alamat = _displayText(destinasi.alamat, 'Alamat belum tersedia');

    final mapsLink = _hasValidCoordinates(destinasi)
        ? Uri.https('www.google.com', '/maps/search/', {
            'api': '1',
            'query': '${destinasi.latitude},${destinasi.longitude}',
          }).toString()
        : 'Koordinat belum tersedia';

    final informasi =
        '''
${destinasi.namaDestinasi}

Alamat:
$alamat

Lokasi:
$mapsLink
''';

    try {
      await Clipboard.setData(ClipboardData(text: informasi));

      _showMessage('Informasi destinasi berhasil disalin.');
    } catch (_) {
      _showMessage('Gagal menyalin informasi destinasi.');
    }
  }

  // ==========================================
  // MEMUAT STATUS FAVORIT DARI SUPABASE
  // ==========================================

  Future<void> _loadFavoriteStatus() async {
    final user = _supabase.auth.currentUser;

    // Pengguna belum login.
    if (user == null) {
      if (!mounted) return;

      setState(() {
        _isFavorite = false;
        _isFavoriteLoading = false;
      });

      return;
    }

    final userId = user.id;

    if (mounted) {
      setState(() {
        _isFavoriteLoading = true;
      });
    }

    try {
      final response = await _supabase
          .from('favorit')
          .select('id_destinasi')
          .eq('id_user', userId)
          .eq('id_destinasi', widget.destinasiId)
          .limit(1);

      if (!mounted || _supabase.auth.currentUser?.id != userId) {
        return;
      }

      setState(() {
        _isFavorite = response.isNotEmpty;
      });
    } catch (error) {
      debugPrint('Gagal memuat status favorit: $error');

      if (!mounted) return;

      setState(() {
        _isFavorite = false;
      });

      _showMessage('Status favorit belum dapat dimuat.');
    } finally {
      if (mounted) {
        setState(() {
          _isFavoriteLoading = false;
        });
      }
    }
  }

  // ==========================================
  // TAMBAH / HAPUS FAVORIT
  // ==========================================

  Future<void> _toggleFavorite() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      _showMessage('Silakan login terlebih dahulu untuk menyimpan favorit.');
      return;
    }

    if (_isFavoriteProcessing) return;

    setState(() {
      _isFavoriteProcessing = true;
    });

    try {
      if (_isFavorite) {
        // HAPUS FAVORIT
        await _supabase
            .from('favorit')
            .delete()
            .eq('id_user', user.id)
            .eq('id_destinasi', widget.destinasiId);

        if (!mounted) return;

        setState(() {
          _isFavorite = false;
        });

        _showMessage('Destinasi dihapus dari favorit.');
      } else {
        // PERIKSA APAKAH FAVORIT SUDAH ADA
        final existing = await _supabase
            .from('favorit')
            .select('id_destinasi')
            .eq('id_user', user.id)
            .eq('id_destinasi', widget.destinasiId)
            .limit(1);

        // TAMBAHKAN FAVORIT JIKA BELUM ADA
        if (existing.isEmpty) {
          await _supabase.from('favorit').insert({
            'id_user': user.id,
            'id_destinasi': widget.destinasiId,
            'tanggal_ditambah': DateTime.now().toUtc().toIso8601String(),
          });
        }

        if (!mounted) return;

        setState(() {
          _isFavorite = true;
        });

        _showMessage('Destinasi berhasil ditambahkan ke favorit.');
      }
    } catch (error) {
      debugPrint('Gagal memperbarui favorit: $error');

      if (!mounted) return;

      _showMessage('Gagal memperbarui favorit. Silakan coba kembali.');

      await _loadFavoriteStatus();
    } finally {
      if (mounted) {
        setState(() {
          _isFavoriteProcessing = false;
        });
      }
    }
  }

  // ==========================================
  // BUILD UTAMA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Detail Destinasi',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: darkColor,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: darkColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: FutureBuilder<DestinasiUserModel?>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (snapshot.hasError) {
            return _buildError();
          }

          final destinasi = snapshot.data;

          if (destinasi == null) {
            return _buildEmpty();
          }

          return _buildDetail(destinasi);
        },
      ),
    );
  }

  // ==========================================
  // DETAIL DESTINASI
  // ==========================================

  Widget _buildDetail(DestinasiUserModel destinasi) {
    final namaKategori = widget.controller.getNamaKategori(
      destinasi.idKategori,
    );

    final foto = destinasi.fotoUtama.trim();

    final hasPhoto = foto.isNotEmpty && foto.toLowerCase() != 'null';

    final deskripsi = _displayText(
      destinasi.deskripsi,
      'Belum ada deskripsi untuk destinasi ini.',
    );

    final alamat = _displayText(destinasi.alamat, 'Alamat belum tersedia.');

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 850;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 24 : 16,
            vertical: 20,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // FOTO UTAMA
                  _buildHero(
                    destinasi,
                    hasPhoto: hasPhoto,
                    foto: foto,
                    height: isWide ? 360 : 270,
                  ),

                  const SizedBox(height: 20),

                  // KATEGORI
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildCategoryChip(namaKategori),
                  ),

                  const SizedBox(height: 28),

                  // INFORMASI DESTINASI
                  if (isWide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _buildAboutSection(deskripsi)),
                        const SizedBox(width: 22),
                        Expanded(
                          flex: 5,
                          child: _buildLocationSection(destinasi, alamat),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAboutSection(deskripsi),
                        const SizedBox(height: 26),
                        _buildLocationSection(destinasi, alamat),
                      ],
                    ),

                  const SizedBox(height: 26),

                  // TOMBOL AKSI
                  _buildActionButtons(destinasi),

                  const SizedBox(height: 32),

                  // RATING DAN ULASAN PENGUNJUNG
                  _buildReviewSection(),

                  const SizedBox(height: 28),

                  // ID DESTINASI
                  _buildFooter(destinasi),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // RATING DAN ULASAN PENGUNJUNG
  // ==========================================

  Widget _buildReviewSection() {
    return AnimatedBuilder(
      animation: _ulasanController,
      builder: (context, _) {
        final loggedIn = _supabase.auth.currentUser != null;
        final myReview = _ulasanController.ulasanSaya;
        final noData =
            _ulasanController.ringkasanRating == null &&
            _ulasanController.listUlasan.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: _sectionTitle('Rating & Ulasan')),
                IconButton(
                  tooltip: 'Muat ulang ulasan',
                  onPressed: _ulasanController.isLoading ? null : _loadUlasan,
                  icon: const Icon(Icons.refresh, color: primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_ulasanController.isLoading && noData)
              const Padding(
                padding: EdgeInsets.all(28),
                child: Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
              )
            else if (_ulasanController.errorMessage != null && noData)
              _contentCard(
                child: Column(
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 36,
                      color: Color(0xFF94A3B8),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Rating dan ulasan belum dapat dimuat.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _ulasanController.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: textColor, fontSize: 12),
                    ),
                    TextButton.icon(
                      onPressed: _loadUlasan,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              )
            else ...[
              _buildRatingSummary(),
              const SizedBox(height: 16),

              if (loggedIn)
                _buildMyReviewActions(myReview)
              else
                _contentCard(
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, color: primaryColor),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Ulasan dapat dibaca tanpa login. Login diperlukan untuk memberikan ulasan.',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (_showReviewForm) ...[
                const SizedBox(height: 12),
                _buildReviewForm(),
              ],

              const SizedBox(height: 22),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Ulasan Pengunjung',
                      style: TextStyle(
                        color: darkColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${_ulasanController.jumlahUlasan} ulasan',
                    style: const TextStyle(color: textColor, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (_ulasanController.listUlasan.isEmpty)
                _buildEmptyReviews()
              else
                ..._ulasanController.listUlasan.map(
                  (review) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildReviewCard(review),
                  ),
                ),

              if (_ulasanController.errorMessage != null &&
                  _ulasanController.listUlasan.isNotEmpty)
                Text(
                  _ulasanController.errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
            ],
          ],
        );
      },
    );
  }

  // ==========================================
  // RINGKASAN RATING
  // ==========================================

  Widget _buildRatingSummary() {
    final average = _ulasanController.rataRataRating;
    final total = _ulasanController.jumlahUlasan;

    return _contentCard(
      child: Row(
        children: [
          SizedBox(
            width: 105,
            child: Column(
              children: [
                Text(
                  total == 0 ? '—' : average.toStringAsFixed(1),
                  style: const TextStyle(
                    color: darkColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStarRow(average, size: 16),
                const SizedBox(height: 5),
                Text(
                  '$total ulasan',
                  style: const TextStyle(color: textColor, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final star = 5 - index;
                final count = _ulasanController.jumlahRating(star);
                final fraction = _ulasanController.persentaseRating(star);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 12,
                        child: Text(
                          '$star',
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        color: Color(0xFFF5B942),
                        size: 14,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: fraction,
                            minHeight: 7,
                            backgroundColor: const Color(0xFFE9EEF5),
                            valueColor: const AlwaysStoppedAnimation(
                              Color(0xFFF5B942),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      SizedBox(
                        width: 22,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 11,
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

  // ==========================================
  // AKSI ULASAN PENGGUNA
  // ==========================================

  Widget _buildMyReviewActions(UlasanUserModel? myReview) {
    if (myReview == null) {
      return SizedBox(
        height: 48,
        child: ElevatedButton.icon(
          onPressed: _ulasanController.isSubmitting
              ? null
              : () => _openReviewForm(),
          icon: const Icon(Icons.rate_review_outlined),
          label: const Text('Tulis Ulasan'),
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

    return _contentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ulasan Anda',
            style: TextStyle(
              color: darkColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Anda sudah memberikan ulasan untuk destinasi ini.',
            style: TextStyle(color: textColor, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _ulasanController.isSubmitting
                    ? null
                    : () => _openReviewForm(ulasan: myReview),
                icon: const Icon(Icons.edit_outlined, size: 17),
                label: const Text('Edit Ulasan'),
              ),
              TextButton.icon(
                onPressed: _ulasanController.isSubmitting
                    ? null
                    : _deleteMyReview,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 17,
                ),
                label: const Text('Hapus', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MEMBUKA FORM ULASAN
  // ==========================================

  void _openReviewForm({UlasanUserModel? ulasan}) {
    if (_supabase.auth.currentUser == null) {
      _showMessage('Silakan login terlebih dahulu untuk menulis ulasan.');
      return;
    }

    setState(() {
      _isEditingReview = ulasan != null;
      _showReviewForm = true;
      _selectedRating = ulasan?.rating ?? 5;
      _komentarController.text = ulasan?.komentar ?? '';
    });
  }

  void _closeReviewForm() {
    setState(() {
      _showReviewForm = false;
      _isEditingReview = false;
      _selectedRating = 5;
      _komentarController.clear();
    });

    _ulasanController.clearError();
  }

  // ==========================================
  // MENYIMPAN ULASAN
  // ==========================================

  Future<void> _submitReview() async {
    if (_supabase.auth.currentUser == null) {
      _showMessage('Silakan login terlebih dahulu untuk menulis ulasan.');
      return;
    }

    final comment = _komentarController.text.trim();

    if (comment.isEmpty) {
      _showMessage('Komentar tidak boleh kosong.');
      return;
    }

    if (comment.length > 1000) {
      _showMessage('Komentar maksimal 1000 karakter.');
      return;
    }

    final myReview = _ulasanController.ulasanSaya;
    final editing = _isEditingReview && myReview != null;
    final bool success;

    if (_isEditingReview && myReview != null) {
      success = await _ulasanController.updateUlasan(
        idDestinasi: widget.destinasiId,
        idUlasan: myReview.idUlasan,
        rating: _selectedRating,
        komentar: comment,
      );
    } else {
      success = await _ulasanController.tambahUlasan(
        idDestinasi: widget.destinasiId,
        rating: _selectedRating,
        komentar: comment,
      );
    }

    if (!mounted) return;

    if (success) {
      setState(() {
        _showReviewForm = false;
        _isEditingReview = false;
        _selectedRating = 5;
        _komentarController.clear();
      });

      _showMessage(
        editing
            ? 'Ulasan berhasil diperbarui.'
            : 'Ulasan berhasil ditambahkan.',
      );
    } else {
      _showMessage(_ulasanController.errorMessage ?? 'Ulasan gagal disimpan.');
    }
  }

  // ==========================================
  // MENGHAPUS ULASAN
  // ==========================================

  Future<void> _deleteMyReview() async {
    final review = _ulasanController.ulasanSaya;

    if (review == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Ulasan?'),
        content: const Text(
          'Ulasan yang dihapus tidak akan ditampilkan lagi. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (!mounted || confirm != true) return;

    final success = await _ulasanController.hapusUlasan(
      idDestinasi: widget.destinasiId,
      idUlasan: review.idUlasan,
    );

    if (!mounted) return;

    _showMessage(
      success
          ? 'Ulasan berhasil dihapus.'
          : (_ulasanController.errorMessage ?? 'Ulasan gagal dihapus.'),
    );
  }

  // ==========================================
  // FORM INPUT ULASAN
  // ==========================================

  Widget _buildReviewForm() {
    return _contentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isEditingReview ? 'Edit Ulasan' : 'Tulis Ulasan',
            style: const TextStyle(
              color: darkColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Bagaimana pengalaman Anda mengunjungi destinasi ini?',
            style: TextStyle(color: textColor, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => IconButton(
                tooltip: '${index + 1} bintang',
                onPressed: _ulasanController.isSubmitting
                    ? null
                    : () => setState(() => _selectedRating = index + 1),
                icon: Icon(
                  index < _selectedRating ? Icons.star : Icons.star_border,
                  color: const Color(0xFFF5B942),
                  size: 32,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              '$_selectedRating dari 5 bintang',
              style: const TextStyle(
                color: darkColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _komentarController,
            minLines: 3,
            maxLines: 4,
            maxLength: 1000,
            enabled: !_ulasanController.isSubmitting,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Ceritakan pengalaman Anda...',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor),
              ),
            ),
          ),
          if (_ulasanController.errorMessage != null)
            Text(
              _ulasanController.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _ulasanController.isSubmitting
                      ? null
                      : _closeReviewForm,
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _ulasanController.isSubmitting
                      ? null
                      : _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: _ulasanController.isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_isEditingReview ? 'Simpan' : 'Kirim Ulasan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // KARTU ULASAN PENGUNJUNG
  // ==========================================

  Widget _buildReviewCard(UlasanUserModel review) {
    return _contentCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildReviewerAvatar(review),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.namaPengguna,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: darkColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatReviewDate(review.tanggalDitambah),
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              _buildStarRow(review.rating.toDouble(), size: 13),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.komentar,
            style: const TextStyle(color: textColor, fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FOTO PROFIL PENGULAS
  // ==========================================

  Widget _buildReviewerAvatar(UlasanUserModel review) {
    final photo = review.fotoProfil?.trim();

    if (photo != null && photo.isNotEmpty && photo.toLowerCase() != 'null') {
      return ClipOval(
        child: Image.network(
          photo,
          width: 42,
          height: 42,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _defaultReviewerAvatar(review.namaPengguna),
        ),
      );
    }

    return _defaultReviewerAvatar(review.namaPengguna);
  }

  Widget _defaultReviewerAvatar(String name) {
    final initial = name.trim().isEmpty ? 'P' : name.trim()[0].toUpperCase();

    return CircleAvatar(
      radius: 21,
      backgroundColor: lightBlueColor,
      child: Text(
        initial,
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ==========================================
  // BINTANG RATING
  // ==========================================

  Widget _buildStarRow(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final value = index + 1;

        final icon = rating >= value
            ? Icons.star
            : rating >= value - 0.5
            ? Icons.star_half
            : Icons.star_border;

        return Icon(icon, color: const Color(0xFFF5B942), size: size);
      }),
    );
  }

  // ==========================================
  // ULASAN KOSONG
  // ==========================================

  Widget _buildEmptyReviews() {
    return _contentCard(
      child: const Column(
        children: [
          Icon(Icons.rate_review_outlined, size: 36, color: Color(0xFF94A3B8)),
          SizedBox(height: 8),
          Text(
            'Belum ada ulasan',
            style: TextStyle(color: darkColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'Jadilah pengunjung pertama yang memberikan rating dan ulasan untuk destinasi ini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // FORMAT TANGGAL ULASAN
  // ==========================================

  String _formatReviewDate(DateTime date) {
    final local = date.toLocal();

    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/${local.year}';
  }

  // ==========================================
  // HERO FOTO DESTINASI
  // ==========================================

  Widget _buildHero(
    DestinasiUserModel destinasi, {
    required bool hasPhoto,
    required String foto,
    required double height,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // FOTO
            if (hasPhoto)
              Image.network(
                foto,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return _imagePlaceholder(loading: true);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _imagePlaceholder();
                },
              )
            else
              _imagePlaceholder(),

            // GRADASI FOTO
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.72),
                  ],
                  stops: const [0, 0.4, 1],
                ),
              ),
            ),

            // TOMBOL BAGIKAN DAN FAVORIT
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  _heroIconButton(
                    icon: Icons.share_outlined,
                    tooltip: 'Salin informasi',
                    onPressed: () => _copyLocationInfo(destinasi),
                  ),

                  const SizedBox(width: 10),

                  _heroIconButton(
                    icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                    tooltip: _isFavorite
                        ? 'Hapus dari favorit'
                        : 'Tambah ke favorit',
                    onPressed: _toggleFavorite,
                    iconColor: _isFavorite ? Colors.red : darkColor,
                    isLoading: _isFavoriteLoading || _isFavoriteProcessing,
                  ),
                ],
              ),
            ),

            // NAMA DESTINASI
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Text(
                destinasi.namaDestinasi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TOMBOL ICON PADA FOTO
  // ==========================================

  Widget _heroIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    Color iconColor = darkColor,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 19,
                height: 19,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              )
            : Icon(icon, color: iconColor, size: 21),
        style: IconButton.styleFrom(fixedSize: const Size(46, 46)),
      ),
    );
  }

  // ==========================================
  // KATEGORI DESTINASI
  // ==========================================

  Widget _buildCategoryChip(String kategori) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: lightBlueColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.category_outlined, color: primaryColor, size: 19),
          const SizedBox(width: 9),
          Text(
            kategori,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // BAGIAN TENTANG DESTINASI
  // ==========================================

  Widget _buildAboutSection(String deskripsi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Tentang Destinasi'),
        const SizedBox(height: 14),
        _contentCard(
          child: Text(
            deskripsi,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 15, height: 1.8, color: textColor),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // BAGIAN LOKASI DESTINASI
  // ==========================================

  Widget _buildLocationSection(DestinasiUserModel destinasi, String alamat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Lokasi Destinasi'),
        const SizedBox(height: 14),
        _contentCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ALAMAT
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: primaryColor,
                    size: 26,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alamat',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: darkColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          alamat,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.7,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 32, color: Color(0xFFE2E8F0)),

              // KOORDINAT
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _coordinateItem('Latitude', destinasi.latitude),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _coordinateItem('Longitude', destinasi.longitude),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // INFORMASI KOORDINAT
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Koordinat digunakan untuk menunjukkan lokasi destinasi pada Google Maps.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: Colors.blueGrey.shade400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TOMBOL AKSI
  // ==========================================

  Widget _buildActionButtons(DestinasiUserModel destinasi) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final validCoordinates = _hasValidCoordinates(destinasi);

        final mapButton = SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: validCoordinates
                ? () => _openGoogleMaps(destinasi)
                : null,
            icon: const Icon(Icons.directions_outlined, size: 22),
            label: const Text(
              'Lihat Rute',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFCBD5E1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        );

        final copyButton = SizedBox(
          height: 54,
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _copyLocationInfo(destinasi),
            icon: const Icon(Icons.copy_outlined, size: 20),
            label: const Text(
              'Salin Informasi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: const BorderSide(color: primaryColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        );

        // LAYAR KECIL
        if (constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [mapButton, const SizedBox(height: 12), copyButton],
          );
        }

        // LAYAR BESAR
        return Row(
          children: [
            Expanded(child: mapButton),
            const SizedBox(width: 15),
            Expanded(child: copyButton),
          ],
        );
      },
    );
  }

  // ==========================================
  // INFORMASI KOORDINAT
  // ==========================================

  Widget _coordinateItem(String label, double value) {
    final coordinate = value.isFinite
        ? value.toStringAsFixed(6)
        : 'Tidak tersedia';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 8),
        Text(
          coordinate,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: darkColor,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // JUDUL SECTION
  // ==========================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: darkColor,
      ),
    );
  }

  // ==========================================
  // KARTU KONTEN
  // ==========================================

  Widget _contentCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  // ==========================================
  // FOOTER DETAIL
  // ==========================================

  Widget _buildFooter(DestinasiUserModel destinasi) {
    return Center(
      child: Text(
        'ID Destinasi: ${destinasi.idDestinasi}',
        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
      ),
    );
  }

  // ==========================================
  // PLACEHOLDER FOTO
  // ==========================================

  Widget _imagePlaceholder({bool loading = false}) {
    return Container(
      color: const Color(0xFFE0E7EE),
      child: Center(
        child: loading
            ? const CircularProgressIndicator(color: primaryColor)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.image_not_supported_outlined,
                    size: 55,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Foto destinasi belum tersedia',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blueGrey.shade500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ==========================================
  // TAMPILAN ERROR
  // ==========================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 65,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 18),
            const Text(
              'Gagal Memuat Detail Destinasi',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Periksa koneksi internet dan coba kembali.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: textColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _retry,
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

  // ==========================================
  // TAMPILAN DATA KOSONG
  // ==========================================

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_outlined,
              size: 65,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 18),
            const Text(
              'Destinasi Tidak Ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Data destinasi mungkin sudah tidak tersedia atau telah dinonaktifkan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, height: 1.5, color: textColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali'),
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
}