class DestinasiUserModel {
  final int idDestinasi;
  final int idKategori;
  final String namaDestinasi;
  final String deskripsi;
  final String alamat;
  final double latitude;
  final double longitude;
  final String fotoUtama;
  final bool status;
  final DateTime tanggalDaftar;
  final DateTime tanggalPerubahan;

  const DestinasiUserModel({
    required this.idDestinasi,
    required this.idKategori,
    required this.namaDestinasi,
    required this.deskripsi,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.fotoUtama,
    required this.status,
    required this.tanggalDaftar,
    required this.tanggalPerubahan,
  });

  static int _parseInt(dynamic value, String field) {
    if (value is num) return value.toInt();

    final result = int.tryParse(value?.toString() ?? '');

    if (result == null) {
      throw FormatException('Data $field tidak valid.');
    }

    return result;
  }

  static double _parseDouble(dynamic value, String field) {
    final result = value is num
        ? value.toDouble()
        : double.tryParse(value?.toString() ?? '');

    if (result == null || !result.isFinite) {
      throw FormatException('Data $field tidak valid.');
    }

    return result;
  }

  static bool _parseBool(dynamic value, String field) {
    if (value is bool) return value;

    if (value is num) return value != 0;

    final result = value?.toString().trim().toLowerCase();

    if (result == 'true' || result == '1' || result == 't') {
      return true;
    }

    if (result == 'false' || result == '0' || result == 'f') {
      return false;
    }

    throw FormatException('Data $field tidak valid.');
  }

  static String _parseString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static DateTime _parseDateTime(dynamic value, String field) {
    final result = DateTime.tryParse(value?.toString() ?? '');

    if (result == null) {
      throw FormatException('Data $field tidak valid.');
    }

    return result;
  }

  factory DestinasiUserModel.fromJson(Map<String, dynamic> json) {
    return DestinasiUserModel(
      idDestinasi: _parseInt(json['id_destinasi'], 'id_destinasi'),
      idKategori: _parseInt(json['id_kategori'], 'id_kategori'),
      namaDestinasi: _parseString(json['nama_destinasi']),
      deskripsi: _parseString(json['deskripsi']),
      alamat: _parseString(json['alamat']),
      latitude: _parseDouble(json['latitude'], 'latitude'),
      longitude: _parseDouble(json['longitude'], 'longitude'),
      fotoUtama: _parseString(json['foto_utama']),
      status: _parseBool(json['status'], 'status'),
      tanggalDaftar: _parseDateTime(json['tanggal_daftar'], 'tanggal_daftar'),
      tanggalPerubahan: _parseDateTime(
        json['tanggal_perubahan'],
        'tanggal_perubahan',
      ),
    );
  }
}