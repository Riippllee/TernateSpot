import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/favorit_model.dart';

// Service untuk mengelola data favorit di Supabase
class FavoritService {
  // Mengambil koneksi Supabase dari main.dart
  final supabase = Supabase.instance.client;

  // READ: mengambil favorit milik user yang sedang login
  Future<List<Favorit>> getFavorit() async {
    final user = supabase.auth.currentUser;

    // User harus login untuk melihat favorit
    if (user == null) {
      throw Exception('Silakan login terlebih dahulu');
    }

    final data = await supabase
        .from('favorit')
        .select()
        .eq('id_user', user.id)
        .order('tanggal_ditambah', ascending: false);

    // Mengubah data JSON menjadi objek Favorit
    return data.map((e) => Favorit.fromJson(e)).toList();
  }

  // CREATE: menambahkan destinasi ke favorit user
  Future<void> tambahFavorit(int idDestinasi) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu');
    }

    await supabase.from('favorit').insert({
      'id_user': user.id,
      'id_destinasi': idDestinasi,
    });
  }

  // DELETE: menghapus favorit berdasarkan ID favorit
  Future<void> hapusFavorit(int idFavorit) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('Silakan login terlebih dahulu');
    }

    await supabase
        .from('favorit')
        .delete()
        .eq('id_favorit', idFavorit)
        .eq('id_user', user.id);
  }
}
