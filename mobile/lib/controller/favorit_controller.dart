import '../service/favorit_service.dart';
import '../model/favorit_model.dart';

// Controller sebagai penghubung View dan Service
class FavoritController {
  final service = FavoritService();

  // READ: menampilkan daftar favorit
  Future<List<Favorit>> lihatFavorit() {
    return service.getFavorit();
  }

  // CREATE: menambahkan favorit
  Future<void> tambahFavorit(int idDestinasi) {
    return service.tambahFavorit(idDestinasi);
  }

  // DELETE: menghapus favorit
  Future<void> hapusFavorit(int idFavorit) {
    return service.hapusFavorit(idFavorit);
  }
}
