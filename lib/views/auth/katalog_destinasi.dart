import 'package:flutter/material.dart'; // Mengimpor komponen dasar Flutter untuk membuat antarmuka.
import 'rekomendasi_destinasi_page.dart'; // Mengimpor halaman pengaturan rekomendasi destinasi.
import 'edit_destinasi_page.dart'; // Mengimpor halaman untuk mengedit destinasi.
import 'tambah_destinasi_page.dart'; // Mengimpor halaman untuk menambahkan destinasi.

// Model Data Destinasi
class DestinationModel { // Mendefinisikan model untuk menyimpan data satu destinasi wisata.
  final String title; // Menyimpan nama destinasi; final berarti nilainya tidak dapat diganti setelah dibuat.
  final String category; // Menyimpan kategori destinasi; final berarti nilainya tidak dapat diganti setelah dibuat.
  final String location; // Menyimpan lokasi destinasi; final berarti nilainya tidak dapat diganti setelah dibuat.
  final String description; // Menyimpan deskripsi destinasi; final berarti nilainya tidak dapat diganti setelah dibuat.
  final String rating; // Menyimpan nilai rating; final berarti nilainya tidak dapat diganti setelah dibuat.
  final String reviews; // Menyimpan jumlah ulasan; final berarti nilainya tidak dapat diganti setelah dibuat.
  final String photoCount; // Menyimpan jumlah foto; final berarti nilainya tidak dapat diganti setelah dibuat.
  final String imageUrl; // Menyimpan alamat gambar; final berarti nilainya tidak dapat diganti setelah dibuat.
  final bool isRecommended; // Menyimpan nilai benar/salah untuk status rekomendasi.

  DestinationModel({ // Membuat konstruktor model dengan parameter bernama.
    required this.title, // Mewajibkan parameter ini diisi dan menyimpannya ke properti model.
    required this.category, // Mewajibkan parameter ini diisi dan menyimpannya ke properti model.
    required this.location, // Mewajibkan parameter ini diisi dan menyimpannya ke properti model.
    required this.description, // Mewajibkan parameter ini diisi dan menyimpannya ke properti model.
    required this.rating, // Mewajibkan parameter ini diisi dan menyimpannya ke properti model.
    required this.reviews, // Mewajibkan parameter ini diisi dan menyimpannya ke properti model.
    required this.photoCount, // Mewajibkan parameter ini diisi dan menyimpannya ke properti model.
    required this.imageUrl, // Mewajibkan parameter ini diisi dan menyimpannya ke properti model.
    required this.isRecommended, // Mewajibkan parameter ini diisi dan menyimpannya ke properti model.
  });
}

class KatalogDestinasiPage extends StatefulWidget { // Mendefinisikan halaman katalog destinasi.
  const KatalogDestinasiPage({super.key}); // Menyediakan konstruktor halaman dengan key opsional.

  @override // Menandai bahwa method ini menggantikan method dari kelas induk.
  State<KatalogDestinasiPage> createState() => _KatalogDestinasiPageState(); // Menghubungkan widget dengan kelas State yang mengelola tampilannya.
}

class _KatalogDestinasiPageState extends State<KatalogDestinasiPage> { // Mendefinisikan state dan logika yang dapat berubah pada halaman katalog.
  int _selectedCategoryIndex = 0; // Menyimpan indeks kategori yang sedang dipilih; nilai awal 0 berarti kategori pertama.

  final List<String> _categories = [ // Membuat daftar nama kategori yang ditampilkan sebagai filter.
    'Semua', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
    'Pantai', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
    'Danau & Air', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
    'Sejarah & Benteng', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
  ];

