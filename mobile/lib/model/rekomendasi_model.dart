class Rekomendasi {
  // Data sesuai kolom tabel rekomendasi
  final int? idRekomendasi;
  final int idDestinasi;
  final int prioritas;
  final bool status;
  final DateTime? tanggalDitambah;

  // Constructor untuk membuat objek Rekomendasi
  Rekomendasi({
    this.idRekomendasi,
    required this.idDestinasi,
    required this.prioritas,
    required this.status,
    this.tanggalDitambah,
  });

  // Mengubah data JSON Supabase menjadi objek Dart
  factory Rekomendasi.fromJson(Map<String, dynamic> json) {
    return Rekomendasi(
      idRekomendasi: json['id_rekomendasi'],
      idDestinasi: json['id_destinasi'],
      prioritas: json['prioritas'],
      status: json['status'],
      tanggalDitambah: json['tanggal_ditambah'] != null
          ? DateTime.parse(json['tanggal_ditambah'])
          : null,
    );
  }
}
