// Model ini digunakan untuk merepresentasikan data
// dari tabel rekomendasi di database Supabase
class Rekomendasi {
  // id_rekomendasi adalah primary key dari database
  // dibuat otomatis oleh Supabase, sehingga boleh kosong saat insert data
  final int? idRekomendasi;

  // id_destinasi digunakan untuk menghubungkan rekomendasi
  // dengan tabel destinasi melalui foreign key
  final int idDestinasi;

  // prioritas digunakan untuk menentukan urutan rekomendasi
  // contoh: prioritas 1 tampil paling atas
  final int prioritas;

  // status digunakan untuk menentukan apakah rekomendasi aktif atau tidak
  // true = tampil
  // false = tidak tampil
  final bool status;

  // tanggal dibuatnya data rekomendasi
  // nilainya dibuat otomatis oleh database
  final DateTime? tanggalDitambah;

  // Constructor digunakan untuk membuat objek Rekomendasi
  // ketika data akan digunakan di aplikasi Flutter
  Rekomendasi({
    this.idRekomendasi,

    required this.idDestinasi,

    required this.prioritas,

    required this.status,

    this.tanggalDitambah,
  });

  // Fungsi fromJson digunakan untuk mengubah data
  // dari format JSON Supabase menjadi object Flutter
  //
  // Contoh:
  // Data dari database:
  // {
  // "id_destinasi":1,
  // "prioritas":1
  // }
  //
  // akan diubah menjadi object Rekomendasi

  factory Rekomendasi.fromJson(Map<String, dynamic> json) {
    return Rekomendasi(
      idRekomendasi: json['id_rekomendasi'],

      idDestinasi: json['id_destinasi'],

      prioritas: json['prioritas'],

      status: json['status'],

      // Mengubah data tanggal dari database
      // menjadi format DateTime Flutter
      tanggalDitambah: json['tanggal_ditambah'] != null
          ? DateTime.parse(json['tanggal_ditambah'])
          : null,
    );
  }

  // Fungsi toJson digunakan untuk mengubah object Flutter
  // menjadi format JSON agar dapat dikirim ke Supabase
  //
  // Digunakan ketika:
  // - tambah data
  // - update data

  Map<String, dynamic> toJson() {
    return {
      // id_rekomendasi tidak dimasukkan
      // karena dibuat otomatis oleh database

      'id_destinasi': idDestinasi,

      'prioritas': prioritas,

      'status': status,
    };
  }
}
