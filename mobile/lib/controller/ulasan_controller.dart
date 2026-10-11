import '../service/ulasan_service.dart';
import '../model/ulasan_model.dart';

// Controller mengatur alur
class UlasanController {
  final service = UlasanService(); // Membuat object service

  // MELIHAT ULASAN
  Future<List<Ulasan>> lihatUlasan() {
    return service.getUlasan();
  }

  // MENAMBAH ULASAN
  Future<void> tambahUlasan(Ulasan ulasan) {
    return service.tambahUlasan(ulasan);
  }

  // MENGUBAH ULASAN
  Future<void> ubahUlasan(Ulasan ulasan) {
    return service.updateUlasan(ulasan);
  }

  // MENGHAPUS ULASAN
  Future<void> hapusUlasan(int id) {
    return service.hapusUlasan(id);
  }
}
