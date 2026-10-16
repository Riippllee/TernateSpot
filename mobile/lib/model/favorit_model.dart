class Favorit {
  // Menyimpan data sesuai kolom tabel favorit di Supabase
  final int? idFavorit;
  final String idUser;
  final int idDestinasi;
  final DateTime? tanggalDitambah;

  // Constructor untuk membuat objek Favorit
  Favorit({
    this.idFavorit,
    required this.idUser,
    required this.idDestinasi,
    this.tanggalDitambah,
  });

  // Mengubah data JSON dari Supabase menjadi objek Dart
  factory Favorit.fromJson(Map<String, dynamic> json) {
    return Favorit(
      idFavorit: json['id_favorit'],
      idUser: json['id_user'],
      idDestinasi: json['id_destinasi'],
      tanggalDitambah: json['tanggal_ditambah'] != null
          ? DateTime.parse(json['tanggal_ditambah'])
          : null,
    );
  }

  // Mengubah objek Dart menjadi JSON untuk dikirim ke Supabase
  Map<String, dynamic> toJson() {
    return {'id_user': idUser, 'id_destinasi': idDestinasi};
  }
}
