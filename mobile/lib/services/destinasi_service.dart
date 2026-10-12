import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/destinasi_model.dart';
import '../models/kategori_model.dart';

// Class service yang menangani proses CRUD data destinasi
class DestinasiService {
  // Membuat koneksi ke Supabase Client
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fungsi untuk mengambil seluruh data destinasi dari database
  Future<List<DestinasiModel>> getAllDestinasi() async {
    // Mengambil data destinasi dan mengurutkan berdasarkan ID terbaru
    final response = await _supabase
        .from('destinasi')
        .select()
        .order('id_destinasi', ascending: false);

    // Mengubah data JSON menjadi object DestinasiModel
    return (response as List)
        .map((json) => DestinasiModel.fromJson(json))
        .toList();
  }

  // Fungsi untuk menambahkan data destinasi baru ke database
  Future<void> tambahDestinasi(DestinasiModel destinasi) async {
    // Mengirim data destinasi dalam format JSON ke tabel destinasi
    await _supabase.from('destinasi').insert(destinasi.toJson());
  }

  // Fungsi untuk menghapus data destinasi berdasarkan ID
  Future<void> hapusDestinasi(int id) async {
    // Menghapus data pada tabel destinasi sesuai id_destinasi
    await _supabase.from('destinasi').delete().eq('id_destinasi', id);
  }

  // Fungsi untuk mengambil seluruh data kategori dari database
  Future<List<KategoriModel>> getAllKategori() async {
    // Mengambil data kategori dan mengurutkan berdasarkan nama kategori
    final response = await _supabase
        .from('kategori')
        .select()
        .order('nama_kategori');

    // Mengubah data JSON menjadi object KategoriModel
    return (response as List)
        .map((json) => KategoriModel.fromJson(json))
        .toList();
  }

  // Fungsi untuk menambahkan kategori baru ke database
  Future<void> tambahKategori(KategoriModel kategori) async {
    await _supabase.from('kategori').insert(kategori.toJson());
  }

  // Fungsi untuk upload gambar ke Supabase Storage
  // Mengembalikan URL publik gambar yang telah diupload
  Future<String> uploadGambar(Uint8List fileBytes, String bucketName) async {
    String fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Mengupload file gambar ke bucket penyimpanan Supabase
    await _supabase.storage.from(bucketName).uploadBinary(fileName, fileBytes);

    // Mengambil URL publik dari gambar yang sudah diupload
    return _supabase.storage.from(bucketName).getPublicUrl(fileName);
  }
}
