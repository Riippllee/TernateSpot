import 'package:flutter/material.dart';

import '../services/review_admin_service.dart';

class ReviewAdminController extends ChangeNotifier {
  final ReviewAdminService _service = ReviewAdminService();

  // Menyimpan seluruh data ulasan.
  List<Map<String, dynamic>> _ulasan = [];

  // Status loading dan error.
  bool _isLoading = false;
  String? _errorMessage;

  // Pengaturan pencarian dan filter.
  String _searchQuery = '';
  int? _selectedRating;

  // Jumlah seluruh ulasan.
  int get jumlahSemua => _ulasan.length;

  // Jumlah ulasan yang ditampilkan.
  int get jumlahDitampilkan =>
      _ulasan.where((item) => item['status'] == true).length;

  // Jumlah ulasan yang disembunyikan.
  int get jumlahDisembunyikan =>
      _ulasan.where((item) => item['status'] == false).length;

  // Getter data.
  List<Map<String, dynamic>> get ulasan => _ulasan;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  String get searchQuery => _searchQuery;

  int? get selectedRating => _selectedRating;

  int get totalUlasan => _ulasan.length;
  bool? _selectedStatus;

  bool? get selectedStatus => _selectedStatus;

  void filterByStatus(bool? status) {
    _selectedStatus = status;
    notifyListeners();
  }

  // Mengambil data ulasan dari Supabase.
  Future<void> loadUlasan() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ulasan = await _service.getAllUlasan();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mengatur pencarian ulasan.
  void searchUlasan(String query) {
    _searchQuery = query.toLowerCase().trim();
    notifyListeners();
  }

  // Mengatur filter rating.
  void filterByRating(int? rating) {
    _selectedRating = rating;
    notifyListeners();
  }

  // Mendapatkan data ulasan yang sudah difilter.
  List<Map<String, dynamic>> get filteredUlasan {
    return _ulasan.where((item) {
      final namaUser = item['user']?['nama']?.toString().toLowerCase() ?? '';

      final namaDestinasi =
          item['destinasi']?['nama_destinasi']?.toString().toLowerCase() ?? '';

      final komentar = item['komentar']?.toString().toLowerCase() ?? '';

      final rating = (item['rating'] as num?)?.toInt();

      final cocokPencarian =
          namaUser.contains(_searchQuery) ||
          namaDestinasi.contains(_searchQuery) ||
          komentar.contains(_searchQuery);

      final cocokRating = _selectedRating == null || rating == _selectedRating;

      final status = item['status'] as bool?;

      final cocokStatus = _selectedStatus == null || status == _selectedStatus;

      return cocokPencarian && cocokRating && cocokStatus;
    }).toList();
  }

  // Menghapus ulasan.
  Future<bool> deleteUlasan(int idUlasan) async {
    try {
      await _service.deleteUlasan(idUlasan);

      _ulasan.removeWhere((item) => item['id_ulasan'] == idUlasan);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Membersihkan filter pencarian dan rating.
  void resetFilter() {
    _searchQuery = '';
    _selectedRating = null;
    _selectedStatus = null;
    notifyListeners();
  }

  // Mengubah status publikasi ulasan.
  Future<bool> updateStatusUlasan({
    required int idUlasan,
    required bool status,
  }) async {
    try {
      await _service.updateStatusUlasan(idUlasan: idUlasan, status: status);

      final index = _ulasan.indexWhere((item) => item['id_ulasan'] == idUlasan);

      if (index != -1) {
        _ulasan[index]['status'] = status;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
