import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/rekomendasi_model.dart';
import '../models/destinasi_model.dart';

class RekomendasiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // =========================================================
  // 1. MENGAMBIL SELURUH DATA REKOMENDASI UNTUK ADMIN
  // =========================================================

  Future<List<RekomendasiModel>> getRekomendasi() async {
    final response = await _supabase
        .from('rekomendasi')
        .select()
        .order('prioritas', ascending: true);

    return (response as List)
        .map((item) => RekomendasiModel.fromJson(item))
        .toList();
  }

  // =========================================================
  // 2. MENGAMBIL REKOMENDASI PUBLISHED UNTUK HOME
  // =========================================================

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

  // =========================================================
  // 3. MENGAMBIL REKOMENDASI DRAFT
  // =========================================================

  Future<List<RekomendasiModel>> getRekomendasiDraft() async {
    final response = await _supabase
        .from('rekomendasi')
        .select()
        .eq('status', false)
        .order('prioritas', ascending: true);

    return (response as List)
        .map((item) => RekomendasiModel.fromJson(item))
        .toList();
  }

  // =========================================================
  // 4. VALIDASI DESTINASI AKTIF
  // =========================================================

  Future<void> _validasiDestinasiAktif(int idDestinasi) async {
    final destinasi = await _supabase
        .from('destinasi')
        .select('id_destinasi, status')
        .eq('id_destinasi', idDestinasi)
        .maybeSingle();

    if (destinasi == null) {
      throw Exception('Destinasi tidak ditemukan.');
    }

    if (destinasi['status'] != true) {
      throw Exception('Destinasi tidak aktif atau sudah diarsipkan.');
    }
  }

  // =========================================================
  // 5. MENENTUKAN PRIORITAS YANG MASIH KOSONG
  // =========================================================

  Future<int> _getPrioritasTersedia() async {
    // Hitung seluruh rekomendasi, termasuk Draft.
    final response = await _supabase.from('rekomendasi').select('prioritas');

    final prioritasTerpakai = response
        .map((item) => (item['prioritas'] as num).toInt())
        .toSet();

    // Maksimal 6 rekomendasi secara keseluruhan.
    for (int i = 1; i <= 6; i++) {
      if (!prioritasTerpakai.contains(i)) {
        return i;
      }
    }

    throw Exception(
      'Maksimal 6 rekomendasi telah terpenuhi. '
      'Hapus salah satu rekomendasi terlebih dahulu.',
    );
  }

  // =========================================================
  // 6. MENAMBAHKAN DESTINASI SEBAGAI DRAFT
  // =========================================================

  Future<void> tambahRekomendasi(int idDestinasi) async {
    // Pastikan destinasi masih aktif.
    await _validasiDestinasiAktif(idDestinasi);

    // Periksa apakah destinasi sudah pernah ditambahkan.
    final existing = await _supabase
        .from('rekomendasi')
        .select('id_rekomendasi, status')
        .eq('id_destinasi', idDestinasi);

    if (existing.isNotEmpty) {
      final sudahPublished = existing.any((item) => item['status'] == true);

      if (sudahPublished) {
        throw Exception('Destinasi sudah masuk daftar rekomendasi Published.');
      }

      throw Exception('Destinasi sudah berada dalam daftar Draft.');
    }

    // Periksa slot yang tersedia.
    final prioritas = await _getPrioritasTersedia();

    // SIMPAN SEBAGAI DRAFT.
    // Tidak boleh langsung muncul di Home.
    await _supabase.from('rekomendasi').insert({
      'id_destinasi': idDestinasi,
      'prioritas': prioritas,
      'status': false,
    });
  }

  // =========================================================
  // 7. MEMPUBLIKASIKAN SELURUH DRAFT
  // =========================================================

  Future<void> publikasikanDraft() async {
    // Ambil seluruh data Draft.
    final draft = await getRekomendasiDraft();

    if (draft.isEmpty) {
      throw Exception('Belum ada rekomendasi Draft untuk dipublikasikan.');
    }

    // Pastikan seluruh destinasi masih aktif.
    for (final rekomendasi in draft) {
      await _validasiDestinasiAktif(rekomendasi.idDestinasi);
    }

    // Ubah seluruh Draft menjadi Published.
    await _supabase
        .from('rekomendasi')
        .update({'status': true})
        .eq('status', false);
  }

  // =========================================================
  // 8. MENGUBAH URUTAN PRIORITAS
  // =========================================================

  Future<void> ubahPrioritas(int idRekomendasi, int prioritas) async {
    if (prioritas < 1 || prioritas > 6) {
      throw Exception('Prioritas harus antara 1 sampai 6.');
    }

    await _supabase
        .from('rekomendasi')
        .update({'prioritas': prioritas})
        .eq('id_rekomendasi', idRekomendasi);
  }

  // =========================================================
  // 9. MENUKAR PRIORITAS DUA REKOMENDASI
  // =========================================================

  Future<void> tukarPrioritas({
    required int idPertama,
    required int prioritasPertama,
    required int idKedua,
    required int prioritasKedua,
  }) async {
    if (idPertama == idKedua) {
      return;
    }

    // Simpan prioritas pertama sementara.
    await _supabase
        .from('rekomendasi')
        .update({'prioritas': 0})
        .eq('id_rekomendasi', idPertama);

    try {
      // Tukar prioritas kedua.
      await _supabase
          .from('rekomendasi')
          .update({'prioritas': prioritasPertama})
          .eq('id_rekomendasi', idKedua);

      // Kembalikan prioritas pertama ke posisi kedua.
      await _supabase
          .from('rekomendasi')
          .update({'prioritas': prioritasKedua})
          .eq('id_rekomendasi', idPertama);
    } catch (e) {
      // Coba pulihkan prioritas pertama.
      try {
        await _supabase
            .from('rekomendasi')
            .update({'prioritas': prioritasPertama})
            .eq('id_rekomendasi', idPertama);
      } catch (_) {
        // Pertahankan error utama.
      }

      throw Exception('Gagal menukar prioritas: $e');
    }
  }

  // =========================================================
  // 10. MENGUBAH STATUS REKOMENDASI
  // =========================================================

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
        throw Exception('Maksimal 6 rekomendasi Published.');
      }
    }

    await _supabase
        .from('rekomendasi')
        .update({'status': status})
        .eq('id_rekomendasi', idRekomendasi);
  }

  // =========================================================
  // 11. MENGHAPUS REKOMENDASI
  // =========================================================

  Future<void> hapusRekomendasi(int idRekomendasi) async {
    // Hanya menghapus data rekomendasi.
    // Data destinasi tetap tersimpan.
    await _supabase
        .from('rekomendasi')
        .delete()
        .eq('id_rekomendasi', idRekomendasi);
  }

  // =========================================================
  // 12. MENGAMBIL SELURUH DATA DESTINASI
  // =========================================================

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
