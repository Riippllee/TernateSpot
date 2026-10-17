import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../controllers/user_management_controller.dart';

class TestUserManagementPage extends StatelessWidget {
  TestUserManagementPage({super.key});

  final UserManagementController controller = UserManagementController();

  // TEST GET ALL USER
  void testUsers() async {
    final users = await controller.getAllUsers();

    for (var user in users) {
      print("${user.nama} - ${user.email} - ${user.role}");
    }
  }

  // TEST GET DETAIL USER
  void testDetailUser() async {
    final user = await controller.getUserById(
      "51377400-0e24-4e4a-9c5c-681e98a4a8d3",
    );

    print(user?.nama);
    print(user?.email);
    print(user?.role);
  }

  void testUpdateStatus() async {
    print("MULAI UPDATE STATUS");

    await controller.updateUserStatus(
      "51377400-0e24-4e4a-9c5c-681e98a4a8d3",
      false,
    );

    print("SELESAI UPDATE STATUS");
  }

  Future<void> testDeleteUser() async {
    const testUserId = '51377400-0e24-4e4a-9c5c-681e98a4a8d3';

    try {
      print('MULAI DELETE USER: $testUserId');

      await controller.deleteUserProfile(testUserId);

      print('Permintaan Edge Function berhasil.');

      final user = await controller.getUserById(testUserId);

      if (user == null) {
        print('VERIFIKASI: Profil tidak ditemukan lagi.');
      } else {
        print('VERIFIKASI: Profil masih ditemukan.');
      }
    } catch (e, stackTrace) {
      print('DELETE GAGAL: $e');
      print(stackTrace);
    }
  }

  void checkLoginSession() {
    final user = Supabase.instance.client.auth.currentUser;

    print('USER LOGIN: ${user?.email}');
    print('USER ID: ${user?.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            ElevatedButton(
              onPressed: testUsers,

              child: const Text("Load Semua User"),
            ),

            ElevatedButton(
              onPressed: testDetailUser,

              child: const Text("Load Detail User"),
            ),

            ElevatedButton(
              onPressed: testUpdateStatus,

              child: const Text("Update Status User"),
            ),

            ElevatedButton(
              onPressed: testDeleteUser,
              child: const Text('Test Delete User'),
            ),

            ElevatedButton(
              onPressed: checkLoginSession,
              child: const Text('Cek Session'),
            ),
          ],
        ),
      ),
    );
  }
}
