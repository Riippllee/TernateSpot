class GaleriModel {
  // Menyimpan informasi galeri
  final int idGaleri;
  final int idDestinasi;
  final String urlGambar;
  final String keterangan;
  final DateTime tanggalDibuat;

  // Constructor digunakan untuk membuat object GaleriModel
  GaleriModel({
    required this.idGaleri,
    required this.idDestinasi,
    required this.urlGambar,
    required this.keterangan,
    required this.tanggalDibuat,
  });

  // Factory constructor digunakan untuk mengubah data JSON dari database/API
  factory GaleriModel.fromJson(Map<String, dynamic> json) {
    return GaleriModel(
      idGaleri: json['id_galeri'] ?? 0,
      idDestinasi: json['id_destinasi'] ?? 0,
      urlGambar: json['url_gambar'] ?? '',
      keterangan: json['keterangan'] ?? '',

      // Mengubah data tanggal dari format String JSON menjadi DateTime
      tanggalDibuat: json['tanggal_dibuat'] != null
          ? DateTime.parse(json['tanggal_dibuat'])
          : DateTime.now(),
    );
  }

  // Fungsi toJson digunakan untuk mengubah object GaleriModel
  // menjadi format JSON agar dapat dikirim ke database/API
  Map<String, dynamic> toJson() {
    return {
      'id_destinasi': idDestinasi,
      'url_gambar': urlGambar,
      'keterangan': keterangan,
    };
  }
}
