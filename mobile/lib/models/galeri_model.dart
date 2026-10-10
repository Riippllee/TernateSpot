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

  factory GaleriModel.fromJson(Map<String, dynamic> json) {
    return GaleriModel(
      idGaleri: json['id_galeri'] ?? 0,
      idDestinasi: json['id_destinasi'] ?? 0,
      urlGambar: json['url_gambar'] ?? '',
      keterangan: json['keterangan'] ?? '',
      tanggalDibuat: json['tanggal_dibuat'] != null ? DateTime.parse(json['tanggal_dibuat']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_destinasi': idDestinasi,
      'url_gambar': urlGambar,
      'keterangan': keterangan,
    };
  }
}