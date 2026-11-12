import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewAdminService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil seluruh ulasan beserta data pengguna dan destinasi.
  Future<List<Map<String, dynamic>>> getAllUlasan() async {
    try {
      final response = await _supabase
          .from('ulasan')
          .select('''
            id_ulasan,
            id_user,
            id_destinasi,
            rating,
            komentar,
            status,
            tanggal_ditambah,
            tanggal_perubahan,
            user (
              nama,
              email,
              foto_profil
            ),
            destinasi (
              nama_destinasi,
              foto_utama
            )
          ''')
          .order('tanggal_ditambah', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('ERROR GET ULASAN: $e');
      throw Exception('Gagal mengambil data ulasan: $e');
    }
  }

  // Mengambil jumlah seluruh ulasan.
  Future<int> getTotalUlasan() async {
    try {
      final response = await _supabase.from('ulasan').select('id_ulasan');

      return response.length;
    } catch (e) {
      throw Exception('Gagal menghitung ulasan: $e');
    }
  }

  // Mengambil jumlah ulasan berdasarkan rating.
  Future<int> getJumlahUlasanByRating(int rating) async {
    try {
      final response = await _supabase
          .from('ulasan')
          .select('id_ulasan')
          .eq('rating', rating);

      return response.length;
    } catch (e) {
      throw Exception('Gagal menghitung rating: $e');
    }
  }

  // Menghapus ulasan berdasarkan ID.
  Future<void> deleteUlasan(int idUlasan) async {
    try {
      await _supabase.from('ulasan').delete().eq('id_ulasan', idUlasan);
    } catch (e) {
      throw Exception('Gagal menghapus ulasan: $e');
    }
  }

  // Mengubah status publikasi ulasan.
  // true = ditampilkan, false = disembunyikan.
  Future<void> updateStatusUlasan({
    required int idUlasan,
    required bool status,
  }) async {
    try {
      await _supabase
          .from('ulasan')
          .update({
            'status': status,
            'tanggal_perubahan': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id_ulasan', idUlasan);
    } catch (e) {
      debugPrint('ERROR UPDATE ULASAN: $e');
      throw Exception('Gagal mengubah status ulasan: $e');
    }
  }
}
