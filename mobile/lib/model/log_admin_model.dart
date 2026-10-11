// Class Model LogAdmin berfungsi sebagai representasi data
class LogAdmin {
  final int? idLog;
  final String idUser;
  final String aktivitas;
  final DateTime tanggalAktivitas;

  // Constructor untuk membuat object LogAdmin
  LogAdmin({
    this.idLog,
    required this.idUser,
    required this.aktivitas,
    required this.tanggalAktivitas,
  });

  // Factory constructor untuk mengubah data JSON dari Supabase
  // menjadi object LogAdmin yang dapat digunakan Flutter
  factory LogAdmin.fromJson(Map<String, dynamic> json) {
    return LogAdmin(
      idLog: json['id_log'], // Mengambil nilai id_log dari database
      idUser: json['id_user'],
      aktivitas: json['aktivitas'],

      // Mengubah format tanggal dari String JSON menjadi tipe DateTime
      tanggalAktivitas: DateTime.parse(json['tanggal_aktivitas']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Data yang dikirim saat insert log admin
      'id_user': idUser,
      'aktivitas': aktivitas,
    };
  }
}
