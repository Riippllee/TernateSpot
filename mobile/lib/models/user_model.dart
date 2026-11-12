class UserModel {
  final String idUser;
  final String nama;
  final String email;
  final String? fotoProfil;
  final String role;
  final bool status;
  final DateTime? tanggalDaftar;
  final DateTime? tanggalPerubahan;

  UserModel({
    required this.idUser,
    required this.nama,
    required this.email,
    this.fotoProfil,
    required this.role,
    required this.status,
    this.tanggalDaftar,
    this.tanggalPerubahan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'] as String,
      nama: json['nama'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fotoProfil: json['foto_profil'] as String?,
      role: json['role'] as String? ?? 'user',
      status: json['status'] as bool? ?? false,
      tanggalDaftar: _parseDate(json['tanggal_daftar']),
      tanggalPerubahan: _parseDate(json['tanggal_perubahan']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value.toString())?.toUtc();
  }
}
