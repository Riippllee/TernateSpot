class LogAdmin {
  final int? idLog;
  final String idUser;
  final String aktivitas;
  final DateTime tanggalAktivitas;

  LogAdmin({
    this.idLog,
    required this.idUser,
    required this.aktivitas,
    required this.tanggalAktivitas,
  });

  factory LogAdmin.fromJson(Map<String, dynamic> json) {
    return LogAdmin(
      idLog: json['id_log'],
      idUser: json['id_user'],
      aktivitas: json['aktivitas'],
      tanggalAktivitas: DateTime.parse(json['tanggal_aktivitas']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id_user': idUser, 'aktivitas': aktivitas};
  }
}
