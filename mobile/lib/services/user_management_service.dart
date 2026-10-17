import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

class UserManagementService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<UserModel>> getAllUsers() async {
    final data = await _supabase.from('user').select();

    return data.map<UserModel>((json) => UserModel.fromJson(json)).toList();
  }

  Future<UserModel?> getUserById(String idUser) async {
    final data = await _supabase
        .from('user')
        .select()
        .eq('id_user', idUser)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return UserModel.fromJson(data);
  }

  Future<void> updateUserStatus(String idUser, bool status) async {
    print("SERVICE UPDATE:");
    print(idUser);
    print(status);

    final response = await _supabase
        .from('user')
        .update({'status': status})
        .eq('id_user', idUser)
        .select();

    print("HASIL UPDATE:");
    print(response);
  }

  Future<void> deleteUserProfile(String idUser) async {
    print('SERVICE DELETE ACCOUNT: $idUser');

    final response = await _supabase.functions.invoke(
      'delete-user',
      body: {'userId': idUser},
    );

    print('HASIL DELETE ACCOUNT: ${response.data}');

    print('Akun dan profil berhasil dihapus.');
  }
}
