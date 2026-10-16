import '../service/rekomendasi_service.dart';
import '../model/rekomendasi_model.dart';

// Controller menghubungkan View dengan Service
class RekomendasiController {
  final service = RekomendasiService();

  // Mengambil rekomendasi aktif dari Service
  Future<List<Rekomendasi>> lihatRekomendasiAktif() {
    return service.getRekomendasiAktif();
  }
}
