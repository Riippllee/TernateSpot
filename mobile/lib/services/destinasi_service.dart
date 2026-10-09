import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategori_model.dart';
import '../models/destinasi_model.dart';
import '../models/galeri_model.dart';

class DestinasiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ============================================
  // CRUD KATEGORI
  // ============================================

  // Ambil semua kategori
  Future<List<KategoriModel>> getAllKategori() async {
    final response = await _supabase
        .from('kategori')
        .select()
        .order('nama_kategori');
    
    return (response as List).map((json) => KategoriModel.fromJson(json)).toList();
  }

  // Tambah kategori baru
  Future<void> tambahKategori(KategoriModel kategori) async {
    await _supabase.from('kategori').insert(kategori.toJson());
  }

  // Update kategori
  Future<void> updateKategori(int id, KategoriModel kategori) async {
    await _supabase
        .from('kategori')
        .update(kategori.toJson())
        .eq('id_kategori', id);
  }

  // Hapus kategori
  Future<void> hapusKategori(int id) async {
    await _supabase
        .from('kategori')
        .delete()
        .eq('id_kategori', id);
  }

  // ============================================
  // CRUD DESTINASI
  // ============================================

  // Ambil semua destinasi
  Future<List<DestinasiModel>> getAllDestinasi() async {
    final response = await _supabase
        .from('destinasi')
        .select()
        .order('nama_destinasi');
    
    return (response as List).map((json) => DestinasiModel.fromJson(json)).toList();
  }

  // Ambil destinasi berdasarkan ID
  Future<DestinasiModel?> getDestinasiById(int id) async {
    final response = await _supabase
        .from('destinasi')
        .select()
        .eq('id_destinasi', id)
        .single();
    
    return DestinasiModel.fromJson(response);
  }

  // Tambah destinasi baru
  Future<void> tambahDestinasi(DestinasiModel destinasi) async {
    await _supabase.from('destinasi').insert(destinasi.toJson());
  }

  // Update destinasi
  Future<void> updateDestinasi(int id, DestinasiModel destinasi) async {
    await _supabase
        .from('destinasi')
        .update(destinasi.toJson())
        .eq('id_destinasi', id);
  }

  // Hapus destinasi
  Future<void> hapusDestinasi(int id) async {
    await _supabase
        .from('destinasi')
        .delete()
        .eq('id_destinasi', id);
  }

  // ============================================
  // CRUD GALERI
  // ============================================

  // Ambil galeri berdasarkan ID destinasi
  Future<List<GaleriModel>> getGaleriByDestinasi(int idDestinasi) async {
    final response = await _supabase
        .from('galeri_destinasi')
        .select()
        .eq('id_destinasi', idDestinasi)
        .order('tanggal_dibuat', ascending: false);
    
    return (response as List).map((json) => GaleriModel.fromJson(json)).toList();
  }

  // Tambah foto ke galeri
  Future<void> tambahGaleri(GaleriModel galeri) async {
    await _supabase.from('galeri_destinasi').insert(galeri.toJson());
  }

  // Hapus foto dari galeri
  Future<void> hapusGaleri(int idGaleri) async {
    await _supabase
        .from('galeri_destinasi')
        .delete()
        .eq('id_galeri', idGaleri);
  }

  // ============================================
  // UPLOAD GAMBAR KE SUPABASE STORAGE
  // ============================================

  // Upload gambar dan return URL-nya
  Future<String> uploadGambar(File file, String bucketName) async {
    try {
      // Buat nama file unik
      String fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Upload file ke bucket storage
      await _supabase.storage
          .from(bucketName)
          .upload(fileName, file);
      
      // Ambil URL publik gambar
      final url = _supabase.storage
          .from(bucketName)
          .getPublicUrl(fileName);
      
      return url;
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  // Hapus gambar dari storage
  Future<void> hapusGambar(String fileName, String bucketName) async {
    try {
      await _supabase.storage
          .from(bucketName)
          .remove([fileName]);
    } catch (e) {
      throw Exception('Gagal hapus gambar: $e');
    }
  }
}