import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/rekomendasi_model.dart';

class RekomendasiService {
  // Mengambil koneksi Supabase yang sudah dibuat di main.dart
  final supabase = Supabase.instance.client;

  // Mengambil data dari tabel rekomendasi
  Future<List<Rekomendasi>> getRekomendasi() async {
    final data = await supabase.from('rekomendasi').select();

    // data supabase berupa JSON jadi objek Rekomendasi di dart
    return data.map((e) => Rekomendasi.fromJson(e)).toList();
  }

  //tambah rekomendasi
  Future<void> tambahRekomendasi(Rekomendasi rekomendasi) async {
    await supabase.from('rekomendasi').insert(rekomendasi.toJson());
  }

  // UPDATE DATA REKOMENDASI
  Future<void> updateRekomendasi(Rekomendasi rekomendasi) async {
    await supabase
        .from('rekomendasi')
        .update(rekomendasi.toJson())
        // menentukan data berdasarkan primary key
        .eq('id_rekomendasi', rekomendasi.idRekomendasi!);
  }

  // DELETE DATA REKOMENDASI
  Future<void> hapusRekomendasi(int id) async {
    await supabase
        .from('rekomendasi')
        .delete()
        // mencari data yang ingin dihapus
        .eq('id_rekomendasi', id);
  }
}
