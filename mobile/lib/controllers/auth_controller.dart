import '../services/auth_service.dart';
import '../models/user_model.dart';

class UserController {
  final UserService _service = UserService();

  Future<UserModel?> getProfile(String userId) async {
    return await _service.getUserProfile(userId);
  }
}

class AuthController {
  final AuthService _authService = AuthService();

  Future login(String email, String password) async {
    if (email.isEmpty) {
      throw Exception("Email tidak boleh kosong");
    }

    if (password.isEmpty) {
      throw Exception("Password tidak boleh kosong");
    }

    final response = await _authService.login(email, password);

    return response;
  }
}
