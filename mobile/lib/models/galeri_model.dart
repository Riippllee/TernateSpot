class GaleriModel {
  final int idGaleri;
  final int idDestinasi;
  final String urlGambar;
  final String keterangan;
  final DateTime tanggalDibuat;

  GaleriModel({
    required this.idGaleri,
    required this.idDestinasi,
    required this.urlGambar,
    required this.keterangan,
    required this.tanggalDibuat,
  });

  // Convert dari JSON (database) ke Object Dart
  factory GaleriModel.fromJson(Map<String, dynamic> json) {
    return GaleriModel(
      idGaleri: json['id_galeri'],
      idDestinasi: json['id_destinasi'],
      urlGambar: json['url_gambar'],
      keterangan: json['keterangan'] ?? '',
      tanggalDibuat: DateTime.parse(json['tanggal_dibuat']),
    );
  }

  // Convert dari Object Dart ke JSON (untuk insert)
  Map<String, dynamic> toJson() {
    return {
      'id_destinasi': idDestinasi,
      'url_gambar': urlGambar,
      'keterangan': keterangan,
    };
  }
}