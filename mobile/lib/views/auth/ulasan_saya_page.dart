import 'package:flutter/material.dart';

import '../../controllers/ulasan_user_controller.dart';
import '../../models/ulasan_user_model.dart';

class UlasanSayaPage extends StatefulWidget {
  const UlasanSayaPage({super.key});

  @override
  State<UlasanSayaPage> createState() => _UlasanSayaPageState();
}

class _UlasanSayaPageState extends State<UlasanSayaPage> {
  late final UlasanUserController _controller;

  static const Color warnaBiru = Color(0xFF0875F9);
  static const Color warnaLatar = Color(0xFFF5F7FC);
  static const Color warnaTeks = Color(0xFF202B3C);
  static const Color warnaAbu = Color(0xFF8A94A6);

  @override
  void initState() {
    super.initState();

    _controller = UlasanUserController();
    _controller.loadUlasanSaya();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatTanggal(DateTime tanggal) {
    final t = tanggal.toLocal();

    final hari = t.day.toString().padLeft(2, '0');
    final bulan = t.month.toString().padLeft(2, '0');
    final tahun = t.year;

    return '$hari/$bulan/$tahun';
  }

  Widget buildRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: const Color(0xFFFFB800),
          size: 19,
        );
      }),
    );
  }

  Widget buildKartuUlasan(UlasanUserModel ulasan) {
    final foto = ulasan.fotoProfil?.trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFE5EDFF),
                backgroundImage: foto != null && foto.isNotEmpty
                    ? NetworkImage(foto)
                    : null,
                child: foto == null || foto.isEmpty
                    ? const Icon(Icons.person, color: warnaBiru)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ulasan.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: warnaTeks,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      formatTanggal(ulasan.tanggalDitambah),
                      style: const TextStyle(color: warnaAbu, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF18A879),
                size: 19,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            ulasan.namaDestinasi,
            style: const TextStyle(
              color: warnaBiru,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 8),

          buildRating(ulasan.rating),

          const SizedBox(height: 12),

          Text(
            ulasan.komentar,
            style: const TextStyle(color: warnaTeks, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget buildIsiHalaman() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (_controller.isLoading && _controller.listUlasanSaya.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: warnaBiru),
          );
        }

        if (_controller.errorMessage != null &&
            _controller.listUlasanSaya.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 45),
                  const SizedBox(height: 12),
                  const Text(
                    'Gagal memuat ulasan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: warnaTeks,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _controller.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: warnaAbu, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _controller.loadUlasanSaya,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        if (_controller.listUlasanSaya.isEmpty) {
          return RefreshIndicator(
            onRefresh: _controller.refreshUlasanSaya,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Icon(
                  Icons.rate_review_outlined,
                  size: 65,
                  color: Color(0xFFB8C5D8),
                ),
                SizedBox(height: 18),
                Center(
                  child: Text(
                    'Belum Ada Ulasan',
                    style: TextStyle(
                      color: warnaTeks,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: Text(
                    'Ulasan destinasi yang kamu berikan akan muncul di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: warnaAbu,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            if (_controller.isLoading)
              const LinearProgressIndicator(color: warnaBiru, minHeight: 2),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _controller.refreshUlasanSaya,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 25),
                  itemCount: _controller.listUlasanSaya.length,
                  itemBuilder: (context, index) {
                    return buildKartuUlasan(_controller.listUlasanSaya[index]);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: warnaLatar,
      appBar: AppBar(
        backgroundColor: warnaBiru,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Ulasan Saya',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      body: SafeArea(child: buildIsiHalaman()),
    );
  }
}
