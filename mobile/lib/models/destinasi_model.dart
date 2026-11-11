class DestinasiModel {
  final int idDestinasi;
  final int idKategori;
  final String namaDestinasi;
  final String deskripsi;
  final String alamat;
  final double latitude;
  final double longitude;
  final String fotoUtama;
  final bool status;
  final DateTime tanggalDaftar;
  final DateTime tanggalPerubahan;

  DestinasiModel({
    required this.idDestinasi,
    required this.idKategori,
    required this.namaDestinasi,
    required this.deskripsi,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.fotoUtama,
    required this.status,
    required this.tanggalDaftar,
    required this.tanggalPerubahan,
  });

  // Convert dari JSON (database) ke Object Dart
  factory DestinasiModel.fromJson(Map<String, dynamic> json) {
    return DestinasiModel(
      idDestinasi: json['id_destinasi'],
      idKategori: json['id_kategori'],
      namaDestinasi: json['nama_destinasi'],
      deskripsi: json['deskripsi'] ?? '',
      alamat: json['alamat'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      fotoUtama: json['foto_utama'] ?? '',
      status: json['status'] ?? false,
      tanggalDaftar: DateTime.parse(json['tanggal_daftar']),
      tanggalPerubahan: DateTime.parse(json['tanggal_perubahan']),
    );
  }

  // Convert dari Object Dart ke JSON (untuk insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id_kategori': idKategori,
      'nama_destinasi': namaDestinasi,
      'deskripsi': deskripsi,
      'alamat': alamat,
      'latitude': latitude,
      'longitude': longitude,
      'foto_utama': fotoUtama,
      'status': status,
    };
  }
}
