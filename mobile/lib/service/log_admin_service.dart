import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/log_admin_model.dart';

class LogAdminService {
  // Mengambil koneksi Supabase yang sudah diinisialisasi pada main.dart
  // sehingga Service dapat mengakses tabel yang ada pada database
  final supabase = Supabase.instance.client;

  // Mengakses tabel log_admin pada Supabase
  Future<void> tambahLog(LogAdmin log) async {
    await supabase.from('log_admin').insert(log.toJson());
  }

  // Fungsi untuk mengambil seluruh data log admin dari database
  Future<List<LogAdmin>> getLog() async {
    final data = await supabase.from('log_admin').select();

    print("DATA LOG ADMIN:");
    print(data);

    return data.map((e) => LogAdmin.fromJson(e)).toList();
  }
}
