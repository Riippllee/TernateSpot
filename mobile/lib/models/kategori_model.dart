class KategoriModel {
  final int idKategori;
  final String namaKategori;
  final DateTime tanggalDaftar;

  KategoriModel({
    required this.idKategori,
    required this.namaKategori,
    required this.tanggalDaftar,
  });

  // Convert dari JSON (database) ke Object Dart
  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      idKategori: json['id_kategori'],
      namaKategori: json['nama_kategori'],
      tanggalDaftar: DateTime.parse(json['tanggal_daftar']),
    );
  }

  // Convert dari Object Dart ke JSON (untuk insert/update ke database)
  Map<String, dynamic> toJson() {
    return {
      'nama_kategori': namaKategori,
    };
  }
}