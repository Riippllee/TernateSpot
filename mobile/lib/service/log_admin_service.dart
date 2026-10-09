import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/log_admin_model.dart';

class LogAdminService {
  final supabase = Supabase.instance.client;

  Future<void> tambahLog(LogAdmin log) async {
    await supabase.from('log_admin').insert(log.toJson());
  }

  Future<List<LogAdmin>> getLog() async {
    final data = await supabase.from('log_admin').select();

    print("DATA LOG ADMIN:");
    print(data);

    return data.map((e) => LogAdmin.fromJson(e)).toList();
  }
}
