import 'package:flutter/foundation.dart';

import '../models/destinasi_user_model.dart';
import '../models/kategori_user_model.dart';
import '../services/destinasi_user_service.dart';

class DestinasiUserController extends ChangeNotifier {
  final DestinasiUserService _service = DestinasiUserService();

  List<DestinasiUserModel> listDestinasi = [];
  List<KategoriUserModel> listKategori = [];

  bool isLoading = false;
  String? errorMessage;

  bool _isDisposed = false;

  // Memuat data destinasi dan kategori
  Future<void> loadData() async {
    if (_isDisposed) return;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final destinasi = await _service.getDestinasiAktif();
      final kategori = await _service.getKategori();

      if (_isDisposed) return;

      listDestinasi = destinasi;
      listKategori = kategori;
    } catch (e) {
      if (_isDisposed) return;

      errorMessage = e.toString();
    } finally {
      if (!_isDisposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  // Memuat ulang data destinasi
  Future<void> refreshData() async {
    await loadData();
  }

  // Mengambil detail destinasi berdasarkan ID
  Future<DestinasiUserModel?> getDetailDestinasi(int id) async {
    try {
      return await _service.getDestinasiById(id);
    } catch (e) {
      if (!_isDisposed) {
        errorMessage = e.toString();
        notifyListeners();
      }
      return null;
    }
  }

  // Mendapatkan nama kategori berdasarkan ID
  String getNamaKategori(int idKategori) {
    try {
      return listKategori
          .firstWhere((kategori) => kategori.idKategori == idKategori)
          .namaKategori;
    } catch (_) {
      return 'Lainnya';
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}