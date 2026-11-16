
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

// ==========================================
// USER SERVICE
// ==========================================

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('user')
          .select()
          .eq('id_user', userId)
          .maybeSingle();

      if (data == null) {
        return null;
      }

      return UserModel.fromJson(data);
    } catch (e) {
      debugPrint('Error get user profile: $e');
      return null;
    }
  }
}

// ==========================================
// AUTH SERVICE
// ==========================================

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ========================================
  // LOGIN EMAIL & PASSWORD
  // ========================================

  Future<AuthResponse> login(
    String email,
    String password,
  ) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email.trim().toLowerCase(),
      password: password,
    );

    debugPrint('Login berhasil: ${response.user?.email}');

    return response;
  }

  // ========================================
  // LOGIN GOOGLE OAUTH
  // ========================================

  Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? Uri.base.origin : null,
      );

      debugPrint('Proses Google OAuth dimulai');
    } catch (e) {
      debugPrint('Error Google Login: $e');
      rethrow;
    }
  }

  // ========================================
  // REGISTER / SIGN UP
  // ========================================

  Future<AuthResponse> signUp(
    String nama,
    String email,
    String password,
  ) async {
    final cleanNama = nama.trim();
    final cleanEmail = email.trim().toLowerCase();

    final response = await _supabase.auth.signUp(
      email: cleanEmail,
      password: password,
      data: {
        'nama': cleanNama,
      },
    );

    // Membuat profil awal pengguna.
    // Jika profil sudah dibuat oleh database trigger,
    // proses insert ini dapat gagal tanpa mengganggu registrasi.
    if (response.user != null) {
      try {
        await _supabase.from('user').insert({
          'id_user': response.user!.id,
          'nama': cleanNama,
          'email': cleanEmail,
          'foto_profil': null,
          'role': 'user',
          'status': true,
        });

        debugPrint('Profil pengguna berhasil dibuat');
      } catch (e) {
        debugPrint('Insert profil dilewati/gagal: $e');
      }
    }

    return response;
  }

  // ========================================
  // FORGOT PASSWORD
  // ========================================

  Future<void> forgotPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email.trim().toLowerCase(),
      redirectTo: kIsWeb ? Uri.base.origin : null,
    );

    debugPrint('Permintaan reset password dikirim');
  }

  // ========================================
  // RESET PASSWORD
  // ========================================

  // Fungsi ini mengirim link pemulihan password.
  // Perubahan password sebenarnya dilakukan
  // melalui ResetPasswordPage.

  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email.trim().toLowerCase(),
        redirectTo: kIsWeb ? Uri.base.origin : null,
      );

      debugPrint('Link reset password berhasil dikirim');
    } catch (e) {
      debugPrint('Error reset password: $e');
      rethrow;
    }
  }

  // ========================================
  // GET USER PROFILE
  // ========================================

  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('user')
          .select()
          .eq('id_user', userId)
          .maybeSingle();

      if (data == null) {
        return null;
      }

      return UserModel.fromJson(data);
    } catch (e) {
      debugPrint('Error get profile: $e');
      return null;
    }
  }

  // ========================================
  // GET CURRENT USER
  // ========================================

  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // ========================================
  // LOGOUT
  // ========================================

  Future<void> logout() async {
    await _supabase.auth.signOut();

    debugPrint('Logout berhasil');
  }
}
