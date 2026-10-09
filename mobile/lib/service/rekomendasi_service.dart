// Package ini digunakan agar Flutter dapat berkomunikasi
// dengan database Supabase
import 'package:supabase_flutter/supabase_flutter.dart';

// Mengambil model rekomendasi
// agar service mengetahui bentuk data yang digunakan
import '../model/rekomendasi_model.dart';

// Class ini bertugas menangani proses database
class RekomendasiService {
  // Mengambil koneksi Supabase yang sudah dibuat di main.dart
  final supabase = Supabase.instance.client;

  // ===========================
  // READ DATA REKOMENDASI
  // ===========================
  //
  // Fungsi ini digunakan untuk mengambil
  // semua data rekomendasi dari database

  Future<List<Rekomendasi>> getRekomendasi() async {
    // Mengambil data dari tabel rekomendasi
    final data = await supabase.from('rekomendasi').select();

    // Data dari Supabase berupa JSON
    // kemudian diubah menjadi object Rekomendasi

    return data.map((e) => Rekomendasi.fromJson(e)).toList();
  }

  // ===========================
  // CREATE DATA REKOMENDASI
  // ===========================
  //
  // Fungsi ini digunakan untuk menambahkan
  // rekomendasi baru ke database

  Future<void> tambahRekomendasi(Rekomendasi rekomendasi) async {
    await supabase.from('rekomendasi').insert(rekomendasi.toJson());
  }

  // ===========================
  // UPDATE DATA REKOMENDASI
  // ===========================
  //
  // Fungsi ini digunakan untuk mengubah
  // data rekomendasi yang sudah ada

  Future<void> updateRekomendasi(Rekomendasi rekomendasi) async {
    await supabase
        .from('rekomendasi')
        // data yang ingin diubah
        .update(rekomendasi.toJson())
        // menentukan data berdasarkan primary key
        .eq('id_rekomendasi', rekomendasi.idRekomendasi!);
  }

  // ===========================
  // DELETE DATA REKOMENDASI
  // ===========================
  //
  // Fungsi ini digunakan untuk menghapus
  // rekomendasi berdasarkan id

  Future<void> hapusRekomendasi(int id) async {
    await supabase
        .from('rekomendasi')
        .delete()
        // mencari data yang ingin dihapus
        .eq('id_rekomendasi', id);
  }
}
