import '../service/log_admin_service.dart';
import '../model/log_admin_model.dart';

// Controller berfungsi sebagai penghubung antara View dan Service
class LogAdminController {
  final service = LogAdminService(); // Membuat objek Service

  // Fungsi untuk menambahkan data log admin
  Future<void> tambahLog(LogAdmin log) {
    return service.tambahLog(log);
  }

  // Fungsi untuk mengambil data log admin
  Future<List<LogAdmin>> lihatLog() {
    return service.getLog();
  }
}
