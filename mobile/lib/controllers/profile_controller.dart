import 'package:image_picker/image_picker.dart';

import '../services/profile_service.dart';

class ProfileController {
  final ProfileService _service = ProfileService();

  String? getCurrentUserId() {
    return _service.getCurrentUserId();
  }

  // Memuat profil sekaligus memastikan profil sudah dibuat.
  Future<Map<String, dynamic>?> loadProfile() async {
    return await _service.ensureUserProfile();
  }

  // Memperbarui profil.
  Future<bool> updateProfile({
    String? nama,
    String? email,
    String? fotoProfil,
  }) async {
    try {
      final profile = await _service.ensureUserProfile();

      if (profile == null) {
        print('❌ Profil belum tersedia');
        return false;
      }

      final userId = getCurrentUserId();

      if (userId == null) return false;

      final result = await _service.updateProfile(
        userId,
        nama: nama,
        email: email,
        fotoProfil: fotoProfil,
      );

      return result != null;
    } catch (e) {
      print('❌ Error controller update profile: $e');
      return false;
    }
  }

  // Upload foto profil.
  Future<bool> uploadProfilePicture(XFile imageFile) async {
    try {
      final profile = await _service.ensureUserProfile();

      if (profile == null) return false;

      final userId = getCurrentUserId();

      if (userId == null) return false;

      final photoUrl = await _service.uploadProfilePicture(userId, imageFile);

      if (photoUrl == null) return false;

      return await updateProfile(fotoProfil: photoUrl);
    } catch (e) {
      print('❌ Error upload profile picture: $e');
      return false;
    }
  }

  // Logout.
  Future<void> logout() async {
    await _service.logout();
  }
}
