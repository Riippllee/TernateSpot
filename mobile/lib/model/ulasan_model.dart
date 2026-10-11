class Ulasan {
  final int? idUlasan;
  final String idUser;
  final int idDestinasi;
  final int rating;
  final String komentar;
  final bool status;
  final DateTime? tanggalDitambah;
  final DateTime? tanggalPerubahan;

  // Constructor digunakan untuk membuat object Ulasan pada Flutter

  Ulasan({
    this.idUlasan,
    required this.idUser,
    required this.idDestinasi,
    required this.rating,
    required this.komentar,
    required this.status,
    this.tanggalDitambah,
    this.tanggalPerubahan,
  });

  // fromJson digunakan untuk mengubah data JSON dari Supabase menjadi object Flutter

  factory Ulasan.fromJson(Map<String, dynamic> json) {
    return Ulasan(
      idUlasan: json['id_ulasan'],
      idUser: json['id_user'],
      idDestinasi: json['id_destinasi'],
      rating: json['rating'],
      komentar: json['komentar'],
      status: json['status'],
      tanggalDitambah: json['tanggal_ditambah'] != null
          ? DateTime.parse(json['tanggal_ditambah'])
          : null,

      tanggalPerubahan: json['tanggal_perubahan'] != null
          ? DateTime.parse(json['tanggal_perubahan'])
          : null,
    );
  }

  // toJson digunakan untuk mengubah object Flutter menjadi JSON
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'id_destinasi': idDestinasi,
      'rating': rating,
      'komentar': komentar,
      'status': status,
    };
  }
}
