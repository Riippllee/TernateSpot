import 'package:flutter/material.dart';

import '../../../controllers/rekomendasi_controller.dart';
import '../../../models/destinasi_model.dart';
import '../../../models/rekomendasi_model.dart';

// Sinyal sederhana di dalam file yang sudah ada; tidak perlu file Notifier baru.
class RekomendasiHomeSignal {
  static final ValueNotifier<int> version = ValueNotifier<int>(0);

  static void notifyUpdated() {
    version.value++;
  }
}

class RekomendasiDestinasiPage extends StatefulWidget {
  const RekomendasiDestinasiPage({super.key});

  @override
  State<RekomendasiDestinasiPage> createState() =>
      _RekomendasiDestinasiPageState();
}

class _RekomendasiDestinasiPageState extends State<RekomendasiDestinasiPage> {
  final RekomendasiController _controller = RekomendasiController();
  bool _isPublishing = false;

  // Data diurutkan di halaman ini agar tidak bergantung pada getter tambahan
  // di RekomendasiController.
  List<RekomendasiModel> get _rekomendasiTerurut {
    final daftar = List<RekomendasiModel>.from(_controller.rekomendasi);
    daftar.sort((a, b) => a.prioritas.compareTo(b.prioritas));
    return daftar;
  }

  List<RekomendasiModel> get _rekomendasiDraft {
    return _controller.rekomendasi.where((item) => !item.status).toList();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(_onControllerChanged);

    _controller.loadRekomendasi();
    _controller.loadDestinasi();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _publikasikanDraft() async {
    if (_isPublishing) return;

    if (_rekomendasiDraft.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Belum ada rekomendasi Draft untuk dipublikasikan.'),
        ),
      );
      return;
    }

    setState(() => _isPublishing = true);

