class KategoriUserModel {
  final int idKategori;
  final String namaKategori;
  final DateTime tanggalDaftar;

  const KategoriUserModel({
    required this.idKategori,
    required this.namaKategori,
    required this.tanggalDaftar,
  });

  factory KategoriUserModel.fromJson(Map<String, dynamic> json) {
    return KategoriUserModel(
      idKategori: (json['id_kategori'] as num).toInt(),
      namaKategori: json['nama_kategori'].toString(),
      tanggalDaftar: DateTime.parse(json['tanggal_daftar'].toString()),
    );
  }
}