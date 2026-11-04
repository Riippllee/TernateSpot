import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

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
      if (nama != null) updateData['nama'] = nama;
      if (email != null) updateData['email'] = email;
      if (fotoProfil != null) updateData['foto_profil'] = fotoProfil;

      final data = await _supabase
          .from('user')
          .update(updateData)
          .eq('id_user', userId)
          .select()
          .single();
      return data;
    } catch (e) {
      print('❌ Error update profile: $e');
      return null;
    }
  }

  Future<String?> uploadProfilePicture(String userId, XFile imageFile) async {
    try {
      final fileName =
          '$userId/profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final fileBytes = await imageFile.readAsBytes();

      // Nama bucket disesuaikan dengan yang ada di Supabase Anda
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

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
