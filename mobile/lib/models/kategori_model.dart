class KategoriModel {
  final int idKategori;
  final String namaKategori;
  final DateTime tanggalDaftar;

  KategoriModel({
    required this.idKategori,
    required this.namaKategori,
    required this.tanggalDaftar,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      idKategori: json['id_kategori'] ?? 0,
      namaKategori: json['nama_kategori'] ?? '',
      tanggalDaftar: json['tanggal_daftar'] != null 
          ? DateTime.parse(json['tanggal_daftar']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'nama_kategori': namaKategori};
  }
}