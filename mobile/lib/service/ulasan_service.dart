import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/ulasan_model.dart';

class UlasanService {
  // koneksi ke Supabase

  final supabase = Supabase.instance.client;

  // READ ULASAN
  Future<List<Ulasan>> getUlasan() async {
    final data = await supabase.from('ulasan').select();

    // Mengubah data JSON > objek Ulasan
    return data.map((e) => Ulasan.fromJson(e)).toList();
  }

  // CREATE ULASAN
  Future<void> tambahUlasan(Ulasan ulasan) async {
    await supabase.from('ulasan').insert(ulasan.toJson());
  }

  // UPDATE ULASAN
  Future<void> updateUlasan(Ulasan ulasan) async {
    await supabase
        .from('ulasan')
        .update(ulasan.toJson())
        .eq('id_ulasan', ulasan.idUlasan!);
  }

  // DELETE ULASAN
  Future<void> hapusUlasan(int id) async {
    await supabase.from('ulasan').delete().eq('id_ulasan', id);
  }
}
