import 'package:flutter/material.dart';

import '../models/kategori_model.dart';
import '../models/destinasi_model.dart';
import '../models/galeri_model.dart';
import '../services/destinasi_service.dart';

class DestinasiController extends ChangeNotifier {
  final DestinasiService _service = DestinasiService();

  // State untuk Kategori
  List<KategoriModel> _listKategori = [];
  bool _isLoadingKategori = false;

  // State untuk Destinasi
  List<DestinasiModel> _listDestinasi = [];
  bool _isLoadingDestinasi = false;

  // State untuk Galeri
  List<GaleriModel> _listGaleri = [];
  bool _isLoadingGaleri = false;

  // State umum
  String? _errorMessage;
  bool _isSuccess = false;

  // ============================================
  // GETTERS
  // ============================================

  List<KategoriModel> get listKategori => _listKategori;
  bool get isLoadingKategori => _isLoadingKategori;

  List<DestinasiModel> get listDestinasi => _listDestinasi;
  bool get isLoadingDestinasi => _isLoadingDestinasi;

  List<GaleriModel> get listGaleri => _listGaleri;
  bool get isLoadingGaleri => _isLoadingGaleri;

  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  // ============================================
  // KATEGORI CONTROLLER
  // ============================================

  // Load semua kategori
  Future<void> loadKategori() async {
    _isLoadingKategori = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _listKategori = await _service.getAllKategori();
    } catch (e) {
      _errorMessage = 'Gagal memuat kategori: $e';
    }

    _isLoadingKategori = false;
    notifyListeners();
  }

  // Tambah kategori
  Future<bool> tambahKategori(String namaKategori) async {
    _isLoadingKategori = true;
    notifyListeners();

    try {
      final kategori = KategoriModel(
        idKategori: 0, // Auto-generated
        namaKategori: namaKategori,
        tanggalDaftar: DateTime.now(),
      );

      await _service.tambahKategori(kategori);
      await loadKategori(); // Refresh data

      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah kategori: $e';
      _isSuccess = false;
      return false;
    } finally {
      _isLoadingKategori = false;
      notifyListeners();
    }
  }

  // Update kategori
  Future<bool> updateKategori(int id, String namaKategori) async {
    _isLoadingKategori = true;
    notifyListeners();

    try {
      final kategori = KategoriModel(
        idKategori: id,
        namaKategori: namaKategori,
        tanggalDaftar: DateTime.now(),
      );

      await _service.updateKategori(id, kategori);
      await loadKategori();

      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal update kategori: $e';
      _isSuccess = false;
      return false;
    } finally {
      _isLoadingKategori = false;
      notifyListeners();
    }
  }

  // Hapus kategori
  Future<bool> hapusKategori(int id) async {
    _isLoadingKategori = true;
    notifyListeners();

    try {
      await _service.hapusKategori(id);
      await loadKategori();

      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal hapus kategori: $e';
      _isSuccess = false;
      return false;
    } finally {
      _isLoadingKategori = false;
      notifyListeners();
    }
  }

  // ============================================
  // DESTINASI CONTROLLER
  // ============================================

  // Load semua destinasi
  Future<void> loadDestinasi() async {
    _isLoadingDestinasi = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _listDestinasi = await _service.getAllDestinasi();
    } catch (e) {
      _errorMessage = 'Gagal memuat destinasi: $e';
    }

    _isLoadingDestinasi = false;
    notifyListeners();
  }

  // Tambah destinasi
  Future<bool> tambahDestinasi(DestinasiModel destinasi) async {
    _isLoadingDestinasi = true;
    notifyListeners();

    try {
      await _service.tambahDestinasi(destinasi);
      await loadDestinasi();

      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah destinasi: $e';
      _isSuccess = false;
      return false;
    } finally {
      _isLoadingDestinasi = false;
      notifyListeners();
    }
  }

  // Update destinasi
  Future<bool> updateDestinasi(int id, DestinasiModel destinasi) async {
    _isLoadingDestinasi = true;
    notifyListeners();

    try {
      await _service.updateDestinasi(id, destinasi);
      await loadDestinasi();

      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal update destinasi: $e';
      _isSuccess = false;
      return false;
    } finally {
      _isLoadingDestinasi = false;
      notifyListeners();
    }
  }

  // Hapus destinasi
  Future<bool> hapusDestinasi(int id) async {
    _isLoadingDestinasi = true;
    notifyListeners();

    try {
      await _service.hapusDestinasi(id);
      await loadDestinasi();

      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal hapus destinasi: $e';
      _isSuccess = false;
      return false;
    } finally {
      _isLoadingDestinasi = false;
      notifyListeners();
    }
  }

  // ============================================
  // GALERI CONTROLLER
  // ============================================

  // Load galeri berdasarkan destinasi
  Future<void> loadGaleri(int idDestinasi) async {
    _isLoadingGaleri = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _listGaleri = await _service.getGaleriByDestinasi(idDestinasi);
    } catch (e) {
      _errorMessage = 'Gagal memuat galeri: $e';
    }

    _isLoadingGaleri = false;
    notifyListeners();
  }

  // Tambah foto ke galeri (dengan upload)
  Future<bool> tambahGaleriDenganUpload(
    int idDestinasi,
    String urlGambar,
    String keterangan,
  ) async {
    _isLoadingGaleri = true;
    notifyListeners();

    try {
      final galeri = GaleriModel(
        idGaleri: 0, // Auto-generated
        idDestinasi: idDestinasi,
        urlGambar: urlGambar,
        keterangan: keterangan,
        tanggalDibuat: DateTime.now(),
      );

      await _service.tambahGaleri(galeri);
      await loadGaleri(idDestinasi);

      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah galeri: $e';
      _isSuccess = false;
      return false;
    } finally {
      _isLoadingGaleri = false;
      notifyListeners();
    }
  }

  // Hapus foto dari galeri
  Future<bool> hapusGaleri(int idGaleri, int idDestinasi) async {
    _isLoadingGaleri = true;
    notifyListeners();

    try {
      await _service.hapusGaleri(idGaleri);
      await loadGaleri(idDestinasi);

      _isSuccess = true;
      return true;
    } catch (e) {
      _errorMessage = 'Gagal hapus galeri: $e';
      _isSuccess = false;
      return false;
    } finally {
      _isLoadingGaleri = false;
      notifyListeners();
    }
  }

  // ============================================
  // UPLOAD GAMBAR
  // ============================================

  // Upload gambar dan return URL
  Future<String?> uploadGambar(file) async {
    try {
      final url = await _service.uploadGambar(file, 'foto-destinasi');
      return url;
    } catch (e) {
      _errorMessage = 'Gagal upload gambar: $e';
      return null;
    }
  }
}
