import 'dart:typed_data';
import '../models/destinasi_model.dart';
import '../models/kategori_model.dart';
import '../services/destinasi_service.dart';

class DestinasiController {
  final DestinasiService _service = DestinasiService();

  Future<List<DestinasiModel>> getDestinasi() async {
    return await _service.getAllDestinasi();
  }

  Future<List<KategoriModel>> getKategori() async {
    return await _service.getAllKategori();
  }

  Future<bool> tambahDestinasiLengkap({
    required int idKategori,
    required String nama,
    required String deskripsi,
    required String alamat,
    required double latitude,
    required double longitude,
    required Uint8List fotoBytes,
  }) async {
    try {
      String fotoUrl = await _service.uploadGambar(fotoBytes, 'foto-destinasi');

      final destinasi = DestinasiModel(
        idDestinasi: 0, 
        idKategori: idKategori,
        namaDestinasi: nama,
        deskripsi: deskripsi,
        alamat: alamat,
        latitude: latitude,
        longitude: longitude,
        fotoUtama: fotoUrl,
        status: true,
        tanggalDaftar: DateTime.now(),
        tanggalPerubahan: DateTime.now(),
      );

      await _service.tambahDestinasi(destinasi);
      return true; 
    } catch (e) {
      print("❌ Error: $e");
      return false; 
    }
  }

  Future<bool> hapusDestinasi(int id) async {
    try {
      await _service.hapusDestinasi(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> tambahKategori(String namaKategori) async {
    try {
      final kategori = KategoriModel(
        idKategori: 0,
        namaKategori: namaKategori,
        tanggalDaftar: DateTime.now(),
      );
      await _service.tambahKategori(kategori);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> uploadGambar(Uint8List fileBytes, String bucketName) async {
    try {
      final url = await _service.uploadGambar(fileBytes, bucketName);
      return url;
    } catch (e) {
      print("❌ Error upload gambar: $e");
      return null;
    }
  }
}