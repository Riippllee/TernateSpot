import '../models/user_model.dart';
import '../services/user_management_service.dart';

class UserManagementController {
  final UserManagementService _service = UserManagementService();

  Future<List<UserModel>> getAllUsers() async {
    return await _service.getAllUsers();
  }

  Future<UserModel?> getUserById(String idUser) async {
    return await _service.getUserById(idUser);
  }

  Future<void> updateUserStatus(String idUser, bool status) async {
    print("CONTROLLER UPDATE DIPANGGIL");

    await _service.updateUserStatus(idUser, status);

    print("CONTROLLER SELESAI");
  }

  Future<void> deleteUserProfile(String idUser) async {
    await _service.deleteUserProfile(idUser);
  }
}
