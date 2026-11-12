import 'package:flutter/material.dart';

import '../models/rekomendasi_model.dart';
import '../services/rekomendasi_service.dart';
import '../models/destinasi_model.dart';

class RekomendasiController extends ChangeNotifier {
  final RekomendasiService _service = RekomendasiService();
  // Daftar seluruh destinasi.
  List<DestinasiModel> _listDestinasi = [];

  bool _isLoadingDestinasi = false;

  List<DestinasiModel> get listDestinasi => _listDestinasi;

  bool get isLoadingDestinasi => _isLoadingDestinasi;
  List<RekomendasiModel> _rekomendasi = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<RekomendasiModel> get rekomendasi => _rekomendasi;

  List<RekomendasiModel> get rekomendasiAktif =>
      _rekomendasi.where((item) => item.status).toList()
        ..sort((a, b) => a.prioritas.compareTo(b.prioritas));

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get jumlahRekomendasiAktif => rekomendasiAktif.length;

  bool get slotPenuh => jumlahRekomendasiAktif >= 6;

  // 1. Mengambil data rekomendasi.
  Future<void> loadRekomendasi() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _rekomendasi = await _service.getRekomendasi();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. Menambahkan rekomendasi.
  Future<void> tambahRekomendasi(int idDestinasi) async {
    try {
      await _service.tambahRekomendasi(idDestinasi);
      await loadRekomendasi();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 3. Menghapus rekomendasi.
  Future<void> hapusRekomendasi(int idRekomendasi) async {
    try {
      await _service.hapusRekomendasi(idRekomendasi);
      await loadRekomendasi();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 4. Mengaktifkan atau menonaktifkan rekomendasi.
  Future<void> ubahStatus(int idRekomendasi, bool status) async {
    try {
      await _service.ubahStatus(idRekomendasi, status);
      await loadRekomendasi();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // 5. Mengubah prioritas.
  Future<void> ubahPrioritas(int idRekomendasi, int prioritas) async {
    try {
      await _service.ubahPrioritas(idRekomendasi, prioritas);
      await loadRekomendasi();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> tukarPrioritas(int indexPertama, int indexKedua) async {
    final daftar = rekomendasiAktif;

    if (indexPertama < 0 ||
        indexKedua < 0 ||
        indexPertama >= daftar.length ||
        indexKedua >= daftar.length) {
      return;
    }

    final pertama = daftar[indexPertama];
    final kedua = daftar[indexKedua];

    try {
      await _service.tukarPrioritas(
        idPertama: pertama.idRekomendasi!,
        prioritasPertama: pertama.prioritas,
        idKedua: kedua.idRekomendasi!,
        prioritasKedua: kedua.prioritas,
      );

      await loadRekomendasi();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Memuat katalog destinasi.
  Future<void> loadDestinasi() async {
    _isLoadingDestinasi = true;
    notifyListeners();

    try {
      _listDestinasi = await _service.getAllDestinasi();
    } catch (e) {
      _errorMessage = 'Gagal memuat katalog destinasi: $e';
    } finally {
      _isLoadingDestinasi = false;
      notifyListeners();
    }
  }

  Future<void> loadRekomendasiAktif() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _rekomendasi = await _service.getRekomendasiAktif();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