  final List<DestinationModel> _destinations = [ // Membuat daftar data destinasi yang ditampilkan pada katalog.
    DestinationModel( // Membuat satu objek destinasi beserta data-datanya.
      title: 'Pantai Sulamadaha', // Mengisi nama destinasi untuk objek destinasi ini.
      category: 'PANTAI', // Mengisi kategori destinasi untuk objek destinasi ini.
      location: 'Sulamadaha, Ternate Barat', // Mengisi lokasi destinasi untuk objek destinasi ini.
      description: // Mengisi ringkasan informasi destinasi untuk objek destinasi ini.
          'Pantai dengan air kaca jernih dan spot kano transparan ikonik di Teluk Saomadaha dengan tebing batuan vulkanik.', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
      rating: '4.9', // Mengisi nilai rating untuk objek destinasi ini.
      reviews: '186 ulasan', // Mengisi jumlah ulasan untuk objek destinasi ini.
      photoCount: '12 Foto', // Mengisi jumlah foto untuk objek destinasi ini.
      imageUrl: 'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/Pantai.jpeg', // Mengisi URL gambar yang ditampilkan untuk objek destinasi ini.
      isRecommended: true, // Mengisi apakah destinasi direkomendasikan untuk objek destinasi ini.
    ),
    DestinationModel( // Membuat satu objek destinasi beserta data-datanya.
      title: 'Pantai Kastela', // Mengisi nama destinasi untuk objek destinasi ini.
      category: 'PANTAI', // Mengisi kategori destinasi untuk objek destinasi ini.
      location: 'Kastela, Pulau Ternate', // Mengisi lokasi destinasi untuk objek destinasi ini.
      description: // Mengisi ringkasan informasi destinasi untuk objek destinasi ini.
          'Spot matahari terbenam magis dengan monumen sejarah pendaratan Portugis pertama serta gerbang reruntuhan...', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
      rating: '4.7', // Mengisi nilai rating untuk objek destinasi ini.
      reviews: '124 ulasan', // Mengisi jumlah ulasan untuk objek destinasi ini.
      photoCount: '9 Foto', // Mengisi jumlah foto untuk objek destinasi ini.
      imageUrl: 'https://indotimur.com/images/nits/2023/08/preview_brtcc0hw_gzrlhpmv.jpg', // Mengisi URL gambar yang ditampilkan untuk objek destinasi ini.
      isRecommended: false, // Mengisi apakah destinasi direkomendasikan untuk objek destinasi ini.
    ),
    DestinationModel( // Membuat satu objek destinasi beserta data-datanya.
      title: 'Danau Tolire', // Mengisi nama destinasi untuk objek destinasi ini.
      category: 'DANAU & AIR', // Mengisi kategori destinasi untuk objek destinasi ini.
      location: 'Takome, Ternate Barat', // Mengisi lokasi destinasi untuk objek destinasi ini.
      description: // Mengisi ringkasan informasi destinasi untuk objek destinasi ini.
          'Danau hijau di kaki Gunung Gamalama dengan legenda mistis dan panorama alam khas Ternate.', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
      rating: '4.8', // Mengisi nilai rating untuk objek destinasi ini.
      reviews: '95 ulasan', // Mengisi jumlah ulasan untuk objek destinasi ini.
      photoCount: '15 Foto', // Mengisi jumlah foto untuk objek destinasi ini.
      imageUrl: 'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/newsOg_2024_6_9_1717902356726-iifq7h.jpeg', // Mengisi URL gambar yang ditampilkan untuk objek destinasi ini.
      isRecommended: false, // Mengisi apakah destinasi direkomendasikan untuk objek destinasi ini.
    ),
  ];

