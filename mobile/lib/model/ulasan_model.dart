// Model ini digunakan untuk merepresentasikan
// data ulasan dari database Supabase

class Ulasan {
  // Primary key dari tabel ulasan
  // Dibuat otomatis oleh database
  final int? idUlasan;

  // Foreign key yang menghubungkan ulasan
  // dengan user yang memberikan ulasan
  final String idUser;

  // Foreign key yang menghubungkan ulasan
  // dengan destinasi yang diberikan review
  final int idDestinasi;

  // Nilai rating destinasi
  // contoh: 1 sampai 5
  final int rating;

  // Isi komentar atau review pengguna
  final String komentar;

  // Status ulasan
  // true = aktif/tampil
  // false = tidak ditampilkan
  final bool status;

  // Waktu ulasan dibuat
  final DateTime? tanggalDitambah;

  // Waktu ulasan terakhir diperbarui
  final DateTime? tanggalPerubahan;

  // Constructor digunakan untuk membuat
  // object Ulasan pada Flutter

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

  // fromJson digunakan untuk mengubah
  // data JSON dari Supabase menjadi object Flutter

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

  // toJson digunakan untuk mengubah
  // object Flutter menjadi JSON
  // agar dapat dikirim ke Supabase

  Map<String, dynamic> toJson() {
    return {
      // id_ulasan tidak dikirim
      // karena dibuat otomatis database

      'id_user': idUser,

      'id_destinasi': idDestinasi,

      'rating': rating,

      'komentar': komentar,

      'status': status,
    };
  }
}
