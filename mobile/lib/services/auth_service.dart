import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // LOGIN EMAIL & PASSWORD
  Future<AuthResponse> login(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return response;
  }

  // LOGIN DENGAN GOOGLE
  Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: Uri.base.origin,
      );

      debugPrint('Proses login Google dimulai');
    } catch (e) {
      debugPrint('Error Google Login: $e');
      rethrow;
    }
  }

  // REGISTER / SIGN UP
  Future<AuthResponse> signUp(
    String nama,
    String email,
    String password,
  ) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'nama': nama},
    );

    return response;
  }

  // FORGOT PASSWORD
  Future<void> forgotPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: Uri.base.origin,
    );
  }

  // RESET PASSWORD
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: Uri.base.origin,
      );

      debugPrint('Link reset password berhasil dikirim');
      debugPrint('Redirect URL: ${Uri.base.origin}');
    } catch (e) {
      debugPrint('Error reset password: $e');
      throw Exception('Gagal mengirim link reset: $e');
    }
  }

  // GET USER PROFILE
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('user')
          .select()
          .eq('id_user', userId)
          .maybeSingle();

      if (data == null) return null;

      return UserModel.fromJson(data);
    } catch (e) {
      debugPrint('Error get profile: $e');
      return null;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }

  // GET CURRENT USER
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}
