import '../service/rekomendasi_service.dart';
import '../model/rekomendasi_model.dart';

// Controller bertugas mengatur alur data
class RekomendasiController {
  final service = RekomendasiService();   // Membuat object service

  // MENAMPILKAN DATA
  Future<List<Rekomendasi>> lihatRekomendasi() {
    return service.getRekomendasi();
  }

  // MENAMBAH DATA
  Future<void> tambahRekomendasi(Rekomendasi rekomendasi) {
    return service.tambahRekomendasi(rekomendasi);
  }

  // MENGUBAH DATA
  Future<void> ubahRekomendasi(Rekomendasi rekomendasi) {
    return service.updateRekomendasi(rekomendasi);
  }

  // MENGHAPUS DATA
  Future<void> hapusRekomendasi(int id) {
    return service.hapusRekomendasi(id);
  }
}
