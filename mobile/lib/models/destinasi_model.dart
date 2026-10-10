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

  factory DestinasiModel.fromJson(Map<String, dynamic> json) {
    return DestinasiModel(
      idDestinasi: json['id_destinasi'] ?? 0,
      idKategori: json['id_kategori'] ?? 1,
      namaDestinasi: json['nama_destinasi'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      alamat: json['alamat'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      fotoUtama: json['foto_utama'] ?? '',
      status: json['status'] ?? true,
      tanggalDaftar: json['tanggal_daftar'] != null ? DateTime.parse(json['tanggal_daftar']) : DateTime.now(),
      tanggalPerubahan: json['tanggal_perubahan'] != null ? DateTime.parse(json['tanggal_perubahan']) : DateTime.now(),
    );
  }

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