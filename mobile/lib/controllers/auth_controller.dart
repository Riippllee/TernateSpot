import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

// ==========================================
// USER CONTROLLER
// ==========================================

class UserController {
  final UserService _service = UserService();

  Future<UserModel?> getProfile(String userId) async {
    return await _service.getUserProfile(userId);
  }
}

// ==========================================
// AUTH CONTROLLER
// ==========================================

class AuthController {
  final AuthService _authService = AuthService();

  // LOGIN EMAIL & PASSWORD
  Future<AuthResponse> login(String email, String password) async {
    if (email.trim().isEmpty) {
      throw Exception('Email tidak boleh kosong');
    }

    if (password.isEmpty) {
      throw Exception('Password tidak boleh kosong');
    }

    return await _authService.login(email.trim().toLowerCase(), password);
  }

  // LOGIN GOOGLE
  Future<void> loginWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      debugPrint('Error Google Login: $e');
      rethrow;
    }
  }

  // REGISTER
  Future<AuthResponse> register(
    String nama,
    String email,
    String password,
  ) async {
    if (nama.trim().isEmpty) {
      throw Exception('Nama tidak boleh kosong');
    }

    if (email.trim().isEmpty) {
      throw Exception('Email tidak boleh kosong');
    }

    if (password.isEmpty) {
      throw Exception('Password tidak boleh kosong');
    }

    return await _authService.signUp(
      nama.trim(),
      email.trim().toLowerCase(),
      password,
    );
  }

  // FORGOT PASSWORD
  Future<void> forgotPassword(String email) async {
    if (email.trim().isEmpty) {
      throw Exception('Email tidak boleh kosong');
    }

    await _authService.forgotPassword(email.trim().toLowerCase());
  }

  // RESET PASSWORD - MENGIRIM LINK RESET
  Future<bool> resetPassword(String email) async {
    if (email.trim().isEmpty) {
      return false;
    }

    try {
      await _authService.resetPassword(email.trim().toLowerCase());

      return true;
    } catch (e) {
      debugPrint('Error reset password: $e');
      return false;
    }
  }
}
