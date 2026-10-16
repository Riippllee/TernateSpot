import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/rekomendasi_model.dart';

class RekomendasiService {
  // Mengambil koneksi Supabase dari main.dart
  final supabase = Supabase.instance.client;

  // READ: mengambil rekomendasi yang aktif saja
  Future<List<Rekomendasi>> getRekomendasiAktif() async {
    final data = await supabase
        .from('rekomendasi')
        .select()
        .eq('status', true)
        .order('prioritas', ascending: true);

    // Mengubah JSON menjadi daftar objek Rekomendasi
    return data.map((e) => Rekomendasi.fromJson(e)).toList();
  }
}
