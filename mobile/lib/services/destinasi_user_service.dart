import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/destinasi_user_model.dart';
import '../models/kategori_user_model.dart';

class DestinasiUserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const String _destinasiColumns =
      'id_destinasi, '
      'id_kategori, '
      'nama_destinasi, '
      'deskripsi, '
      'alamat, '
      'latitude, '
      'longitude, '
      'foto_utama, '
      'status, '
      'tanggal_daftar, '
      'tanggal_perubahan';

  // Mengambil seluruh destinasi aktif
  Future<List<DestinasiUserModel>> getDestinasiAktif() async {
    final response = await _supabase
        .from('destinasi')
        .select(_destinasiColumns)
        .eq('status', true)
        .order('id_destinasi', ascending: false);

    return response.map<DestinasiUserModel>((json) {
      return DestinasiUserModel.fromJson(Map<String, dynamic>.from(json));
    }).toList();
  }

  // Mengambil seluruh kategori destinasi
  Future<List<KategoriUserModel>> getKategori() async {
    final response = await _supabase
        .from('kategori')
        .select()
        .order('nama_kategori', ascending: true);

    return response.map<KategoriUserModel>((json) {
      return KategoriUserModel.fromJson(Map<String, dynamic>.from(json));
    }).toList();
  }

  // Mengambil detail destinasi berdasarkan ID
  Future<DestinasiUserModel?> getDestinasiById(int id) async {
    final response = await _supabase
        .from('destinasi')
        .select(_destinasiColumns)
        .eq('id_destinasi', id)
        .eq('status', true)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return DestinasiUserModel.fromJson(Map<String, dynamic>.from(response));
  }
}