import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/ulasan_user_model.dart';

// =====================================================
// MODEL RINGKASAN RATING
// =====================================================

class RingkasanRating {
  final double rataRata;
  final int jumlahUlasan;
  final Map<int, int> distribusiRating;

  const RingkasanRating({
    required this.rataRata,
    required this.jumlahUlasan,
    required this.distribusiRating,
  });
}

// =====================================================
// ULASAN USER SERVICE
// =====================================================

class UlasanUserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =====================================================
  // MENGAMBIL ULASAN BERDASARKAN DESTINASI
  // =====================================================

  Future<List<UlasanUserModel>> getUlasanByDestinasi(int idDestinasi) async {
    final response = await _supabase
        .from('ulasan')
        .select(
          'id_ulasan, id_user, id_destinasi, rating, '
          'komentar, status, tanggal_ditambah, '
          'tanggal_perubahan',
        )
        .eq('id_destinasi', idDestinasi)
        .eq('status', true)
        .order('tanggal_ditambah', ascending: false);

    final rows = response
        .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
        .toList();

    return _buatModelDenganProfil(rows);
  }

  // =====================================================
  // MENGAMBIL PROFIL PENGULAS DARI VIEW PUBLIK
  // =====================================================

  Future<List<UlasanUserModel>> _buatModelDenganProfil(
    List<Map<String, dynamic>> rows,
  ) async {
    if (rows.isEmpty) {
      return [];
    }

    final userIds = rows
        .map((item) => item['id_user']?.toString())
        .where((id) => id != null && id.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();

    final Map<String, Map<String, dynamic>> profilByUserId = {};

    if (userIds.isNotEmpty) {
      try {
        // Mengambil profil dari View yang hanya
        // menyediakan informasi publik pengulas.
        final response = await _supabase
            .from('profil_pengulas')
            .select('id_user, nama, foto_profil')
            .inFilter('id_user', userIds);

        for (final item in response) {
          final profil = Map<String, dynamic>.from(item);

          final userId = profil['id_user']?.toString();

          if (userId != null) {
            profilByUserId[userId] = profil;
          }
        }
      } catch (e) {
        // Ulasan tetap ditampilkan meskipun profil
        // tidak berhasil diambil.
        profilByUserId.clear();
      }
    }

    return rows.map((item) {
      final userId = item['id_user']?.toString() ?? '';

      return UlasanUserModel.fromJson({
        ...item,
        'profil': profilByUserId[userId],
      });
    }).toList();
  }

  // =====================================================
  // MENGHITUNG RINGKASAN RATING
  // =====================================================

  Future<RingkasanRating> getRingkasanRating(int idDestinasi) async {
    final response = await _supabase
        .from('ulasan')
        .select('rating')
        .eq('id_destinasi', idDestinasi)
        .eq('status', true);

    final distribusi = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    int totalRating = 0;
    int jumlahUlasan = 0;

    for (final item in response) {
      final rating = (item['rating'] as num).toInt();

      if (rating >= 1 && rating <= 5) {
        totalRating += rating;
        jumlahUlasan++;

        distribusi[rating] = distribusi[rating]! + 1;
      }
    }

    final rataRata = jumlahUlasan == 0 ? 0.0 : totalRating / jumlahUlasan;

    return RingkasanRating(
      rataRata: rataRata,
      jumlahUlasan: jumlahUlasan,
      distribusiRating: distribusi,
    );
  }

  // =====================================================
  // MENGAMBIL ULASAN MILIK PENGGUNA
  // =====================================================

  Future<UlasanUserModel?> getUlasanSaya(int idDestinasi) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      return null;
    }

    final response = await _supabase
        .from('ulasan')
        .select(
          'id_ulasan, id_user, id_destinasi, rating, '
          'komentar, status, tanggal_ditambah, '
          'tanggal_perubahan',
        )
        .eq('id_destinasi', idDestinasi)
        .eq('id_user', user.id)
        .eq('status', true)
        .order('tanggal_ditambah', ascending: false)
        .limit(1);

    final rows = response
        .map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item))
        .toList();

    final hasil = await _buatModelDenganProfil(rows);

    return hasil.isEmpty ? null : hasil.first;
  }

  // =====================================================
  // MENAMBAHKAN ULASAN
  // =====================================================

  Future<void> tambahUlasan({
    required int idDestinasi,
    required int rating,
    required String komentar,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu.');
    }

    _validasiRating(rating);
    _validasiKomentar(komentar);

    // Mencegah ulasan aktif ganda.
    final existing = await _supabase
        .from('ulasan')
        .select('id_ulasan')
        .eq('id_destinasi', idDestinasi)
        .eq('id_user', user.id)
        .eq('status', true)
        .limit(1)
        .maybeSingle();

    if (existing != null) {
      throw Exception(
        'Kamu sudah memberikan ulasan. '
        'Silakan edit ulasan sebelumnya.',
      );
    }

    final sekarang = DateTime.now().toUtc().toIso8601String();

    await _supabase.from('ulasan').insert({
      'id_user': user.id,
      'id_destinasi': idDestinasi,
      'rating': rating,
      'komentar': komentar.trim(),
      'status': true,
      'tanggal_ditambah': sekarang,
      'tanggal_perubahan': sekarang,
    });
  }

  // =====================================================
  // MEMPERBARUI ULASAN
  // =====================================================

  Future<void> updateUlasan({
    required int idUlasan,
    required int rating,
    required String komentar,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu.');
    }

    _validasiRating(rating);
    _validasiKomentar(komentar);

    final response = await _supabase
        .from('ulasan')
        .update({
          'rating': rating,
          'komentar': komentar.trim(),
          'tanggal_perubahan': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id_ulasan', idUlasan)
        .eq('id_user', user.id)
        .eq('status', true)
        .select('id_ulasan');

    if (response.isEmpty) {
      throw Exception('Ulasan tidak ditemukan atau tidak dapat diperbarui.');
    }
  }

  // =====================================================
  // MENGHAPUS ULASAN
  // =====================================================

  Future<void> hapusUlasan(int idUlasan) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu.');
    }

    final response = await _supabase
        .from('ulasan')
        .delete()
        .eq('id_ulasan', idUlasan)
        .eq('id_user', user.id)
        .select('id_ulasan');

    if (response.isEmpty) {
      throw Exception('Ulasan tidak ditemukan atau tidak dapat dihapus.');
    }
  }

  // =====================================================
  // VALIDASI RATING
  // =====================================================

  void _validasiRating(int rating) {
    if (rating < 1 || rating > 5) {
      throw Exception('Rating harus antara 1 sampai 5.');
    }
  }

  // =====================================================
  // VALIDASI KOMENTAR
  // =====================================================

  void _validasiKomentar(String komentar) {
    final komentarBersih = komentar.trim();

    if (komentarBersih.isEmpty) {
      throw Exception('Komentar tidak boleh kosong.');
    }

    if (komentarBersih.length > 1000) {
      throw Exception('Komentar maksimal 1000 karakter.');
    }
  }
}
