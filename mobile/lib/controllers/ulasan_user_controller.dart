import 'package:flutter/foundation.dart';

import '../models/ulasan_user_model.dart';
import '../services/ulasan_user_service.dart';

// =====================================================
// ULASAN USER CONTROLLER
// =====================================================

class UlasanUserController extends ChangeNotifier {
  final UlasanUserService _service = UlasanUserService();

  List<UlasanUserModel> listUlasan = [];

  RingkasanRating? ringkasanRating;

  UlasanUserModel? ulasanSaya;

  bool isLoading = false;
  bool isSubmitting = false;

  String? errorMessage;

  bool _isDisposed = false;

  // =====================================================
  // NOTIFIKASI PERUBAHAN DATA
  // =====================================================

  void _notify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  // =====================================================
  // MEMUAT DATA ULASAN
  // =====================================================

  Future<void> loadData(int idDestinasi) async {
    if (_isDisposed) return;

    isLoading = true;
    errorMessage = null;

    _notify();

    try {
      final hasilUlasan = await _service.getUlasanByDestinasi(idDestinasi);

      final hasilRingkasan = await _service.getRingkasanRating(idDestinasi);

      final hasilUlasanSaya = await _service.getUlasanSaya(idDestinasi);

      if (_isDisposed) return;

      listUlasan = hasilUlasan;
      ringkasanRating = hasilRingkasan;
      ulasanSaya = hasilUlasanSaya;
    } catch (e) {
      if (_isDisposed) return;

      errorMessage = _pesanError(e);
    } finally {
      if (!_isDisposed) {
        isLoading = false;
        _notify();
      }
    }
  }

  // =====================================================
  // MEMUAT ULANG DATA
  // =====================================================

  Future<void> refreshData(int idDestinasi) async {
    await loadData(idDestinasi);
  }

  // =====================================================
  // MENAMBAHKAN ULASAN
  // =====================================================

  Future<bool> tambahUlasan({
    required int idDestinasi,
    required int rating,
    required String komentar,
  }) async {
    if (_isDisposed || isSubmitting) {
      return false;
    }

    isSubmitting = true;
    errorMessage = null;

    _notify();

    try {
      await _service.tambahUlasan(
        idDestinasi: idDestinasi,
        rating: rating,
        komentar: komentar,
      );

      await loadData(idDestinasi);

      return true;
    } catch (e) {
      if (!_isDisposed) {
        errorMessage = _pesanError(e);
      }

      return false;
    } finally {
      if (!_isDisposed) {
        isSubmitting = false;
        _notify();
      }
    }
  }

  // =====================================================
  // MEMPERBARUI ULASAN
  // =====================================================

  Future<bool> updateUlasan({
    required int idDestinasi,
    required int idUlasan,
    required int rating,
    required String komentar,
  }) async {
    if (_isDisposed || isSubmitting) {
      return false;
    }

    isSubmitting = true;
    errorMessage = null;

    _notify();

    try {
      await _service.updateUlasan(
        idUlasan: idUlasan,
        rating: rating,
        komentar: komentar,
      );

      await loadData(idDestinasi);

      return true;
    } catch (e) {
      if (!_isDisposed) {
        errorMessage = _pesanError(e);
      }

      return false;
    } finally {
      if (!_isDisposed) {
        isSubmitting = false;
        _notify();
      }
    }
  }

  // =====================================================
  // MENGHAPUS ULASAN
  // =====================================================

  Future<bool> hapusUlasan({
    required int idDestinasi,
    required int idUlasan,
  }) async {
    if (_isDisposed || isSubmitting) {
      return false;
    }

    isSubmitting = true;
    errorMessage = null;

    _notify();

    try {
      await _service.hapusUlasan(idUlasan);

      await loadData(idDestinasi);

      return true;
    } catch (e) {
      if (!_isDisposed) {
        errorMessage = _pesanError(e);
      }

      return false;
    } finally {
      if (!_isDisposed) {
        isSubmitting = false;
        _notify();
      }
    }
  }

  // =====================================================
  // GETTER RATA-RATA RATING
  // =====================================================

  double get rataRataRating {
    return ringkasanRating?.rataRata ?? 0.0;
  }

  // =====================================================
  // GETTER JUMLAH ULASAN
  // =====================================================

  int get jumlahUlasan {
    return ringkasanRating?.jumlahUlasan ?? 0;
  }

  // =====================================================
  // JUMLAH RATING BERDASARKAN BINTANG
  // =====================================================

  int jumlahRating(int bintang) {
    return ringkasanRating?.distribusiRating[bintang] ?? 0;
  }

  // =====================================================
  // PERSENTASE RATING
  // =====================================================

  double persentaseRating(int bintang) {
    if (jumlahUlasan == 0) {
      return 0.0;
    }

    return jumlahRating(bintang) / jumlahUlasan;
  }

  // =====================================================
  // MEMBERSIHKAN ERROR
  // =====================================================

  void clearError() {
    errorMessage = null;
    _notify();
  }

  // =====================================================
  // MENGOLAH PESAN ERROR
  // =====================================================

  String _pesanError(Object error) {
    final pesan = error.toString();

    if (pesan.startsWith('Exception: ')) {
      return pesan.substring('Exception: '.length);
    }

    return pesan;
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}