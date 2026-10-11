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

  Future signUp(String nama, String email, String password) async {
    email = email.trim().toLowerCase();
    password = password.trim();

    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'nama': nama},
    );
    if (response.user != null) {
      //cmn uji
      print("EMAIL MASUK SERVICE: '$email'");
      print("PASSWORD: '$password'");

      try{
        await supabase.from('user').insert({
        'id_user': response.user!.id,
        'nama': nama,
        'email': email,
        'foto_profil': null,
        'role': 'user',
        'status': true,
      });
      }catch(e){
         print("Insert profile gagal: $e");
      }
      
    }

    return response;
  }

  Future<void> forgotPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
