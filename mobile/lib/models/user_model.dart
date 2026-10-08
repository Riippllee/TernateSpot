class UserModel {
  final String idUser;
  final String nama;
  final String email;
  final String? fotoProfil;
  final String role;
  final bool status;

  UserModel({
    required this.idUser,
    required this.nama,
    required this.email,
    this.fotoProfil,
    required this.role,
    required this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUser: json['id_user'],

      nama: json['nama'],

      email: json['email'],

      fotoProfil: json['foto_profil'],

      role: json['role'],

      status: json['status'],
    );
  }
}
