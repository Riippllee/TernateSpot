class Rekomendasi {
  final int? idRekomendasi;
  final int idDestinasi;
  final int prioritas;
  final bool status; // status digunakan untuk menentukan apakah rekomendasi aktif atau tidak
  final DateTime? tanggalDitambah; //otomatis ditambahkan

  // Constructor digunakan untuk membuat objek Rekomendasi
  Rekomendasi({
    this.idRekomendasi,
    required this.idDestinasi,
    required this.prioritas,
    required this.status,
    this.tanggalDitambah,
  });

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

  // Fungsi toJson digunakan untuk mengubah object Flutter
  // menjadi format JSON agar dapat dikirim ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'id_destinasi': idDestinasi,
      'prioritas': prioritas,
      'status': status,
    };
  }
}
