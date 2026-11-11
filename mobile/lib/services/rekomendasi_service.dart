import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/rekomendasi_model.dart';
import '../models/destinasi_model.dart';

class RekomendasiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Mengambil seluruh data rekomendasi.
  Future<List<RekomendasiModel>> getRekomendasi() async {
    final response = await _supabase
        .from('rekomendasi')
        .select()
        .order('prioritas', ascending: true);

    return (response as List)
        .map((item) => RekomendasiModel.fromJson(item))
        .toList();
  }

  Future<List<RekomendasiModel>> getRekomendasiAktif() async {
    final response = await _supabase
        .from('rekomendasi')
        .select()
        .eq('status', true)
        .order('prioritas', ascending: true)
        .limit(6);

    return (response as List)
        .map((item) => RekomendasiModel.fromJson(item))
        .toList();
  }

  // 2. Menentukan slot prioritas yang masih kosong.
  Future<int> _getPrioritasTersedia() async {
    final response = await _supabase
        .from('rekomendasi')
        .select('prioritas')
        .eq('status', true);

    final prioritasTerpakai = response
        .map((item) => (item['prioritas'] as num).toInt())
        .toSet();

    for (int i = 1; i <= 6; i++) {
      if (!prioritasTerpakai.contains(i)) {
        return i;
      }
    }

    throw Exception('Maksimal 6 rekomendasi telah terpenuhi.');
  }

  // 3. Menambahkan destinasi ke rekomendasi.
  Future<void> tambahRekomendasi(int idDestinasi) async {
    final existing = await _supabase
        .from('rekomendasi')
        .select('id_rekomendasi, status')
        .eq('id_destinasi', idDestinasi);

    final prioritas = await _getPrioritasTersedia();

    if (existing.isNotEmpty) {
      final dataLama = existing.first;

      if (dataLama['status'] == true) {
        throw Exception('Destinasi sudah masuk rekomendasi.');
      }

      await _supabase
          .from('rekomendasi')
          .update({'status': true, 'prioritas': prioritas})
          .eq('id_rekomendasi', dataLama['id_rekomendasi']);

      return;
    }

    await _supabase.from('rekomendasi').insert({
      'id_destinasi': idDestinasi,
      'prioritas': prioritas,
      'status': true,
    });
  }

  // 4. Mengubah urutan prioritas.
  Future<void> ubahPrioritas(int idRekomendasi, int prioritas) async {
    if (prioritas < 1 || prioritas > 6) {
      throw Exception('Prioritas harus antara 1 sampai 6.');
    }

    await _supabase
        .from('rekomendasi')
        .update({'prioritas': prioritas})
        .eq('id_rekomendasi', idRekomendasi);
  }

  // Menukar prioritas dua destinasi.
  Future<void> tukarPrioritas({
    required int idPertama,
    required int prioritasPertama,
    required int idKedua,
    required int prioritasKedua,
  }) async {
    // Gunakan nilai sementara agar tidak terjadi benturan
    // apabila kolom prioritas memiliki UNIQUE constraint.
    await _supabase
        .from('rekomendasi')
        .update({'prioritas': 0})
        .eq('id_rekomendasi', idPertama);

    try {
      await _supabase
          .from('rekomendasi')
          .update({'prioritas': prioritasPertama})
          .eq('id_rekomendasi', idKedua);

      await _supabase
          .from('rekomendasi')
          .update({'prioritas': prioritasKedua})
          .eq('id_rekomendasi', idPertama);
    } catch (e) {
      // Jika proses gagal, tampilkan error.
      throw Exception('Gagal menukar prioritas: $e');
    }
  }

  // 5. Mengaktifkan atau menonaktifkan rekomendasi.
  Future<void> ubahStatus(int idRekomendasi, bool status) async {
    if (status) {
      final aktif = await _supabase
          .from('rekomendasi')
          .select('id_rekomendasi')
          .eq('status', true);

      final sudahAktif = aktif.any(
        (item) => item['id_rekomendasi'] == idRekomendasi,
      );

      if (!sudahAktif && aktif.length >= 6) {
        throw Exception('Maksimal 6 rekomendasi aktif.');
      }
    }

    await _supabase
        .from('rekomendasi')
        .update({'status': status})
        .eq('id_rekomendasi', idRekomendasi);
  }

  // 6. Menghapus rekomendasi.
  Future<void> hapusRekomendasi(int idRekomendasi) async {
    await _supabase
        .from('rekomendasi')
        .delete()
        .eq('id_rekomendasi', idRekomendasi);
  }

  // Mengambil seluruh destinasi dari Supabase.
  Future<List<DestinasiModel>> getAllDestinasi() async {
    final response = await _supabase
        .from('destinasi')
        .select()
        .order('nama_destinasi', ascending: true);

    return (response as List)
        .map((item) => DestinasiModel.fromJson(item))
        .toList();
  }
}
