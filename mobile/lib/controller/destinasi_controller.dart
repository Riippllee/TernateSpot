import 'dart:typed_data';

import '../models/destinasi_model.dart';
import '../models/kategori_model.dart';
import '../services/destinasi_service.dart';

// Controller digunakan untuk mengatur proses data destinasi
// antara tampilan (UI) dengan service/database
class DestinasiController {
  // Membuat objek service untuk memanggil fungsi database
  final DestinasiService _service = DestinasiService();

  // Fungsi untuk mengambil semua data destinasi
  Future<List<DestinasiModel>> getDestinasi() async {
    return await _service.getAllDestinasi();
  }

  // Fungsi untuk mengambil semua data kategori
  Future<List<KategoriModel>> getKategori() async {
    return await _service.getAllKategori();
  }

  // Fungsi untuk menambahkan data destinasi lengkap
  // Meliputi data destinasi dan upload gambar
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
      // Upload gambar terlebih dahulu dan mengambil URL gambar
      String fotoUrl = await _service.uploadGambar(fotoBytes, 'foto-destinasi');

      // Membuat object Destinasi untuk dikirim ke database
      final destinasi = DestinasiModel(
        idDestinasi: 0, // ID otomatis dibuat oleh database
        idKategori: idKategori,
        namaDestinasi: nama,
        deskripsi: deskripsi,
        alamat: alamat,
        latitude: latitude,
        longitude: longitude,
        fotoUtama: fotoUrl, // Menyimpan URL gambar
        status: true, // Status aktif destinasi
        tanggalDaftar: DateTime.now(), // Waktu data dibuat
        tanggalPerubahan: DateTime.now(), // Waktu perubahan data
      );

      // Menyimpan data destinasi ke database
      await _service.tambahDestinasi(destinasi);

      return true; // Proses berhasil
    } catch (e) {
      // Menampilkan pesan error jika proses gagal
      print("❌ Error: $e");

      return false; // Proses gagal
    }
  }

  // Fungsi untuk menghapus destinasi berdasarkan ID
  Future<bool> hapusDestinasi(int id) async {
    try {
      // Memanggil fungsi hapus dari service
      await _service.hapusDestinasi(id);

      return true; // Data berhasil dihapus
    } catch (e) {
      return false; // Gagal menghapus data
    }
  }

  // Fungsi untuk menambahkan kategori baru
  Future<bool> tambahKategori(String namaKategori) async {
    try {
      // Membuat object kategori baru
      final kategori = KategoriModel(
        idKategori: 0, // ID otomatis dibuat database
        namaKategori: namaKategori,
        tanggalDaftar: DateTime.now(),
      );

      // Menyimpan kategori ke database
      await _service.tambahKategori(kategori);

      return true; // Kategori berhasil ditambahkan
    } catch (e) {
      return false; // Gagal menambahkan kategori
    }
  }

  // Fungsi upload gambar ke penyimpanan
  // Mengembalikan URL gambar jika berhasil
  Future<String?> uploadGambar(Uint8List fileBytes, String bucketName) async {
    try {
      // Memanggil service upload gambar
      final url = await _service.uploadGambar(fileBytes, bucketName);
      return url; // Mengembalikan alamat gambar
    } catch (e) {
      // Menampilkan error upload gambar
      print("❌ Error upload gambar: $e");
      return null; // Upload gagal
    }
  }
}