  @override // Menandai bahwa method ini menggantikan method dari kelas induk.
  Widget build(BuildContext context) { // Membangun tampilan halaman berdasarkan state saat ini.
    return Scaffold( // Mengembalikan kerangka halaman yang berisi app bar dan isi halaman.
      backgroundColor: const Color(0xFFF8FAFC), // Mengatur latar belakang halaman menjadi abu-abu sangat muda.
      appBar: AppBar( // Menentukan bilah atas halaman.
        backgroundColor: Colors.white, // Mengatur warna latar menjadi putih.
        elevation: 0, // Mengatur efek ketinggian/bayangan komponen.
        titleSpacing: 16, // Mengatur jarak judul dari sisi kiri app bar.
        title: Column( // Mengisi nama destinasi untuk objek destinasi ini.
          crossAxisAlignment: CrossAxisAlignment.start, // Mengatur perataan widget pada sumbu silang.
          children: [ // Menentukan kumpulan widget anak.
            Row( // Menyusun widget secara horizontal.
              children: [ // Menentukan kumpulan widget anak.
                Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                  width: 4, // Menentukan ukuran lebar atau tinggi komponen.
                  height: 18, // Menentukan ukuran lebar atau tinggi komponen.
                  decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                    color: const Color(0xFF0066FF), // Menentukan warna menggunakan kode warna heksadesimal.
                    borderRadius: BorderRadius.circular(2), // Mengatur tingkat kebulatan sudut komponen.
                  ),
                ),
                const SizedBox(width: 8), // Membuat ruang kosong atau menetapkan ukuran widget.
                const Text( // Menampilkan teks pada antarmuka.
                  'Katalog Destinasi', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                  style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                    color: Colors.black, // Menggunakan warna bawaan Flutter.
                    fontSize: 18, // Menentukan ukuran teks.
                    fontWeight: FontWeight.bold, // Menentukan ketebalan huruf.
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2), // Membuat ruang kosong atau menetapkan ukuran widget.
            const Text( // Menampilkan teks pada antarmuka.
              'Kelola & perbarui spot wisata Kota Ternate', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
              style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                color: Colors.grey, // Menggunakan warna bawaan Flutter.
                fontSize: 11, // Menentukan ukuran teks.
                fontWeight: FontWeight.normal, // Menentukan ketebalan huruf.
              ),
            ),
          ],
        ),
        actions: [ // Menempatkan tombol aksi di sisi kanan app bar.
          Padding( // Memberi jarak di bagian dalam atau sekitar isi widget.
            padding: const EdgeInsets.only(right: 16.0, top: 10, bottom: 10), // Memberi jarak hanya pada sisi yang ditentukan.
            child: ElevatedButton.icon( // Membuat tombol berwarna dengan ikon dan teks.
              onPressed: () { // Menentukan fungsi yang dijalankan ketika tombol ditekan.
                // Navigasi ke Halaman Tambah Destinasi
                Navigator.push( // Membuka halaman baru di atas halaman saat ini.
                  context, // Parameter yang diberikan Flutter saat membangun widget.
                  MaterialPageRoute( // Mendefinisikan rute navigasi menuju halaman tujuan.
                    builder: (context) => const TambahDestinasiPage(), // Membuat widget halaman tujuan untuk rute navigasi.
                  ),
                );
              },
              icon: const Icon(Icons.add, size: 16, color: Colors.white), // Menampilkan ikon.
              label: const Text( // Menampilkan teks pada antarmuka.
                'Tambah', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                    fontSize: 12, // Menentukan ukuran teks.
                    fontWeight: FontWeight.bold, // Menentukan ketebalan huruf.
                    color: Colors.white), // Menggunakan warna bawaan Flutter.
              ),
              style: ElevatedButton.styleFrom( // Menerapkan pengaturan gaya pada komponen.
                backgroundColor: const Color(0xFF0066FF), // Mengatur warna utama tombol menjadi biru.
                shape: RoundedRectangleBorder( // Membuat bentuk persegi panjang dengan sudut membulat.
                  borderRadius: BorderRadius.circular(20), // Mengatur tingkat kebulatan sudut komponen.
                ), // Menutup widget, daftar, atau blok yang dibuka sebelumnya.
                padding: const EdgeInsets.symmetric(horizontal: 14), // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                elevation: 0, // Mengatur efek ketinggian/bayangan komponen.
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView( // Membuat isi halaman dapat digulir jika melebihi layar.
        padding: const EdgeInsets.all(16.0), // Memberi jarak yang sama pada semua sisi.
        child: Column( // Menyusun widget secara vertikal.
          children: [ // Menentukan kumpulan widget anak.
            // Banner Atur Rekomendasi Beranda
            GestureDetector( // Membuat komponen dapat merespons sentuhan.
              onTap: () { // Menentukan fungsi yang dijalankan ketika komponen disentuh.
                Navigator.push( // Membuka halaman baru di atas halaman saat ini.
                  context, // Parameter yang diberikan Flutter saat membangun widget.
                  MaterialPageRoute( // Mendefinisikan rute navigasi menuju halaman tujuan.
                    builder: (context) => const RekomendasiDestinasiPage(), // Membuat widget halaman tujuan untuk rute navigasi.
                  ),
                );
              },
              child: Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                padding: // Menentukan jarak bagian dalam komponen.
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                  gradient: const LinearGradient( // Membuat gradasi warna pada latar komponen.
                    colors: [Color(0xFF0066FF), Color(0xFF2F80ED)], // Menentukan warna menggunakan kode warna heksadesimal.
                    begin: Alignment.centerLeft, // Menentukan arah atau posisi tata letak.
                    end: Alignment.centerRight, // Menentukan arah atau posisi tata letak.
                  ),
                  borderRadius: BorderRadius.circular(16), // Mengatur tingkat kebulatan sudut komponen.
                  boxShadow: [ // Memulai daftar nilai.
                    BoxShadow( // Menambahkan bayangan halus pada komponen.
                      color: const Color(0xFF0066FF).withOpacity(0.2), // Menentukan warna menggunakan kode warna heksadesimal.
                      blurRadius: 10, // Mengatur tingkat blur bayangan.
                      offset: const Offset(0, 4), // Mengatur pergeseran bayangan pada sumbu horizontal dan vertikal.
                    ),
                  ],
                ),
                child: Row( // Menyusun widget secara horizontal.
                  children: [ // Menentukan kumpulan widget anak.
                    Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                      padding: const EdgeInsets.all(10), // Memberi jarak yang sama pada semua sisi.
                      decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                        color: Colors.white.withOpacity(0.2), // Menggunakan warna bawaan Flutter.
                        shape: BoxShape.circle, // Menentukan bentuk komponen.
                      ), // Menutup widget, daftar, atau blok yang dibuka sebelumnya.
                      child: const Icon(Icons.star, // Menampilkan ikon.
                          color: Colors.white, size: 20), // Menggunakan warna bawaan Flutter.
                    ), // Menutup widget, daftar, atau blok yang dibuka sebelumnya.
                    const SizedBox(width: 12), // Membuat ruang kosong atau menetapkan ukuran widget.
                    Expanded( // Menggunakan ruang tersisa yang tersedia pada baris atau kolom.
                      child: Column( // Menyusun widget secara vertikal.
                        crossAxisAlignment: CrossAxisAlignment.start, // Mengatur perataan widget pada sumbu silang.
                        children: [ // Menentukan kumpulan widget anak.
                          Row( // Menyusun widget secara horizontal.
                            children: [ // Menentukan kumpulan widget anak.
                              const Text( // Menampilkan teks pada antarmuka.
                                'Atur Rekomendasi Beranda', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                                style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                                  color: Colors.white, // Menggunakan warna bawaan Flutter.
                                  fontWeight: FontWeight.bold, // Menentukan ketebalan huruf.
                                  fontSize: 13, // Menentukan ukuran teks.
                                ),
                              ),
                              const SizedBox(width: 8), // Membuat ruang kosong atau menetapkan ukuran widget.
                              Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                                padding: const EdgeInsets.symmetric( // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                                    horizontal: 8, vertical: 2), // Menentukan jarak pada arah yang disebutkan.
                                decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                                  color: Colors.white.withOpacity(0.25), // Menggunakan warna bawaan Flutter.
                                  borderRadius: BorderRadius.circular(12), // Mengatur tingkat kebulatan sudut komponen.
                                ), // Menutup widget, daftar, atau blok yang dibuka sebelumnya.
                                child: const Text( // Menampilkan teks pada antarmuka.
                                  '5 AKTIF', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                                  style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                                    color: Colors.white, // Menggunakan warna bawaan Flutter.
                                    fontSize: 9, // Menentukan ukuran teks.
                                    fontWeight: FontWeight.bold, // Menentukan ketebalan huruf.
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3), // Membuat ruang kosong atau menetapkan ukuran widget.
                          const Text( // Menampilkan teks pada antarmuka.
                            'Destinasi terpilih di landing page traveler', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                            style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                              color: Colors.white70, // Menggunakan warna bawaan Flutter.
                              fontSize: 11, // Menentukan ukuran teks.
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                      padding: const EdgeInsets.all(6), // Memberi jarak yang sama pada semua sisi.
                      decoration: const BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                        color: Colors.white, // Menggunakan warna bawaan Flutter.
                        shape: BoxShape.circle, // Menentukan bentuk komponen.
                      ),
                      child: const Icon(Icons.chevron_right, // Menampilkan ikon.
                          color: Color(0xFF0066FF), size: 18), // Menentukan warna menggunakan kode warna heksadesimal.
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16), // Membuat ruang kosong atau menetapkan ukuran widget.

            // Search Bar
            TextField( // Membuat kolom input untuk pencarian destinasi.
              decoration: InputDecoration( // Mengatur dekorasi kolom input.
                hintText: 'Cari nama destinasi, kecamatan...', // Menampilkan petunjuk teks di kolom pencarian.
                hintStyle: // Menentukan bagian konfigurasi atau alur kode untuk widget ini.
                    TextStyle(color: Colors.grey.shade400, fontSize: 13), // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                prefixIcon: // Menampilkan ikon pencarian di dalam kolom input.
                    Icon(Icons.search, color: Colors.grey.shade400, size: 20), // Menampilkan ikon pencarian di dalam kolom input.
                filled: true, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                fillColor: Colors.white, // Menggunakan warna bawaan Flutter.
                contentPadding: const EdgeInsets.symmetric(vertical: 12), // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                border: OutlineInputBorder( // Memberi garis tepi berbentuk kotak pada kolom input.
                  borderRadius: BorderRadius.circular(12), // Mengatur tingkat kebulatan sudut komponen.
                  borderSide: BorderSide(color: Colors.grey.shade200), // Menentukan warna dan ketebalan garis tepi.
                ),
                enabledBorder: OutlineInputBorder( // Memberi garis tepi berbentuk kotak pada kolom input.
                  borderRadius: BorderRadius.circular(12), // Mengatur tingkat kebulatan sudut komponen.
                  borderSide: BorderSide(color: Colors.grey.shade200), // Menentukan warna dan ketebalan garis tepi.
                ),
              ),
            ),

            const SizedBox(height: 16), // Membuat ruang kosong atau menetapkan ukuran widget.

            // Kategori Chips
            SizedBox( // Membuat ruang kosong atau menetapkan ukuran widget.
              height: 36, // Menentukan ukuran lebar atau tinggi komponen.
              child: ListView.separated( // Membuat daftar kategori horizontal dengan jarak antaritem.
                scrollDirection: Axis.horizontal, // Membuat daftar kategori dapat digeser ke samping.
                itemCount: _categories.length, // Menentukan jumlah item sesuai banyaknya kategori.
                separatorBuilder: (context, index) => const SizedBox(width: 8), // Memberi jarak di antara item kategori.
                itemBuilder: (context, index) { // Mendefinisikan cara membuat setiap item dalam daftar.
                  final isSelected = _selectedCategoryIndex == index; // Memeriksa apakah kategori pada indeks ini sedang dipilih.
                  return GestureDetector( // Membuat komponen dapat merespons sentuhan.
                    onTap: () { // Menentukan fungsi yang dijalankan ketika komponen disentuh.
                      setState(() { // Memberi tahu Flutter bahwa state berubah sehingga tampilan diperbarui.
                        _selectedCategoryIndex = index; // Menyimpan indeks kategori yang baru dipilih.
                      });
                    },
                    child: Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                      padding: const EdgeInsets.symmetric( // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                          horizontal: 16, vertical: 8), // Menentukan jarak pada arah yang disebutkan.
                      decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                        color: isSelected // Menentukan warna komponen atau teks.
                            ? const Color(0xFF0066FF) // Menentukan warna menggunakan kode warna heksadesimal.
                            : Colors.white, // Menggunakan warna bawaan Flutter.
                        borderRadius: BorderRadius.circular(12), // Mengatur tingkat kebulatan sudut komponen.
                        border: Border.all( // Memberi garis tepi di sekeliling komponen.
                          color: isSelected // Menentukan warna komponen atau teks.
                              ? const Color(0xFF0066FF) // Menentukan warna menggunakan kode warna heksadesimal.
                              : Colors.grey.shade200, // Menggunakan warna bawaan Flutter.
                        ),
                      ),
                      child: Text( // Menampilkan teks pada antarmuka.
                        _categories[index], // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                        style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                          color: isSelected // Menentukan warna komponen atau teks.
                              ? Colors.white // Menggunakan warna bawaan Flutter.
                              : Colors.grey.shade700, // Menggunakan warna bawaan Flutter.
                          fontSize: 12, // Menentukan ukuran teks.
                          fontWeight: // Menentukan ketebalan teks.
                              isSelected ? FontWeight.bold : FontWeight.normal, // Menentukan ketebalan huruf.
                        ),
                      ),
                    ),
                  );
                }, 
              ),
            ),

            const SizedBox(height: 16), // Membuat ruang kosong atau menetapkan ukuran widget.

            // Daftar Card Destinasi
            ListView.builder( // Membangun kartu destinasi satu per satu sesuai jumlah data.
              shrinkWrap: true, // Membatasi tinggi daftar sesuai ukuran isi ketika berada di dalam kolom.
              physics: const NeverScrollableScrollPhysics(), // Menonaktifkan gulir pada daftar ini agar halaman utama yang menggulir.
              itemCount: _destinations.length, // Menentukan jumlah kartu sesuai banyaknya destinasi.
              itemBuilder: (context, index) { // Mendefinisikan cara membuat setiap item dalam daftar.
                final destination = _destinations[index]; // Mengambil data destinasi pada posisi daftar saat ini.
                return _buildDestinationCard(destination); // Menampilkan kartu untuk destinasi yang sedang diproses.
              }, 
            ),
          ], 
        ),
      ),
    );
  }

  Widget _buildDestinationCard(DestinationModel destination) { // Membuat satu kartu tampilan untuk data destinasi yang diberikan.
    return Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
      margin: const EdgeInsets.only(bottom: 16), // Memberi jarak hanya pada sisi yang ditentukan.
      padding: const EdgeInsets.all(12), // Memberi jarak yang sama pada semua sisi.
      decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
        color: Colors.white, // Menggunakan warna bawaan Flutter.
        borderRadius: BorderRadius.circular(16), // Mengatur tingkat kebulatan sudut komponen.
        border: Border.all(color: Colors.grey.shade100), // Memberi garis tepi di sekeliling komponen.
        boxShadow: [ // Memulai daftar nilai.
          BoxShadow( // Menambahkan bayangan halus pada komponen.
            color: Colors.black.withOpacity(0.02), // Menggunakan warna bawaan Flutter.
            blurRadius: 8, // Mengatur tingkat blur bayangan.
            offset: const Offset(0, 2), // Mengatur pergeseran bayangan pada sumbu horizontal dan vertikal.
          ),
        ],
      ),
      child: Column( // Menyusun widget secara vertikal.
        crossAxisAlignment: CrossAxisAlignment.start, // Mengatur perataan widget pada sumbu silang.
        children: [ // Menentukan kumpulan widget anak.
          // Gambar dan Info Utama Header
          Row( // Menyusun widget secara horizontal.
            crossAxisAlignment: CrossAxisAlignment.start, // Mengatur perataan widget pada sumbu silang.
            children: [ // Menentukan kumpulan widget anak.
              // Gambar Destinasi
              Stack( // Menumpuk widget agar dapat berada di atas widget lain.
                children: [ // Menentukan kumpulan widget anak.
                  ClipRRect( // Memotong isi widget dengan sudut membulat.
                    borderRadius: BorderRadius.circular(12), // Mengatur tingkat kebulatan sudut komponen.
                    child: Image.network( // Memuat gambar destinasi dari alamat internet.
                      destination.imageUrl, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                      width: 95, // Menentukan ukuran lebar atau tinggi komponen.
                      height: 80, // Menentukan ukuran lebar atau tinggi komponen.
                      fit: BoxFit.cover, // Memenuhi area gambar sambil mempertahankan proporsi gambar.
                      errorBuilder: (context, error, stackTrace) => Container( // Menampilkan tampilan pengganti jika gambar gagal dimuat.
                        width: 95, // Menentukan ukuran lebar atau tinggi komponen.
                        height: 80, // Menentukan ukuran lebar atau tinggi komponen.
                        color: Colors.grey.shade300, // Menggunakan warna bawaan Flutter.
                        child: const Icon(Icons.image, color: Colors.grey), // Menampilkan ikon.
                      ),
                    ), 
                  ),
                  Positioned( // Menempatkan label foto pada posisi tertentu di atas gambar.
                    bottom: 6, // Menentukan posisi komponen dari sisi yang disebutkan.
                    left: 6, // Menentukan posisi komponen dari sisi yang disebutkan.
                    child: Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                      padding: const EdgeInsets.symmetric( // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                          horizontal: 6, vertical: 2), // Menentukan jarak pada arah yang disebutkan.
                      decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                        color: Colors.black.withOpacity(0.6), // Menggunakan warna bawaan Flutter.
                        borderRadius: BorderRadius.circular(6), // Mengatur tingkat kebulatan sudut komponen.
                      ),
                      child: Row( // Menyusun widget secara horizontal.
                        children: [ // Menentukan kumpulan widget anak.
                          const Icon(Icons.camera_alt, // Menampilkan ikon.
                              color: Colors.white, size: 10), // Menggunakan warna bawaan Flutter.
                          const SizedBox(width: 4), // Membuat ruang kosong atau menetapkan ukuran widget.
                          Text( // Menampilkan teks pada antarmuka.
                            destination.photoCount, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                            style: const TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                              color: Colors.white, // Menggunakan warna bawaan Flutter.
                              fontSize: 9, // Menentukan ukuran teks.
                              fontWeight: FontWeight.w500, // Menentukan ketebalan huruf.
                            ),
                          ), 
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12), // Membuat ruang kosong atau menetapkan ukuran widget.

              // Detail Info Nama, Lokasi, dan Status
              Expanded( // Menggunakan ruang tersisa yang tersedia pada baris atau kolom.
                child: Column( // Menyusun widget secara vertikal.
                  crossAxisAlignment: CrossAxisAlignment.start, // Mengatur perataan widget pada sumbu silang.
                  children: [ // Menentukan kumpulan widget anak.
                    Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                      padding: const EdgeInsets.symmetric( // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                          horizontal: 6, vertical: 2), // Menentukan jarak pada arah yang disebutkan.
                      decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                        color: const Color(0xFFEBF2FF), // Menentukan warna menggunakan kode warna heksadesimal.
                        borderRadius: BorderRadius.circular(4), // Mengatur tingkat kebulatan sudut komponen.
                      ),
                      child: Text( // Menampilkan teks pada antarmuka.
                        destination.category, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                        style: const TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                          color: Color(0xFF0066FF), // Menentukan warna menggunakan kode warna heksadesimal.
                          fontSize: 9, // Menentukan ukuran teks.
                          fontWeight: FontWeight.bold, // Menentukan ketebalan huruf.
                        ),
                      ),
                    ),
                    const SizedBox(height: 4), // Membuat ruang kosong atau menetapkan ukuran widget.
                    Text( // Menampilkan teks pada antarmuka.
                      destination.title, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                      style: const TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                        fontSize: 14, // Menentukan ukuran teks.
                        fontWeight: FontWeight.bold, // Menentukan ketebalan huruf.
                      ),
                    ),
                    const SizedBox(height: 2), // Membuat ruang kosong atau menetapkan ukuran widget.
                    Row( // Menyusun widget secara horizontal.
                      children: [ // Menentukan kumpulan widget anak.
                        const Icon(Icons.location_on_outlined, // Menampilkan ikon.
                            size: 12, color: Colors.grey), // Menggunakan warna bawaan Flutter.
                        const SizedBox(width: 2), // Membuat ruang kosong atau menetapkan ukuran widget.
                        Expanded( // Menggunakan ruang tersisa yang tersedia pada baris atau kolom.
                          child: Text( // Menampilkan teks pada antarmuka.
                            destination.location, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                            style: const TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                                fontSize: 11, color: Colors.grey), // Menggunakan warna bawaan Flutter.
                            maxLines: 1, // Membatasi jumlah baris teks yang ditampilkan.
                            overflow: TextOverflow.ellipsis, // Memotong teks berlebih dan menambahkan tanda titik-titik.
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6), // Membuat ruang kosong atau menetapkan ukuran widget.
                    if (destination.isRecommended) // Memeriksa kondisi sebelum menampilkan atau menjalankan bagian berikutnya.
                      Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                        padding: const EdgeInsets.symmetric( // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                            horizontal: 8, vertical: 4), // Menentukan jarak pada arah yang disebutkan.
                        decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                          color: const Color(0xFFEBF2FF), // Menentukan warna menggunakan kode warna heksadesimal.
                          borderRadius: BorderRadius.circular(6), // Mengatur tingkat kebulatan sudut komponen.
                        ),
                        child: Row( // Menyusun widget secara horizontal.
                          mainAxisSize: MainAxisSize.min, // Mengatur seberapa banyak ruang utama yang dipakai widget.
                          children: const [ // Menentukan kumpulan widget anak.
                            Icon(Icons.star, // Menampilkan ikon.
                                size: 11, color: Color(0xFF0066FF)), // Menentukan warna menggunakan kode warna heksadesimal.
                            SizedBox(width: 4), // Membuat ruang kosong atau menetapkan ukuran widget.
                            Text( // Menampilkan teks pada antarmuka.
                              'Rekomendasi Beranda', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                              style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                                fontSize: 10, // Menentukan ukuran teks.
                                color: Color(0xFF0066FF), // Menentukan warna menggunakan kode warna heksadesimal.
                                fontWeight: FontWeight.bold, // Menentukan ketebalan huruf.
                              ), 
                            ), 
                          ], 
                        ),
                      ) 
                    else // Menjalankan pilihan alternatif jika kondisi sebelumnya tidak terpenuhi.
                      Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                        padding: const EdgeInsets.symmetric( // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                            horizontal: 8, vertical: 4), // Menentukan jarak pada arah yang disebutkan.
                        decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                          border: Border.all(color: Colors.grey.shade300), // Memberi garis tepi di sekeliling komponen.
                          borderRadius: BorderRadius.circular(6), // Mengatur tingkat kebulatan sudut komponen.
                        ),
                        child: const Text( // Menampilkan teks pada antarmuka.
                          '+ Jadikan Rekomendasi', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                          style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                            fontSize: 10, // Menentukan ukuran teks.
                            color: Colors.grey, // Menggunakan warna bawaan Flutter.
                            fontWeight: FontWeight.w500, // Menentukan ketebalan huruf.
                          ),
                        ),
                      ), 
                  ], 
                ),
              ),
            ], 
          ), 

          const SizedBox(height: 12), // Membuat ruang kosong atau menetapkan ukuran widget.

          // Rating & Ulasan Box
          Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
            decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
              color: const Color(0xFFF8FAFC), // Menentukan warna menggunakan kode warna heksadesimal.
              borderRadius: BorderRadius.circular(10), // Mengatur tingkat kebulatan sudut komponen.
            ),
            child: Row( // Menyusun widget secara horizontal.
              children: [ // Menentukan kumpulan widget anak.
                const Icon(Icons.star_rounded, color: Colors.amber, size: 16), // Menampilkan ikon.
                const SizedBox(width: 6), // Membuat ruang kosong atau menetapkan ukuran widget.
                const Text( // Menampilkan teks pada antarmuka.
                  'Rating: ', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                  style: TextStyle(fontSize: 11, color: Colors.grey), // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                ),
                Text( // Menampilkan teks pada antarmuka.
                  destination.rating, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                  style: const TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                    fontSize: 11, // Menentukan ukuran teks.
                    fontWeight: FontWeight.bold, // Menentukan ketebalan huruf.
                    color: Colors.black87, // Menggunakan warna bawaan Flutter.
                  ),
                ),
                Padding( // Memberi jarak di bagian dalam atau sekitar isi widget.
                  padding: const EdgeInsets.symmetric(horizontal: 16), // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                  child: Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                    height: 12, // Menentukan ukuran lebar atau tinggi komponen.
                    width: 1, // Menentukan ukuran lebar atau tinggi komponen.
                    color: Colors.grey.shade300, // Menggunakan warna bawaan Flutter.
                  ),
                ),
                const Icon( // Menampilkan ikon.
                  Icons.chat_bubble_outline_rounded, // Memilih ikon bawaan Flutter.
                  color: Color(0xFF0066FF), // Menentukan warna menggunakan kode warna heksadesimal.
                  size: 14, // Menentukan ukuran ikon atau komponen.
                ),
                const SizedBox(width: 6), // Membuat ruang kosong atau menetapkan ukuran widget.
                const Text( // Menampilkan teks pada antarmuka.
                  'Ulasan: ', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                  style: TextStyle(fontSize: 11, color: Colors.grey), // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                ),
                Text( // Menampilkan teks pada antarmuka.
                  destination.reviews, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                  style: const TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                    fontSize: 11, // Menentukan ukuran teks.
                    fontWeight: FontWeight.bold, // Menentukan ketebalan huruf.
                    color: Colors.black87, // Menggunakan warna bawaan Flutter.
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10), // Membuat ruang kosong atau menetapkan ukuran widget.

          // Deskripsi Destinasi
          Text( // Menampilkan teks pada antarmuka.
            destination.description, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
            style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                fontSize: 11, color: Colors.grey.shade700, height: 1.3), // Menggunakan warna bawaan Flutter.
            maxLines: 2, // Membatasi jumlah baris teks yang ditampilkan.
            overflow: TextOverflow.ellipsis, // Memotong teks berlebih dan menambahkan tanda titik-titik.
          ),

          const SizedBox(height: 12), // Membuat ruang kosong atau menetapkan ukuran widget.

          // Tombol Aksi Bottom (Detail, Edit Destinasi, Hapus)
          Row( // Menyusun widget secara horizontal.
            children: [ // Menentukan kumpulan widget anak.
              Expanded( // Menggunakan ruang tersisa yang tersedia pada baris atau kolom.
                child: OutlinedButton.icon( // Membuat tombol dengan garis tepi, ikon, dan teks.
                  onPressed: () {}, // Menentukan fungsi yang dijalankan ketika tombol ditekan.
                  icon: const Icon(Icons.visibility_outlined, // Menampilkan ikon.
                      size: 14, color: Colors.black87), // Menggunakan warna bawaan Flutter.
                  label: const Text( // Menampilkan teks pada antarmuka.
                    'Detail', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                    style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                        fontSize: 11, // Menentukan ukuran teks.
                        color: Colors.black87, // Menggunakan warna bawaan Flutter.
                        fontWeight: FontWeight.bold), // Menentukan ketebalan huruf.
                  ),
                  style: OutlinedButton.styleFrom( // Menerapkan pengaturan gaya pada komponen.
                    padding: const EdgeInsets.symmetric(vertical: 10), // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                    side: BorderSide(color: Colors.grey.shade200), // Menentukan warna dan ketebalan garis tepi.
                    shape: RoundedRectangleBorder( // Membuat bentuk persegi panjang dengan sudut membulat.
                        borderRadius: BorderRadius.circular(10)), // Mengatur tingkat kebulatan sudut komponen.
                  ),
                ),
              ),
              const SizedBox(width: 8), // Membuat ruang kosong atau menetapkan ukuran widget.
              Expanded( // Menggunakan ruang tersisa yang tersedia pada baris atau kolom.
                flex: 2, // Mengatur perbandingan ruang yang digunakan widget fleksibel.
                child: ElevatedButton.icon( // Membuat tombol berwarna dengan ikon dan teks.
                  onPressed: () { // Menentukan fungsi yang dijalankan ketika tombol ditekan.
                    // Navigasi ke EditDestinasiPage
                    Navigator.push( // Membuka halaman baru di atas halaman saat ini.
                      context, // Parameter yang diberikan Flutter saat membangun widget.
                      MaterialPageRoute( // Mendefinisikan rute navigasi menuju halaman tujuan.
                        builder: (context) => EditDestinasiPage( // Membuat widget halaman tujuan untuk rute navigasi.
                          destinationTitle: destination.title, // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_note_rounded, // Menampilkan ikon.
                      size: 16, color: Colors.white), // Menggunakan warna bawaan Flutter.
                  label: const Text( // Menampilkan teks pada antarmuka.
                    'Edit Destinasi', // Melanjutkan daftar parameter atau widget dengan item berikutnya.
                    style: TextStyle( // Mengatur tampilan teks seperti ukuran, warna, dan ketebalan.
                        fontSize: 11, // Menentukan ukuran teks.
                        color: Colors.white, // Menggunakan warna bawaan Flutter.
                        fontWeight: FontWeight.bold), // Menentukan ketebalan huruf.
                  ),
                  style: ElevatedButton.styleFrom( // Menerapkan pengaturan gaya pada komponen.
                    backgroundColor: const Color(0xFF0066FF), // Mengatur warna utama tombol menjadi biru.
                    padding: const EdgeInsets.symmetric(vertical: 10), // Memberi jarak berdasarkan arah horizontal dan/atau vertikal.
                    elevation: 0, // Mengatur efek ketinggian/bayangan komponen.
                    shape: RoundedRectangleBorder( // Membuat bentuk persegi panjang dengan sudut membulat.
                        borderRadius: BorderRadius.circular(10)), // Mengatur tingkat kebulatan sudut komponen.
                  ),
                ),
              ),
              const SizedBox(width: 8), // Membuat ruang kosong atau menetapkan ukuran widget.

              // Tombol Hapus (Pink Smooth Rounded)
              Container( // Membuat kotak yang dapat diberi ukuran, padding, warna, dan dekorasi.
                width: 38, // Menentukan ukuran lebar atau tinggi komponen.
                height: 38, // Menentukan ukuran lebar atau tinggi komponen.
                decoration: BoxDecoration( // Mengatur dekorasi seperti warna, garis tepi, bayangan, dan bentuk.
                  color: const Color(0xFFFFF0F0), // Menentukan warna menggunakan kode warna heksadesimal.
                  borderRadius: BorderRadius.circular(10), // Mengatur tingkat kebulatan sudut komponen.
                ),
                child: Material( // Menyediakan lapisan Material untuk efek sentuhan.
                  color: Colors.transparent, // Menggunakan warna bawaan Flutter.
                  child: InkWell( // Membuat area sentuh dengan efek visual ketika ditekan.
                    onTap: () {}, // Menentukan fungsi yang dijalankan ketika komponen disentuh.
                    borderRadius: BorderRadius.circular(10), // Mengatur tingkat kebulatan sudut komponen.
                    child: const Center( // Menempatkan isi tepat di tengah area.
                      child: Icon( // Menampilkan ikon.
                        Icons.delete_outline_rounded, // Memilih ikon bawaan Flutter.
                        color: Color(0xFFE53935), // Menentukan warna menggunakan kode warna heksadesimal.
                        size: 18, // Menentukan ukuran ikon atau komponen.
                      ),
                    ),
                  ),
                ),
              ),
            ], 
          ),
        ],
      ),
    );
  }
}