    try {
      // Publikasikan setiap Draft menggunakan method ubahStatus yang
      // memang tersedia pada controller saat ini.
      final draftUntukDipublikasikan = List<RekomendasiModel>.from(
        _rekomendasiDraft,
      );

      for (final item in draftUntukDipublikasikan) {
        final id = item.idRekomendasi;
        if (id == null) {
          throw Exception('ID rekomendasi tidak ditemukan.');
        }
        await _controller.ubahStatus(id, true);
      }

      // Beri tahu HomePage agar mengambil ulang rekomendasi Published.
      RekomendasiHomeSignal.notifyUpdated();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Rekomendasi berhasil dipublikasikan dan disinkronkan ke beranda.',
          ),
          backgroundColor: Color(0xFF16834A),
        ),
      );

      // Kembali ke halaman sebelumnya (Dashboard) setelah publikasi berhasil.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mempublikasikan rekomendasi: $e')),
      );
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_controller.listDestinasi.length} Destinasi Total',
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Slot Status Card
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
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0066FF),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'PUBLIC',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.cloud_done_outlined,
                              size: 12,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Sinkron Otomatis',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${_controller.jumlahRekomendasiAktif} ',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const TextSpan(
                                  text: '/ 6',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_rekomendasiDraft.length} Draft menunggu publikasi',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _isPublishing || _rekomendasiDraft.isEmpty
                            ? null
                            : _publikasikanDraft,
                        icon: const Icon(
                          Icons.file_upload_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          _isPublishing ? 'Memublikasikan...' : 'Publikasikan',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0066FF),
                          disabledBackgroundColor: Colors.grey.shade300,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_controller.jumlahRekomendasiAktif / 6)
                          .clamp(0.0, 1.0)
                          .toDouble(),
                      minHeight: 6,
                      backgroundColor: Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0066FF),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Grid Items Rekomendasi
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.88,
              ),
              itemCount: _rekomendasiTerurut.length,
              itemBuilder: (context, index) {
                final rekomendasi = _rekomendasiTerurut[index];

                final hasil = _controller.listDestinasi.where(
                  (item) => item.idDestinasi == rekomendasi.idDestinasi,
                );

                if (hasil.isEmpty) {
                  return const SizedBox.shrink();
                }

                final destinasi = hasil.first;

                return _buildGridItem(
                  destinasi,
                  rekomendasi.prioritas,
                  rekomendasi.idRekomendasi!,
                  index,
                  _rekomendasiTerurut.length,
                  rekomendasi.status,
                );
              },
            ),

            const SizedBox(height: 16),

            // Banner Notification SnackBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0052CC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Danau Toba berhasil dipasang ke Slo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'URUNGKAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.close, color: Colors.white, size: 16),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section Katalog Destinasi Tersedia Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.crop_landscape_rounded,
                      color: Color(0xFF0066FF),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Katalog Destinasi Tersedia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '42 Destinasi Total',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Category Horizontal Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip('Semua', true),
                  _buildChip('Populer', false),
                  _buildChip('Bahari', false),
                  _buildChip('Budaya', false),
                  _buildChip('Gunung', false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Katalog destinasi dari Supabase
            if (_controller.isLoadingDestinasi)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: Color(0xFF0066FF)),
                ),
              )
            else if (_controller.listDestinasi.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: Text('Belum ada destinasi tersedia.')),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _controller.listDestinasi
                    .where((item) => item.status)
                    .length,
                itemBuilder: (context, index) {
                  final daftarDestinasi = _controller.listDestinasi
                      .where((item) => item.status)
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildKatalogItem(daftarDestinasi[index]),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
    DestinasiModel destinasi,
    int prioritas,
    int idRekomendasi,
    int index,
    int totalRekomendasi,
    bool isPublished,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDF2F7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: destinasi.fotoUtama.isNotEmpty
                      ? Image.network(
                          destinasi.fotoUtama,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _gambarTidakTersedia();
                          },
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;

                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF0066FF),
                              ),
                            );
                          },
                        )
                      : _gambarTidakTersedia(),
                ),

                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$prioritas Rekomendasi',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isPublished
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      isPublished ? 'Published' : 'Draft',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isPublished
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFEF6C00),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Text(
                    destinasi.namaDestinasi,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black87)],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    destinasi.alamat,
                    style: const TextStyle(fontSize: 9, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 24,
                      ),
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      onPressed: index == 0
                          ? null
                          : () => _prosesTukarPrioritas(index, index - 1),
                      icon: const Icon(Icons.keyboard_arrow_up_rounded),
                      color: const Color(0xFF0066FF),
                      disabledColor: Colors.grey.shade300,
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 24,
                      ),
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      onPressed: index == totalRekomendasi - 1
                          ? null
                          : () => _prosesTukarPrioritas(index, index + 1),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      color: const Color(0xFF0066FF),
                      disabledColor: Colors.grey.shade300,
                    ),
                  ],
                ),

                const SizedBox(width: 4),
                InkWell(
                  onTap: () async {
                    final konfirmasi = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Rekomendasi?'),
                        content: Text(
                          'Hapus ${destinasi.namaDestinasi} dari rekomendasi?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text(
                              'Hapus',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );

                    if (konfirmasi == true) {
                      try {
                        await _controller.hapusRekomendasi(idRekomendasi);

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rekomendasi berhasil dihapus.'),
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal menghapus: $e')),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gambarTidakTersedia() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFEAF0F6),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 36,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildKatalogItem(DestinasiModel destinasi) {
    final sudahDipilih = _controller.rekomendasi.any(
      (item) => item.idDestinasi == destinasi.idDestinasi,
    );

    final slotPenuh = _controller.slotPenuh;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDF2F7)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: destinasi.fotoUtama.isNotEmpty
                ? Image.network(
                    destinasi.fotoUtama,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _gambarTidakTersedia(),
                  )
                : SizedBox(
                    width: 85,
                    height: 85,
                    child: _gambarTidakTersedia(),
                  ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destinasi.namaDestinasi,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  destinasi.alamat,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 32,
                  child: ElevatedButton(
                    onPressed: sudahDipilih || slotPenuh
                        ? null
                        : () async {
                            try {
                              await _controller.tambahRekomendasi(
                                destinasi.idDestinasi,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${destinasi.namaDestinasi} berhasil ditambahkan.',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Gagal menambahkan: $e'),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      disabledBackgroundColor: Colors.grey.shade200,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    child: Text(
                      sudahDipilih
                          ? 'Sudah Dipilih'
                          : slotPenuh
                          ? 'Slot Penuh'
                          : '+ Jadikan Rekomendasi',
                      style: TextStyle(
                        fontSize: 10,
                        color: sudahDipilih || slotPenuh
                            ? Colors.grey
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _prosesTukarPrioritas(int indexPertama, int indexKedua) async {
    try {
      await _controller.tukarPrioritas(indexPertama, indexKedua);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Urutan rekomendasi berhasil diperbarui.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mengubah urutan: $e')));
    }
  }

  Widget _buildChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0066FF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0066FF) : Colors.grey.shade200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
