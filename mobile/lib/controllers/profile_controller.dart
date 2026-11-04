import 'package:image_picker/image_picker.dart'; // <-- WAJIB ADA INI

import '../services/profile_service.dart';

class ProfileController {
  final ProfileService _service = ProfileService();

  // Get current user ID
  String? getCurrentUserId() {
    return _service.getCurrentUserId();
  }

  // Load profile
  Future<Map<String, dynamic>?> loadProfile() async {
    final userId = getCurrentUserId();
    if (userId == null) {
      print('User belum login');
      return null;
    }
    return await _service.getUserProfile(userId);
  }

  // Update profile
  Future<bool> updateProfile({
    String? nama,
    String? email,
    String? fotoProfil,
  }) async {
    final userId = getCurrentUserId();
    if (userId == null) {
      print('User belum login');
      return false;
    }

    final result = await _service.updateProfile(
      userId,
      nama: nama,
      email: email,
      fotoProfil: fotoProfil,
    );

    return result != null;
  }

  // Upload foto (PERHATIKAN: Sekarang menggunakan XFile, BUKAN String)
  Future<bool> uploadProfilePicture(XFile imageFile) async {
    final userId = getCurrentUserId();
    if (userId == null) {
      print('User belum login');
      return false;
    }

    // Kirim objek imageFile (XFile) langsung ke service
    final photoUrl = await _service.uploadProfilePicture(userId, imageFile);

    if (photoUrl != null) {
      return await updateProfile(fotoProfil: photoUrl);
    }

    return false;
  }

  // Logout
  Future<void> logout() async {
    await _service.logout();
  }
}
