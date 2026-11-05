import '../service/ulasan_service.dart';
import '../model/ulasan_model.dart';

// Controller menghubungkan View dengan Service
class UlasanController {
  final service = UlasanService();

  // Menampilkan ulasan berdasarkan ID destinasi
  Future<List<Ulasan>> lihatUlasan(int idDestinasi) {
    return service.getUlasan(idDestinasi);
  }

  // Menambahkan ulasan
  Future<void> tambahUlasan({
    required int idDestinasi,
    required int rating,
    required String komentar,
  }) {
    return service.tambahUlasan(
      idDestinasi: idDestinasi,
      rating: rating,
      komentar: komentar,
    );
  }

  // Mengubah ulasan
  Future<void> ubahUlasan(Ulasan ulasan) {
    return service.updateUlasan(ulasan);
  }

  // Menghapus ulasan
  Future<void> hapusUlasan(int idUlasan) {
    return service.hapusUlasan(idUlasan);
  }
}
