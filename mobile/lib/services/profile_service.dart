import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Mengambil ID pengguna yang sedang login.
  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  // Memastikan profil pengguna tersedia di tabel user.
  Future<Map<String, dynamic>?> ensureUserProfile() async {
    try {
      final authUser = _supabase.auth.currentUser;

      if (authUser == null) {
        print('❌ User belum login');
        return null;
      }

      final userId = authUser.id;
      final email = authUser.email;

      if (email == null || email.isEmpty) {
        print('❌ Email pengguna tidak tersedia');
        return null;
      }

      // Periksa apakah profil sudah ada.
      final existingProfile = await getUserProfile(userId);

      if (existingProfile != null) {
        print('✅ Profil pengguna sudah tersedia');
        return existingProfile;
      }

      // Ambil nama dari metadata Google.
      final metadata = authUser.userMetadata ?? {};

      String nama =
          metadata['full_name']?.toString() ??
          metadata['name']?.toString() ??
          metadata['nama']?.toString() ??
          email.split('@').first;

      // Buat profil baru.
      final newProfile = await _supabase
          .from('user')
          .insert({
            'id_user': userId,
            'nama': nama,
            'email': email,
            'role': 'user',
            'status': true,
          })
          .select()
          .single();

      print('✅ Profil pengguna berhasil dibuat');
      print('UID: $userId');
      print('Nama: $nama');

      return newProfile;
    } catch (e) {
      print('❌ Error ensure user profile: $e');
      return null;
    }
  }

  // Mengambil profil berdasarkan UID.
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('user')
          .select()
          .eq('id_user', userId)
          .maybeSingle();

      return data;
    } catch (e) {
      print('❌ Error get profile: $e');
      return null;
    }
  }

  // Memperbarui profil pengguna.
  Future<Map<String, dynamic>?> updateProfile(
    String userId, {
    String? nama,
    String? email,
    String? fotoProfil,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'tanggal_perubahan': DateTime.now().toIso8601String(),
      };

      if (nama != null) {
        updateData['nama'] = nama;
      }

      if (email != null) {
        updateData['email'] = email;
      }

      if (fotoProfil != null) {
        updateData['foto_profil'] = fotoProfil;
      }

      final data = await _supabase
          .from('user')
          .update(updateData)
          .eq('id_user', userId)
          .select()
          .maybeSingle();

      if (data == null) {
        print('❌ Profil tidak ditemukan untuk diperbarui');
        return null;
      }

      print('✅ Profil berhasil diperbarui');
      return data;
    } catch (e) {
      print('❌ Error update profile: $e');
      return null;
    }
  }

  // Upload foto profil.
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

      print('✅ Foto berhasil diupload: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('❌ Error upload foto: $e');
      return null;
    }
  }

  // Logout.
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
