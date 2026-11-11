import 'package:image_picker/image_picker.dart';

import '../services/profile_service.dart';

// Class untuk mengatur proses pengelolaan profil pengguna.
class ProfileController {
  // Membuat objek ProfileService untuk mengakses fungsi layanan profil.
  final ProfileService _service = ProfileService();

  // Mengambil ID pengguna yang sedang login.
  String? getCurrentUserId() {
    return _service.getCurrentUserId();
  }

  // Memuat data profil pengguna dari database.
  Future<Map<String, dynamic>?> loadProfile() async {
    final userId = getCurrentUserId();

    if (userId == null) {
      print('❌ User belum login');
      return null;
    }
    return await _service.getUserProfile(userId);
  }

  // Memperbarui data nama, email, dan foto profil pengguna.
  Future<bool> updateProfile({
    String? nama,
    String? email,
    String? fotoProfil,
  }) async {
    final userId = getCurrentUserId();
    if (userId == null) {
      print('❌ User belum login');
      return false;
    }

    // Mengirim data perubahan profil ke ProfileService.
    final result = await _service.updateProfile(
      userId,
      nama: nama,
      email: email,
      fotoProfil: fotoProfil,
    );
    return result != null;
  }

  // Mengunggah foto profil menggunakan objek XFile.
  Future<bool> uploadProfilePicture(XFile imageFile) async {
    final userId = getCurrentUserId();

    if (userId == null) {
      print('❌ User belum login');
      return false;
    }

    // Mengirim file gambar ke ProfileService untuk diunggah.
    final photoUrl = await _service.uploadProfilePicture(userId, imageFile);

    // Menyimpan URL foto ke dalam data profil jika upload berhasil.
    if (photoUrl != null) {
      return await updateProfile(fotoProfil: photoUrl);
    }

    // Mengembalikan false jika upload foto gagal.
    return false;
  }

  // Mengeluarkan pengguna dari akun yang sedang login.
  Future<void> logout() async {
    await _service.logout();
  }
}
