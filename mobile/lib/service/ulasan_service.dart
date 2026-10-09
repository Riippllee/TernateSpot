import 'package:supabase_flutter/supabase_flutter.dart';

// Mengambil model ulasan
import '../model/ulasan_model.dart';

class UlasanService {
  // koneksi ke Supabase

  final supabase = Supabase.instance.client;

  // ==========================
  // READ ULASAN
  // ==========================
  //
  // Mengambil semua data ulasan
  // dari tabel ulasan

  Future<List<Ulasan>> getUlasan() async {
    final data = await supabase.from('ulasan').select();

    // Mengubah data JSON
    // menjadi object Ulasan

    return data.map((e) => Ulasan.fromJson(e)).toList();
  }

  // ==========================
  // CREATE ULASAN
  // ==========================
  //
  // User membuat ulasan baru

  Future<void> tambahUlasan(Ulasan ulasan) async {
    await supabase.from('ulasan').insert(ulasan.toJson());
  }

  // ==========================
  // UPDATE ULASAN
  // ==========================
  //
  // User mengubah ulasan miliknya

  Future<void> updateUlasan(Ulasan ulasan) async {
    await supabase
        .from('ulasan')
        .update(ulasan.toJson())
        .eq('id_ulasan', ulasan.idUlasan!);
  }

  // ==========================
  // DELETE ULASAN
  // ==========================
  //
  // Menghapus ulasan berdasarkan id

  Future<void> hapusUlasan(int id) async {
    await supabase.from('ulasan').delete().eq('id_ulasan', id);
  }
}
