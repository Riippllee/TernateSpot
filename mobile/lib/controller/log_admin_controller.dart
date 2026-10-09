import '../service/log_admin_service.dart';
import '../model/log_admin_model.dart';

class LogAdminController {
  final service = LogAdminService();

  Future<void> tambahLog(LogAdmin log) {
    return service.tambahLog(log);
  }

  Future<List<LogAdmin>> lihatLog() {
    return service.getLog();
  }
}
