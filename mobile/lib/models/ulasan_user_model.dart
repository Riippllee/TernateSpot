class UlasanUserModel {
  final int idUlasan;
  final String idUser;
  final int idDestinasi;
  final int rating;
  final String komentar;
  final bool status;
  final DateTime tanggalDitambah;
  final DateTime tanggalPerubahan;

  // Informasi profil pengulas
  final String namaPengguna;
  final String? fotoProfil;

  const UlasanUserModel({
    required this.idUlasan,
    required this.idUser,
    required this.idDestinasi,
    required this.rating,
    required this.komentar,
    required this.status,
    required this.tanggalDitambah,
    required this.tanggalPerubahan,
    this.namaPengguna = 'Pengunjung',
    this.fotoProfil,
  });

  // Mengambil informasi profil dari JSON
  static Map<String, dynamic>? _ambilProfil(Map<String, dynamic> json) {
    final dynamic dataProfil = json['profil'] ?? json['user'];

    if (dataProfil is Map) {
      return Map<String, dynamic>.from(dataProfil);
    }

    if (dataProfil is List && dataProfil.isNotEmpty) {
      if (dataProfil.first is Map) {
        return Map<String, dynamic>.from(dataProfil.first);
      }
    }

    return null;
  }

  // Mengolah nilai opsional
  static String? _nilaiOpsional(dynamic value) {
    if (value == null) return null;

    final hasil = value.toString().trim();

    if (hasil.isEmpty || hasil.toLowerCase() == 'null') {
      return null;
    }

    return hasil;
  }

  // Mengubah nilai menjadi integer
  static int _nilaiInteger(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString()) ?? 0;
  }

  // Mengubah nilai menjadi DateTime
  static DateTime _nilaiTanggal(dynamic value) {
    return DateTime.tryParse(value.toString()) ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }

  // Mengubah JSON Supabase menjadi Model
  factory UlasanUserModel.fromJson(Map<String, dynamic> json) {
    final profil = _ambilProfil(json);

    return UlasanUserModel(
      idUlasan: _nilaiInteger(json['id_ulasan']),

      idUser: json['id_user']?.toString() ?? '',

      idDestinasi: _nilaiInteger(json['id_destinasi']),

      rating: _nilaiInteger(json['rating']),

      komentar: json['komentar']?.toString() ?? '',

      status: json['status'] == true,

      tanggalDitambah: _nilaiTanggal(json['tanggal_ditambah']),

      tanggalPerubahan: _nilaiTanggal(json['tanggal_perubahan']),

      namaPengguna:
          _nilaiOpsional(profil?['nama']) ??
          _nilaiOpsional(json['nama_pengguna']) ??
          'Pengunjung',

      fotoProfil:
          _nilaiOpsional(profil?['foto_profil']) ??
          _nilaiOpsional(json['foto_profil']),
    );
  }
}
