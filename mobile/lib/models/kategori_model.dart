class KategoriModel {
  // Menyimpan informasi kategori
  final int idKategori;
  final String namaKategori;
  final DateTime tanggalDaftar;

  // Constructor digunakan untuk membuat object KategoriModel
  KategoriModel({
    required this.idKategori,
    required this.namaKategori,
    required this.tanggalDaftar,
  });

  // Factory constructor digunakan untuk mengubah data JSON dari database/API
  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      idKategori: json['id_kategori'] ?? 0,
      namaKategori: json['nama_kategori'] ?? '',

      // Mengubah data tanggal dari format String JSON menjadi DateTime
      tanggalDaftar: json['tanggal_daftar'] != null
          ? DateTime.parse(json['tanggal_daftar'])
          : DateTime.now(),
    );
  }

  // Fungsi toJson digunakan untuk mengubah object KategoriModel
  // menjadi format JSON agar dapat dikirim ke database/API
  Map<String, dynamic> toJson() {
    return {'nama_kategori': namaKategori};
  }
}
