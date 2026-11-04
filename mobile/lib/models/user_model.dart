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
      idUser: json['id_user'],
      nama: json['nama'],
      email: json['email'],
      fotoProfil: json['foto_profil'],
      role: json['role'],
      status: json['status'] ?? true,
      tanggalDaftar: json['tanggal_daftar'] != null
          ? DateTime.parse(json['tanggal_daftar'])
          : null,
      tanggalPerubahan: json['tanggal_perubahan'] != null
          ? DateTime.parse(json['tanggal_perubahan'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'nama': nama,
      'email': email,
      'foto_profil': fotoProfil,
      'role': role,
      'status': status,
      'tanggal_perubahan': DateTime.now().toIso8601String(),
    };
  }

  UserModel copyWith({
    String? idUser,
    String? nama,
    String? email,
    String? fotoProfil,
    String? role,
    bool? status,
  }) {
    return UserModel(
      idUser: idUser ?? this.idUser,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      fotoProfil: fotoProfil ?? this.fotoProfil,
      role: role ?? this.role,
      status: status ?? this.status,
      tanggalDaftar: tanggalDaftar,
      tanggalPerubahan: DateTime.now(),
    );
  }
}
