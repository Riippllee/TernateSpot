
import 'package:image_picker/image_picker.dart';
import '../services/profile_service.dart';

class ProfileController {
  final ProfileService _service = ProfileService();

  // Mengambil ID pengguna yang sedang login.
  String? getCurrentUserId() {
    return _service.getCurrentUserId();
  }

  // Memuat profil dan membuat profil jika belum tersedia.
  Future<Map<String, dynamic>?> loadProfile() async {
    try {
      return await _service.ensureUserProfile();
    } catch (e) {
      print('Error load profile: $e');
      return null;
    }
  }

  // Memperbarui data profil.
  Future<bool> updateProfile({
    String? nama,
    String? email,
    String? fotoProfil,
  }) async {
    try {
      final userId = getCurrentUserId();

      if (userId == null) return false;

      final profile = await _service.ensureUserProfile();
      if (profile == null) return false;

      final result = await _service.updateProfile(
        userId,
        nama: nama,
        email: email,
        fotoProfil: fotoProfil,
      );

      return result != null;
    } catch (e) {
      print('Error update profile: $e');
      return false;
    }
  }

  // Mengunggah foto profil.
  Future<bool> uploadProfilePicture(XFile imageFile) async {
    try {
      final userId = getCurrentUserId();

      if (userId == null) return false;

      final profile = await _service.ensureUserProfile();
      if (profile == null) return false;

      final photoUrl = await _service.uploadProfilePicture(
        userId,
        imageFile,
      );

      if (photoUrl == null) return false;

      return await updateProfile(fotoProfil: photoUrl);
    } catch (e) {
      print('Error upload foto: $e');
      return false;
    }
  }

  // Logout pengguna.
  Future<void> logout() async {
    await _service.logout();
  }
}
