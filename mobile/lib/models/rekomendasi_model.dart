class RekomendasiModel {
  final int? idRekomendasi;
  final int idDestinasi;
  final int prioritas;
  final bool status;
  final DateTime? tanggalDitambahkan;

  RekomendasiModel({
    this.idRekomendasi,
    required this.idDestinasi,
    required this.prioritas,
    required this.status,
    this.tanggalDitambahkan,
  });

  // Mengambil data dari Supabase.
  factory RekomendasiModel.fromJson(Map<String, dynamic> json) {
    return RekomendasiModel(
      idRekomendasi: json['id_rekomendasi'] as int?,
      idDestinasi: json['id_destinasi'] as int,
      prioritas: (json['prioritas'] as num).toInt(),
      status: json['status'] as bool,
      tanggalDitambahkan: json['tanggal_ditambahkan'] != null
          ? DateTime.parse(json['tanggal_ditambahkan'])
          : null,
    );
  }

  // Mengirim data rekomendasi ke Supabase.
  Map<String, dynamic> toJson() {
    return {
      'id_destinasi': idDestinasi,
      'prioritas': prioritas,
      'status': status,
    };
  }
}
