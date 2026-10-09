// Mengambil service rekomendasi
// karena controller membutuhkan fungsi database
import '../service/rekomendasi_service.dart';

// Mengambil model rekomendasi
import '../model/rekomendasi_model.dart';

// Controller bertugas mengatur alur data
class RekomendasiController {
  // Membuat object service
  // agar controller bisa menggunakan fungsi database
  final service = RekomendasiService();

  // ===========================
  // MENAMPILKAN DATA
  // ===========================
  //
  // Controller meminta service
  // untuk mengambil data dari Supabase

  Future<List<Rekomendasi>> lihatRekomendasi() {
    return service.getRekomendasi();
  }

  // ===========================
  // MENAMBAH DATA
  // ===========================

  Future<void> tambahRekomendasi(Rekomendasi rekomendasi) {
    return service.tambahRekomendasi(rekomendasi);
  }

  // ===========================
  // MENGUBAH DATA
  // ===========================

  Future<void> ubahRekomendasi(Rekomendasi rekomendasi) {
    return service.updateRekomendasi(rekomendasi);
  }

  // ===========================
  // MENGHAPUS DATA
  // ===========================

  Future<void> hapusRekomendasi(int id) {
    return service.hapusRekomendasi(id);
  }
}
