class UlasanUserModel {
  final int idUlasan;
  final String idUser;
  final int idDestinasi;
  final int rating;
  final String komentar;
  final bool status;
  final DateTime tanggalDitambah;
  final DateTime? tanggalPerubahan;
  final String nama;
  final String? fotoProfil;
  final String namaDestinasi;

  UlasanUserModel({
    required this.idUlasan,
    required this.idUser,
    required this.idDestinasi,
    required this.rating,
    required this.komentar,
    required this.status,
    required this.tanggalDitambah,
    this.tanggalPerubahan,
    this.nama = 'Pengguna',
    this.fotoProfil,
    this.namaDestinasi = 'Destinasi',
  });

  String get namaPengguna => nama;

  factory UlasanUserModel.fromJson(Map<String, dynamic> json) {
    final profil = json['profil'] is Map
        ? Map<String, dynamic>.from(json['profil'])
        : <String, dynamic>{};

    final destinasi = json['destinasi'] is Map
        ? Map<String, dynamic>.from(json['destinasi'])
        : <String, dynamic>{};

    final idDestinasi = (json['id_destinasi'] as num).toInt();

    return UlasanUserModel(
      idUlasan: (json['id_ulasan'] as num).toInt(),
      idUser: json['id_user']?.toString() ?? '',
      idDestinasi: idDestinasi,
      rating: (json['rating'] as num).toInt(),
      komentar: json['komentar']?.toString() ?? '',
      status: json['status'] ?? true,
      tanggalDitambah:
          DateTime.tryParse(json['tanggal_ditambah']?.toString() ?? '') ??
          DateTime.now(),
      tanggalPerubahan: json['tanggal_perubahan'] != null
          ? DateTime.tryParse(json['tanggal_perubahan'].toString())
          : null,
      nama: profil['nama']?.toString() ?? 'Pengguna',
      fotoProfil: profil['foto_profil']?.toString(),
      namaDestinasi:
          destinasi['nama_destinasi']?.toString() ??
          json['nama_destinasi']?.toString() ??
          'Destinasi #$idDestinasi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ulasan': idUlasan,
      'id_user': idUser,
      'id_destinasi': idDestinasi,
      'rating': rating,
      'komentar': komentar,
      'status': status,
      'tanggal_ditambah': tanggalDitambah.toIso8601String(),
      'tanggal_perubahan': tanggalPerubahan?.toIso8601String(),
      'profil': {'nama': nama, 'foto_profil': fotoProfil},
      'destinasi': {'nama_destinasi': namaDestinasi},
    };
  }

  UlasanUserModel copyWith({
    int? idUlasan,
    String? idUser,
    int? idDestinasi,
    int? rating,
    String? komentar,
    bool? status,
    DateTime? tanggalDitambah,
    DateTime? tanggalPerubahan,
    String? nama,
    String? fotoProfil,
    String? namaDestinasi,
  }) {
    return UlasanUserModel(
      idUlasan: idUlasan ?? this.idUlasan,
      idUser: idUser ?? this.idUser,
      idDestinasi: idDestinasi ?? this.idDestinasi,
      rating: rating ?? this.rating,
      komentar: komentar ?? this.komentar,
      status: status ?? this.status,
      tanggalDitambah: tanggalDitambah ?? this.tanggalDitambah,
      tanggalPerubahan: tanggalPerubahan ?? this.tanggalPerubahan,
      nama: nama ?? this.nama,
      fotoProfil: fotoProfil ?? this.fotoProfil,
      namaDestinasi: namaDestinasi ?? this.namaDestinasi,
    );
  }
}
