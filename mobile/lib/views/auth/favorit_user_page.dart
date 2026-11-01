import 'package:flutter/material.dart';

const Color warnaBiru = Color(0xFF1769E0);
const Color warnaLatar = Color(0xFFF5F7FC);
const Color warnaTeks = Color(0xFF202631);
const Color warnaAbu = Color(0xFF7B8494);
const Color warnaMerah = Color(0xFFC62828);
const Color warnaHijau = Color(0xFF239B68);

class FavoritUserPage extends StatefulWidget {
  const FavoritUserPage({super.key});

  @override
  State<FavoritUserPage> createState() => _FavoritUserPageState();
}

class _FavoritUserPageState extends State<FavoritUserPage> {
  String kategoriAktif = 'Semua';
  int menuAktif = 2;

  final List<Map<String, dynamic>> destinasi = [
    {
      'nama': 'Pantai Sulamadaha',
      'kategori': 'Pantai',
      'lokasi': 'Ternate Barat, Maluku Utara',
      'rating': '4.8',
      'gambar':
          'https://images.unsplash.com/photo-1500375592092-40eb2168fd21?w=500',
      'favorit': true,
      'deskripsi':
          'Pantai Sulamadaha memiliki air laut yang jernih dan pemandangan alam yang indah. Tempat ini cocok untuk menikmati keindahan laut Ternate.',
    },
    {
      'nama': 'Benteng Oranje',
      'kategori': 'Sejarah',
      'lokasi': 'Ternate Tengah, Kota Ternate',
      'rating': '4.7',
      'gambar':
          'https://images.unsplash.com/photo-1603565816030-6b389eeb23cb?w=500',
      'favorit': true,
      'deskripsi':
          'Benteng Oranje merupakan salah satu tempat bersejarah di Kota Ternate yang menarik untuk dikunjungi.',
    },
    {
      'nama': 'Danau Tolire & Gamalama',
      'kategori': 'Alam',
      'lokasi': 'Ternate Utara, Maluku Utara',
      'rating': '4.9',
      'gambar':
          'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?w=500',
      'favorit': true,
      'deskripsi':
          'Danau Tolire menawarkan pemandangan alam yang indah dengan latar Gunung Gamalama.',
    },
    {
      'nama': 'Pantai Jikomalamo',
      'kategori': 'Pantai',
      'lokasi': 'Ternate Barat, Maluku Utara',
      'rating': '4.8',
      'gambar':
          'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?w=500',
      'favorit': true,
      'deskripsi':
          'Pantai Jikomalamo terkenal dengan air laut yang jernih dan pemandangan bawah lautnya.',
    },
    {
      'nama': 'Taman Nukila & Falajawa',
      'kategori': 'Pantai / Santai',
      'lokasi': 'Ternate Tengah, Kota Ternate',
      'rating': '4.6',
      'gambar':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=500',
      'favorit': true,
      'deskripsi':
          'Tempat untuk bersantai dan menikmati suasana pesisir Kota Ternate.',
    },
  ];

  List<Map<String, dynamic>> get daftarFavorit {
    return destinasi.where((item) {
      if (item['favorit'] != true) return false;

      final String kategori = item['kategori'];

      if (kategoriAktif == 'Semua') return true;
      if (kategoriAktif == 'Pantai') {
        return kategori.contains('Pantai');
      }
      return kategori == kategoriAktif;
    }).toList();
  }

  int jumlahKategori(String kategori) {
    return destinasi.where((item) {
      if (item['favorit'] != true) return false;

      if (kategori == 'Semua') return true;

      final String jenis = item['kategori'];

      if (kategori == 'Pantai') {
        return jenis.contains('Pantai');
      }

      return jenis == kategori;
    }).length;
  }

