import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/kategori_model.dart';
import '../models/destinasi_model.dart';
import '../models/galeri_model.dart';

import 'package:flutter/foundation.dart';

class DestinasiService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ============================================
  // STATISTIK DASHBOARD ADMIN
  // ============================================

  Future<Map<String, int>> getDashboardStatistics() async {
    final results = await Future.wait<int>([
      _supabase.from('user').count(CountOption.exact),
      _supabase.from('destinasi').count(CountOption.exact),
      _supabase.from('ulasan').count(CountOption.exact),
      _supabase.from('galeri_destinasi').count(CountOption.exact),
    ]);

    return {
      'total_pengguna': results[0],
      'total_destinasi': results[1],
      'total_ulasan': results[2],
      'total_foto': results[3],
    };
  }

  // ============================================
  // CRUD KATEGORI
  // ============================================

  // Ambil semua kategori
  Future<List<KategoriModel>> getAllKategori() async {
    final response = await _supabase
        .from('kategori')
        .select()
        .order('nama_kategori');

    return (response as List)
        .map((json) => KategoriModel.fromJson(json))
        .toList();
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
    await _supabase.from('kategori').delete().eq('id_kategori', id);
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

    return (response as List)
        .map((json) => DestinasiModel.fromJson(json))
        .toList();
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
  Future<DestinasiModel> tambahDestinasi(DestinasiModel destinasi) async {
    final response = await _supabase
        .from('destinasi')
        .insert(destinasi.toJson())
        .select()
        .single();

    return DestinasiModel.fromJson(response);
  }

  // Update destinasi
  Future<void> updateDestinasi(int id, DestinasiModel destinasi) async {
    // Ambil URL foto utama sebelum diperbarui.
    final dataLama = await _supabase
        .from('destinasi')
        .select('foto_utama')
        .eq('id_destinasi', id)
        .single();

    final fotoLama = dataLama['foto_utama'] as String;

    // Perbarui data destinasi dan pastikan barisnya berubah.
    final hasilUpdate = await _supabase
        .from('destinasi')
        .update(destinasi.toJson())
        .eq('id_destinasi', id)
        .select('id_destinasi');

    if (hasilUpdate.isEmpty) {
      throw Exception('Destinasi gagal diperbarui.');
    }

    // Jika foto utama diganti, coba bersihkan file lama.
    if (fotoLama.isNotEmpty && fotoLama != destinasi.fotoUtama) {
      try {
        final berhasil = await bersihkanGambarJikaTidakDigunakan(fotoLama);

        if (!berhasil) {
          // Jangan menggagalkan update karena data sudah tersimpan.
          debugPrint('Peringatan: foto utama lama belum berhasil dibersihkan.');
        }
      } catch (e) {
        debugPrint('Peringatan: gagal membersihkan foto lama: $e');
      }
    }
  }

  // Hapus destinasi
  Future<void> hapusDestinasi(int id) async {
    // 1. Ambil foto utama sebelum destinasi dihapus.
    final destinasi = await _supabase
        .from('destinasi')
        .select('foto_utama')
        .eq('id_destinasi', id)
        .single();

    final fotoUtama = destinasi['foto_utama'] as String;

    // 2. Ambil seluruh URL foto galeri destinasi.
    final galeri = await _supabase
        .from('galeri_destinasi')
        .select('url_gambar')
        .eq('id_destinasi', id);

    final daftarUrlGambar = <String>{
      fotoUtama,
      ...galeri.map((item) => item['url_gambar'] as String),
    };

    // 3. Hapus data galeri terlebih dahulu.
    await _supabase.from('galeri_destinasi').delete().eq('id_destinasi', id);

    // 4. Hapus destinasi dari database.
    final destinasiTerhapus = await _supabase
        .from('destinasi')
        .delete()
        .eq('id_destinasi', id)
        .select('id_destinasi');

    if (destinasiTerhapus.isEmpty) {
      throw Exception('Destinasi gagal dihapus.');
    }

    // 5. Bersihkan file gambar yang sudah tidak digunakan.
    final gambarGagalDibersihkan = <String>[];

    for (final url in daftarUrlGambar) {
      try {
        final berhasil = await bersihkanGambarJikaTidakDigunakan(url);

        if (!berhasil) {
          gambarGagalDibersihkan.add(url);
        }
      } catch (e) {
        gambarGagalDibersihkan.add(url);
      }
    }

    // 6. Laporkan apabila ada file yang gagal dibersihkan.
    if (gambarGagalDibersihkan.isNotEmpty) {
      throw Exception(
        'Destinasi berhasil dihapus, tetapi '
        '${gambarGagalDibersihkan.length} file gambar '
        'belum berhasil dibersihkan dari Storage.',
      );
    }
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

    return (response as List)
        .map((json) => GaleriModel.fromJson(json))
        .toList();
  }

  // Tambah foto ke galeri
  Future<void> tambahGaleri(GaleriModel galeri) async {
    await _supabase.from('galeri_destinasi').insert(galeri.toJson());
  }

  // Hapus foto dari galeri
  Future<void> hapusGaleri(int idGaleri) async {
    await _supabase.from('galeri_destinasi').delete().eq('id_galeri', idGaleri);
  }

  // ============================================
  // UPLOAD GAMBAR KE SUPABASE STORAGE
  // ============================================

  // Upload gambar dan return URL-nya
  //ada ubah bagian Uin8List aslinya tu File file
  Future<String> uploadGambar(Uint8List bytes, String bucketName) async {
    try {
      String extension;
      String contentType;

      // Deteksi format JPEG.
      if (bytes.length >= 3 &&
          bytes[0] == 0xFF &&
          bytes[1] == 0xD8 &&
          bytes[2] == 0xFF) {
        extension = 'jpg';
        contentType = 'image/jpeg';

        // Deteksi format PNG.
      } else if (bytes.length >= 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47 &&
          bytes[4] == 0x0D &&
          bytes[5] == 0x0A &&
          bytes[6] == 0x1A &&
          bytes[7] == 0x0A) {
        extension = 'png';
        contentType = 'image/png';
      } else {
        throw Exception('Format gambar tidak didukung. Gunakan JPG atau PNG.');
      }

      // Buat nama file unik berdasarkan waktu.
      final fileName =
          'img_${DateTime.now().microsecondsSinceEpoch}.$extension';

      // Upload ke Supabase Storage.
      await _supabase.storage
          .from(bucketName)
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: contentType, upsert: false),
          );

      // Ambil URL publik.
      return _supabase.storage.from(bucketName).getPublicUrl(fileName);
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  // Hapus gambar dari storage
  Future<void> hapusGambar(String fileName, String bucketName) async {
    try {
      await _supabase.storage.from(bucketName).remove([fileName]);
    } catch (e) {
      throw Exception('Gagal hapus gambar: $e');
    }
  }

  // Hapus file dari Storage hanya jika tidak digunakan data lain.
  Future<bool> bersihkanGambarJikaTidakDigunakan(String urlGambar) async {
    if (urlGambar.trim().isEmpty) return true;

    // Periksa apakah URL masih dipakai oleh galeri.
    final galeriLain = await _supabase
        .from('galeri_destinasi')
        .select('id_galeri')
        .eq('url_gambar', urlGambar)
        .limit(1);

    // Periksa apakah URL masih digunakan sebagai foto utama.
    final destinasiLain = await _supabase
        .from('destinasi')
        .select('id_destinasi')
        .eq('foto_utama', urlGambar)
        .limit(1);

    if (galeriLain.isNotEmpty || destinasiLain.isNotEmpty) {
      return true;
    }

    // Pastikan URL benar-benar berasal dari bucket aplikasi.
    final uri = Uri.tryParse(urlGambar);

    if (uri == null) return true;

    final bucketUri = Uri.parse(
      _supabase.storage.from('foto-destinasi').getPublicUrl(''),
    );

    final prefix = bucketUri.path.endsWith('/')
        ? bucketUri.path
        : '${bucketUri.path}/';

    if (uri.origin != bucketUri.origin || !uri.path.startsWith(prefix)) {
      return true;
    }

    final pathGambar = Uri.decodeComponent(uri.path.substring(prefix.length));

    if (pathGambar.isEmpty) return true;

    // Hapus file jika tidak memiliki referensi lain.
    try {
      await hapusGambar(pathGambar, 'foto-destinasi');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hapusGaleriBesertaGambar(int idGaleri) async {
    // 1. Ambil informasi foto galeri.
    final data = await _supabase
        .from('galeri_destinasi')
        .select('url_gambar')
        .eq('id_galeri', idGaleri)
        .single();

    final urlGambar = data['url_gambar'] as String;

    // 2. Hapus data galeri dari database dan pastikan berhasil.
    final terhapus = await _supabase
        .from('galeri_destinasi')
        .delete()
        .eq('id_galeri', idGaleri)
        .select('id_galeri');

    if (terhapus.isEmpty) {
      throw Exception('Data galeri gagal dihapus.');
    }

    // 3. Periksa apakah URL masih dipakai galeri lain.
    final galeriLain = await _supabase
        .from('galeri_destinasi')
        .select('id_galeri')
        .eq('url_gambar', urlGambar)
        .limit(1);

    // 4. Periksa apakah URL dipakai sebagai foto utama.
    final fotoUtamaLain = await _supabase
        .from('destinasi')
        .select('id_destinasi')
        .eq('foto_utama', urlGambar)
        .limit(1);

    if (galeriLain.isNotEmpty || fotoUtamaLain.isNotEmpty) {
      return true;
    }

    // 5. Pastikan URL berasal dari bucket milik aplikasi.
    final uri = Uri.parse(urlGambar);

    final bucketUrl = Uri.parse(
      _supabase.storage.from('foto-destinasi').getPublicUrl(''),
    );

    final prefix = bucketUrl.path.endsWith('/')
        ? bucketUrl.path
        : '${bucketUrl.path}/';

    if (uri.origin != bucketUrl.origin || !uri.path.startsWith(prefix)) {
      return true;
    }

    final pathGambar = Uri.decodeComponent(uri.path.substring(prefix.length));

    if (pathGambar.isEmpty) return true;

    // 6. Hapus file dari Storage.
    try {
      await hapusGambar(pathGambar, 'foto-destinasi');
      return true;
    } catch (e) {
      // Data galeri sudah terhapus, tetapi file masih ada.
      return false;
    }
  }
}
