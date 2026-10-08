import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';


//user Servie
class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<UserModel?> getUserProfile(String userId) async {
    final data = await _supabase
        .from('user')
        .select()
        .eq('id_user', userId)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return UserModel.fromJson(data);
  }
}

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future login(String email, String password) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    print(response.user?.id);
    print(response.user?.email);

    return response;
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