  void ubahFavorit(Map<String, dynamic> item) {
    setState(() {
      item['favorit'] = !(item['favorit'] as bool);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          item['favorit']
              ? '${item['nama']} ditambahkan ke favorit'
              : '${item['nama']} dihapus dari favorit',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void tampilkanDetail(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(22),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  child: Image.network(
                    item['gambar'],
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _gambarCadangan(220),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          labelKategori(item['kategori']),
                          const Spacer(),
                          const Icon(
                            Icons.star,
                            size: 17,
                            color: warnaHijau,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['rating'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item['nama'],
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: warnaTeks,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: warnaBiru,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              item['lokasi'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: warnaAbu,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item['deskripsi'],
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: warnaTeks,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ubahFavorit(item);
                          },
                          icon: Icon(
                            item['favorit']
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          label: Text(
                            item['favorit']
                                ? 'Hapus dari Favorit'
                                : 'Tambah ke Favorit',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: warnaBiru,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _gambarCadangan(double tinggi) {
    return Container(
      width: double.infinity,
      height: tinggi,
      color: const Color(0xFFE4EDF7),
      child: const Icon(
        Icons.landscape,
        color: warnaBiru,
        size: 45,
      ),
    );
  }

  Widget labelKategori(String kategori) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        kategori,
        style: const TextStyle(
          color: warnaBiru,
          fontSize: 9,
        ),
      ),
    );
  }

  Widget tombolKategori(String nama) {
    final bool aktif = kategoriAktif == nama;

    return GestureDetector(
      onTap: () {
        setState(() {
          kategoriAktif = nama;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: aktif ? warnaBiru : const Color(0xFFE9EDF5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nama,
              style: TextStyle(
                fontSize: 10,
                color: aktif ? Colors.white : const Color(0xFF566174),
                fontWeight: aktif ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: aktif
                    ? Colors.white.withOpacity(0.22)
                    : const Color(0xFFDCE3EF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${jumlahKategori(nama)}',
                style: TextStyle(
                  fontSize: 9,
                  color: aktif ? Colors.white : const Color(0xFF647087),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget kartuDestinasi(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF243653).withOpacity(0.035),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar dan rating di sudut kiri atas gambar.
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.network(
                  item['gambar'],
                  width: 79,
                  height: 79,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 79,
                    height: 79,
                    color: const Color(0xFFE4EDF7),
                    child: const Icon(
                      Icons.landscape,
                      color: warnaBiru,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        size: 10,
                        color: warnaHijau,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        item['rating'],
                        style: const TextStyle(
                          fontSize: 9,
                          color: warnaHijau,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 7),

          // Kategori, nama, dan lokasi di tengah kartu.
          Expanded(
            child: SizedBox(
              height: 79,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelKategori(item['kategori']),
                  const SizedBox(height: 5),
                  Text(
                    item['nama'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: warnaTeks,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: warnaBiru,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          item['lokasi'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            color: warnaAbu,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 4),

          // Ikon hati di kanan atas dan Detail di kanan bawah.
          SizedBox(
            height: 79,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => ubahFavorit(item),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF0F0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['favorit']
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 15,
                      color: warnaMerah,
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => tampilkanDetail(item),
                  child: const Text(
                    'Detail >',
                    style: TextStyle(
                      fontSize: 9,
                      color: warnaBiru,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget navigasiBawah() {
    final List<IconData> ikon = [
      Icons.home_outlined,
      Icons.location_on_outlined,
      Icons.favorite_outline,
      Icons.person_outline,
    ];

    final List<String> nama = [
      'Beranda',
      'Destinasi',
      'Favorit',
      'Profil',
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 7,
        bottom: MediaQuery.of(context).padding.bottom > 0 ? 4 : 8,
      ),
      child: Row(
        children: List.generate(ikon.length, (index) {
          final bool aktif = menuAktif == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  menuAktif = index;
                });

                if (index != 2) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Menu ${nama[index]} dipilih'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: aktif
                          ? const Color(0xFFE5EEFF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      ikon[index],
                      size: 21,
                      color: aktif ? warnaBiru : const Color(0xFF727C8C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    nama[index],
                    style: TextStyle(
                      fontSize: 9,
                      color: aktif ? warnaBiru : warnaAbu,
                      fontWeight:
                          aktif ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> daftar = daftarFavorit;

    return Scaffold(
      backgroundColor: warnaLatar,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER TERNATESPOT
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 8,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.landscape_outlined,
                    color: warnaBiru,
                    size: 27,
                  ),
                  const SizedBox(width: 5),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'ternate',
                                style: TextStyle(
                                  color: warnaTeks,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: 'Spot',
                                style: TextStyle(
                                  color: warnaBiru,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'WISATA KOTA TERNATE',
                          style: TextStyle(
                            fontSize: 6,
                            color: warnaAbu,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Belum ada notifikasi baru'),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: warnaTeks,
                      size: 22,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFFE0E9F5),
                    child: Icon(
                      Icons.person,
                      color: warnaBiru,
                      size: 17,
                    ),
                  ),
                ],
              ),
            ),

            // JUDUL DAN JUMLAH FAVORIT
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 13, 15, 8),
              child: Row(
                children: [
                  const Text(
                    'Destinasi Favorit',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: warnaTeks,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4EDFF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${destinasi.where((item) => item['favorit'] == true).length} Tersimpan',
                      style: const TextStyle(
                        fontSize: 9,
                        color: warnaBiru,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        kategoriAktif =
                            kategoriAktif == 'Semua' ? 'Pantai' : 'Semua';
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8EFFB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.filter_list,
                        size: 17,
                        color: Color(0xFF647087),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Daftar tempat wisata impian di Kepulauan Rempah,\n'
                  'yang siap kamu kunjungi.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.5,
                    color: warnaAbu,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 9),

            // FILTER KATEGORI
            SizedBox(
              height: 29,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  tombolKategori('Semua'),
                  const SizedBox(width: 6),
                  tombolKategori('Pantai'),
                  const SizedBox(width: 6),
                  tombolKategori('Alam'),
                  const SizedBox(width: 6),
                  tombolKategori('Sejarah'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // DAFTAR KARTU DESTINASI
            Expanded(
              child: daftar.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite_border,
                              size: 50,
                              color: Color(0xFFB6C5DA),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Belum ada destinasi favorit',
                              style: TextStyle(
                                color: warnaTeks,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Destinasi yang kamu simpan akan muncul di sini.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11,
                                color: warnaAbu,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  kategoriAktif = 'Semua';
                                });
                              },
                              child: const Text('Lihat Semua'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 12),
                      itemCount: daftar.length,
                      itemBuilder: (context, index) {
                        return kartuDestinasi(daftar[index]);
                      },
                    ),
            ),

            // NAVIGASI BAWAH
            navigasiBawah(),
          ],
        ),
      ),
    );
  }
}
