import '../services/auth_service.dart';
import '../models/user_model.dart';

class UserController {
  final AuthService _service = AuthService();

  // Get User Profile
  Future<UserModel?> getProfile(String userId) async {
    return await _service.getUserProfile(userId);
  }
}

class AuthController {
  final AuthService _authService = AuthService();

  // LOGIN EMAIL & PASSWORD
  Future login(String email, String password) async {
    if (email.trim().isEmpty) {
      throw Exception("Email tidak boleh kosong");
    }

    if (password.isEmpty) {
      throw Exception("Password tidak boleh kosong");
    }

    return await _authService.login(email.trim(), password);
  }

  // LOGIN DENGAN GOOGLE
  Future<void> loginWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      print('Error Google Login: $e');
      rethrow;
    }
  }

  // REGISTER
  Future register(String nama, String email, String password) async {
    if (nama.trim().isEmpty) {
      throw Exception("Nama tidak boleh kosong");
    }

    if (email.trim().isEmpty) {
      throw Exception("Email tidak boleh kosong");
    }

    if (password.isEmpty) {
      throw Exception("Password tidak boleh kosong");
    }

    return await _authService.signUp(nama.trim(), email.trim(), password);
  }

  // FORGOT PASSWORD
  Future<void> forgotPassword(String email) async {
    if (email.trim().isEmpty) {
      throw Exception("Email tidak boleh kosong");
    }

    await _authService.forgotPassword(email.trim());
  }

  // RESET PASSWORD
  Future<bool> resetPassword(String email) async {
    if (email.trim().isEmpty) {
      return false;
    }

    try {
      await _authService.resetPassword(email.trim());
      return true;
    } catch (e) {
      print('Error reset password: $e');
      return false;
    }
  }
}
