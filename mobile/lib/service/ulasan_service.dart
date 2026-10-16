import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/ulasan_model.dart';

class UlasanService {
  // Mengambil koneksi Supabase dari main.dart
  final supabase = Supabase.instance.client;

  // READ: melihat ulasan aktif dan ulasan sendiri
  Future<List<Ulasan>> getUlasan() async {
    final user = supabase.auth.currentUser;

    final query = supabase.from('ulasan').select();

    final data = user == null
        ? await query.eq('status', true)
        : await query.or('status.eq.true,id_user.eq.${user.id}');

    // Mengubah JSON menjadi List objek Ulasan
    return data.map((e) => Ulasan.fromJson(e)).toList();
  }

  // CREATE: menambahkan ulasan milik user login
  Future<void> tambahUlasan({
    required int idDestinasi,
    required int rating,
    required String komentar,
  }) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu');
    }

    await supabase.from('ulasan').insert({
      'id_user': user.id,
      'id_destinasi': idDestinasi,
      'rating': rating,
      'komentar': komentar,
      'status': true,
    });
  }

  // UPDATE: mengubah ulasan milik sendiri
  Future<void> updateUlasan(Ulasan ulasan) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu');
    }

    await supabase
        .from('ulasan')
        .update({
          'rating': ulasan.rating,
          'komentar': ulasan.komentar,
          'tanggal_perubahan': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('id_ulasan', ulasan.idUlasan!)
        .eq('id_user', user.id);
  }

  // DELETE: menghapus ulasan milik sendiri
  Future<void> hapusUlasan(int idUlasan) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu');
    }

    await supabase
        .from('ulasan')
        .delete()
        .eq('id_ulasan', idUlasan)
        .eq('id_user', user.id);
  }
}
