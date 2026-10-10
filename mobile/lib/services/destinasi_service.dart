import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/destinasi_model.dart';
import '../models/kategori_model.dart';

class DestinasiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<DestinasiModel>> getAllDestinasi() async {
    final response = await _supabase.from('destinasi').select().order('id_destinasi', ascending: false);
    return (response as List).map((json) => DestinasiModel.fromJson(json)).toList();
  }

  Future<void> tambahDestinasi(DestinasiModel destinasi) async {
    await _supabase.from('destinasi').insert(destinasi.toJson());
  }

  Future<void> hapusDestinasi(int id) async {
    await _supabase.from('destinasi').delete().eq('id_destinasi', id);
  }

  Future<List<KategoriModel>> getAllKategori() async {
    final response = await _supabase.from('kategori').select().order('nama_kategori');
    return (response as List).map((json) => KategoriModel.fromJson(json)).toList();
  }

  Future<void> tambahKategori(KategoriModel kategori) async {
    await _supabase.from('kategori').insert(kategori.toJson());
  }

  Future<String> uploadGambar(Uint8List fileBytes, String bucketName) async {
    String fileName = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    await _supabase.storage.from(bucketName).uploadBinary(fileName, fileBytes);
    return _supabase.storage.from(bucketName).getPublicUrl(fileName);
  }
}