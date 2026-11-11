import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

// Class untuk mengelola data profil pengguna.
class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil ID pengguna yang sedang login.
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  // Mengambil data profil pengguna berdasarkan ID.
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('user')
          .select()
          .eq('id_user', userId)
          .maybeSingle();

      if (data == null) return null;
      return data;
    } catch (e) {
      print('❌ Error get profile: $e');
      return null;
    }
  }

  // Memperbarui data profil pengguna.
  Future<Map<String, dynamic>?> updateProfile(
    String userId, {
    String? nama,
    String? email,
    String? fotoProfil,
  }) async {
    try {
      // Menyiapkan data yang akan diperbarui.
      final Map<String, dynamic> updateData = {
        'tanggal_perubahan': DateTime.now().toIso8601String(),
      };

      if (nama != null) updateData['nama'] = nama;

      if (email != null) updateData['email'] = email;

      if (fotoProfil != null) updateData['foto_profil'] = fotoProfil;

      // Menyimpan perubahan profil ke database.
      final data = await _supabase
          .from('user')
          .update(updateData)
          .eq('id_user', userId)
          .select()
          .single();

      // Mengembalikan data profil terbaru.
      return data;
    } catch (e) {
      // Menampilkan pesan kesalahan.
      print('❌ Error update profile: $e');
      return null;
    }
  }

  // Mengunggah foto profil pengguna ke Supabase Storage.
  Future<String?> uploadProfilePicture(String userId, XFile imageFile) async {
    try {
      final fileName =
          '$userId/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final fileBytes = await imageFile.readAsBytes();

      await _supabase.storage
          .from('foto-profil')
          .uploadBinary(fileName, fileBytes);

      final publicUrl = _supabase.storage
          .from('foto-profil')
          .getPublicUrl(fileName);

      // Menampilkan URL foto yang berhasil diunggah.
      print('✅ Foto berhasil diupload: $publicUrl');
      return publicUrl;
    } catch (e) {
      // Menampilkan pesan kesalahan.
      print('❌ Error upload foto: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
