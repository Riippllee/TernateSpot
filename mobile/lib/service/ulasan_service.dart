import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/ulasan_model.dart';

class UlasanService {
  // Mengambil koneksi Supabase dari main.dart
  final supabase = Supabase.instance.client;

  // READ: Mengambil ulasan aktif beserta profil pengguna
  Future<List<Ulasan>> getUlasan(int idDestinasi) async {
    final data = await supabase
        .from('ulasan')
        .select('''
  *,
  user:user!ulasan_id_user_fkey (
    nama,
    foto_profil
  )
''')
        .eq('status', true)
        .eq('id_destinasi', idDestinasi)
        .order('tanggal_ditambah', ascending: false);

    // Cek hasil pengambilan data
    print('DATA ULASAN: $data');
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
