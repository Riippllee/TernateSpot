import 'package:flutter/material.dart';  // Mengimpor library atau file yang dibutuhkan.

class RekomendasiDestinasiPage extends StatefulWidget {  // Mendefinisikan halaman rekomendasi destinasi sebagai StatefulWidget.
  const RekomendasiDestinasiPage({super.key});  // Konstruktor halaman rekomendasi.

  @override  // Menandai bahwa metode dari kelas induk ditimpa.
  State<RekomendasiDestinasiPage> createState() => _RekomendasiDestinasiPageState();  // Membuat objek State untuk mengelola perubahan tampilan.
} 

class _RekomendasiDestinasiPageState extends State<RekomendasiDestinasiPage> {  // Mendefinisikan state dan perilaku halaman rekomendasi.
  int _selectedFilterIndex = 0;  // Menyimpan indeks filter yang sedang dipilih; awalnya filter pertama.

  final List<String> _filters = [  // Membuat daftar pilihan filter.
    'Semua',  // Nilai teks untuk daftar atau tampilan.
    'Populer',  // Nilai teks untuk daftar atau tampilan.
    'Bahari',  // Nilai teks untuk daftar atau tampilan.
    'Budaya',  // Nilai teks untuk daftar atau tampilan.
    'Gunung',  // Nilai teks untuk daftar atau tampilan.
  ];

  @override  // Menandai bahwa metode dari kelas induk ditimpa.
  Widget build(BuildContext context) {  // Membangun dan mengembalikan tampilan halaman.
    return Scaffold(  // Membuat kerangka utama halaman.
      backgroundColor: const Color(0xFFF7F9FC),  // Menentukan warna tampilan.
      appBar: AppBar(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
        backgroundColor: Colors.white,  // Menggunakan warna bawaan Flutter.
        elevation: 0,  // Mengatur ketinggian/bayangan komponen.
        leadingWidth: 56,  // Memisahkan argumen atau properti berikutnya.
        leading: Padding(  // Memberikan ruang kosong di sekitar widget.
          padding: const EdgeInsets.only(left: 16.0),  // Mengatur jarak bagian dalam atau luar widget.
          child: Center(  // Menentukan widget anak yang ditampilkan.
            child: Material(  // Menyediakan lapisan Material untuk efek interaksi.
              color: Colors.transparent,  // Menggunakan warna bawaan Flutter.
              child: InkWell(  // Memberikan efek sentuhan pada widget.
                borderRadius: BorderRadius.circular(20),  // Membulatkan sudut dengan radius yang ditentukan.
                onTap: () => Navigator.pop(context),  // Menutup halaman saat ini dan kembali ke halaman sebelumnya.
                child: const Padding(  // Memberikan ruang kosong di sekitar widget.
                  padding: EdgeInsets.all(4.0),  // Mengatur jarak bagian dalam atau luar widget.
                  child: Icon(  // Menampilkan ikon.
                    Icons.arrow_back,  // Memilih ikon yang ditampilkan.
                    color: Colors.black87,  // Menggunakan warna bawaan Flutter.
                    size: 20,  // Memisahkan argumen atau properti berikutnya.
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Text(  // Menampilkan teks pada antarmuka.
          'Rekomendasi Destinasi',  // Nilai teks untuk daftar atau tampilan.
          style: TextStyle(  // Mengatur gaya teks.
            color: Colors.black87,  // Menggunakan warna bawaan Flutter.
            fontSize: 18,  // Menentukan ukuran huruf.
            fontWeight: FontWeight.bold,  // Menentukan ketebalan teks.
          ),
        ),
      ),
      body: SingleChildScrollView(  // Membuat konten halaman dapat digulir.
        padding: const EdgeInsets.all(16.0),  // Mengatur jarak bagian dalam atau luar widget.
        child: Column(  // Menyusun widget secara vertikal.
          crossAxisAlignment: CrossAxisAlignment.start,  // Menentukan posisi atau perataan widget.
          children: [  // Menentukan kumpulan widget anak.
            // CARD 1: PUBLIC & SLOT PROGRESS
            Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
              padding: const EdgeInsets.all(16),  // Mengatur jarak bagian dalam atau luar widget.
              decoration: BoxDecoration(  // Mengatur dekorasi wadah.
                color: Colors.white,  // Menggunakan warna bawaan Flutter.
                borderRadius: BorderRadius.circular(16),  // Membulatkan sudut dengan radius yang ditentukan.
                border: Border.all(color: const Color(0xFFEDF2F7)),  // Mengatur garis tepi di semua sisi.
              ),
              child: Column(  // Menyusun widget secara vertikal.
                crossAxisAlignment: CrossAxisAlignment.start,  // Menentukan posisi atau perataan widget.
                children: [  // Menentukan kumpulan widget anak.
                  Row(  // Menyusun widget secara horizontal.
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Menentukan posisi atau perataan widget.
                    children: [  // Menentukan kumpulan widget anak.
                      Row(  // Menyusun widget secara horizontal.
                        children: [  // Menentukan kumpulan widget anak.
                          Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
                            width: 8,  // Menentukan ukuran widget.
                            height: 8,  // Menentukan ukuran widget.
                            decoration: const BoxDecoration(  // Mengatur dekorasi wadah.
                              color: Color(0xFF0052CC),  // Menentukan warna tampilan.
                              shape: BoxShape.circle,  // Memisahkan argumen atau properti berikutnya.
                            ),
                          ),
                          const SizedBox(width: 6),  // Memberi jarak atau menentukan ukuran widget.
                          const Text(  // Menampilkan teks pada antarmuka.
                            'PUBLIC',  // Nilai teks untuk daftar atau tampilan.
                            style: TextStyle(  // Mengatur gaya teks.
                              fontSize: 11,  // Menentukan ukuran huruf.
                              fontWeight: FontWeight.bold,  // Menentukan ketebalan teks.
                              color: Color(0xFF0052CC),  // Menentukan warna tampilan.
                              letterSpacing: 0.5,  // Memisahkan argumen atau properti berikutnya.
                            ),
                          ),
                        ],
                      ),
                      Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
                        padding: const EdgeInsets.symmetric(  // Mengatur jarak bagian dalam atau luar widget.
                            horizontal: 10, vertical: 4),  // Memisahkan argumen atau properti berikutnya.
                        decoration: BoxDecoration(  // Mengatur dekorasi wadah.
                          color: const Color(0xFFF1F5F9),  // Menentukan warna tampilan.
                          borderRadius: BorderRadius.circular(12),  // Membulatkan sudut dengan radius yang ditentukan.
                        ),
                        child: Row(  // Menyusun widget secara horizontal.
                          children: const [  // Menentukan kumpulan widget anak.
                            Icon(Icons.cloud_done_outlined,  // Menampilkan ikon.
                                size: 13, color: Colors.grey),  // Menggunakan warna bawaan Flutter.
                            SizedBox(width: 4),  // Memberi jarak atau menentukan ukuran widget.
                            Text(  // Menampilkan teks pada antarmuka.
                              'Sinkron Otomatis',  // Nilai teks untuk daftar atau tampilan.
                              style: TextStyle(  // Mengatur gaya teks.
                                  fontSize: 10,  // Menentukan ukuran huruf.
                                  color: Colors.grey,  // Menggunakan warna bawaan Flutter.
                                  fontWeight: FontWeight.w500),  // Menentukan ketebalan teks.
                            ), 
                          ],
                        ),  // Menutup pemanggilan widget atau fungsi.
                      ),  // Menutup pemanggilan widget atau fungsi.
                    ],  // Menutup daftar widget atau nilai.
                  ),  // Menutup pemanggilan widget atau fungsi.
                  const SizedBox(height: 12),  // Memberi jarak atau menentukan ukuran widget.
                  Row(  // Menyusun widget secara horizontal.
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Menentukan posisi atau perataan widget.
                    crossAxisAlignment: CrossAxisAlignment.center,  // Menentukan posisi atau perataan widget.
                    children: [  // Menentukan kumpulan widget anak.
                      Column(  // Menyusun widget secara vertikal.
                        crossAxisAlignment: CrossAxisAlignment.start,  // Menentukan posisi atau perataan widget.
                        children: [  // Menentukan kumpulan widget anak.
                          Row(  // Menyusun widget secara horizontal.
                            crossAxisAlignment: CrossAxisAlignment.baseline,  // Menentukan posisi atau perataan widget.
                            textBaseline: TextBaseline.alphabetic,  // Memisahkan argumen atau properti berikutnya.
                            children: const [  // Menentukan kumpulan widget anak.
                              Text(  // Menampilkan teks pada antarmuka.
                                '6',  // Nilai teks untuk daftar atau tampilan.
                                style: TextStyle(  // Mengatur gaya teks.
                                  fontSize: 26,  // Menentukan ukuran huruf.
                                  fontWeight: FontWeight.bold,  // Menentukan ketebalan teks.
                                  color: Colors.black87,  // Menggunakan warna bawaan Flutter.
                                ),  // Menutup pemanggilan widget atau fungsi.
                              ),  // Menutup pemanggilan widget atau fungsi.
                              Text(  // Menampilkan teks pada antarmuka.
                                ' / 6',  // Nilai teks untuk daftar atau tampilan.
                                style: TextStyle(  // Mengatur gaya teks.
                                  fontSize: 16,  // Menentukan ukuran huruf.
                                  fontWeight: FontWeight.w500,  // Menentukan ketebalan teks.
                                  color: Colors.grey,  // Menggunakan warna bawaan Flutter.
                                ),  // Menutup pemanggilan widget atau fungsi.
                              ),  // Menutup pemanggilan widget atau fungsi.
                            ],  // Menutup daftar widget atau nilai.
                          ),  // Menutup pemanggilan widget atau fungsi.
                          const SizedBox(height: 2),  // Memberi jarak atau menentukan ukuran widget.
                          const Text(  // Menampilkan teks pada antarmuka.
                            'Slot carousel beranda terisi\noptimal',  // Nilai teks untuk daftar atau tampilan.
                            style: TextStyle(  // Mengatur gaya teks.
                              fontSize: 11,  // Menentukan ukuran huruf.
                              color: Colors.grey,  // Menggunakan warna bawaan Flutter.
                              height: 1.2,  // Menentukan ukuran widget.
                            ),  // Menutup pemanggilan widget atau fungsi.
                          ),  // Menutup pemanggilan widget atau fungsi.
                        ],  // Menutup daftar widget atau nilai.
                      ),  // Menutup pemanggilan widget atau fungsi.
                      ElevatedButton.icon(  // Membuat tombol berwarna yang memiliki ikon dan teks.
                        onPressed: () {},  // Menentukan tindakan saat tombol ditekan.
                        icon: const Icon(Icons.file_download_outlined,  // Menampilkan ikon.
                            size: 16, color: Colors.white),  // Menggunakan warna bawaan Flutter.
                        label: const Text(  // Menampilkan teks pada antarmuka.
                          'Publikasikan',  // Nilai teks untuk daftar atau tampilan.
                          style: TextStyle(  // Mengatur gaya teks.
                              fontSize: 12,  // Menentukan ukuran huruf.
                              fontWeight: FontWeight.bold,  // Menentukan ketebalan teks.
                              color: Colors.white),  // Menggunakan warna bawaan Flutter.
                        ),  // Menutup pemanggilan widget atau fungsi.
                        style: ElevatedButton.styleFrom(  // Menentukan gaya tampilan.
                          backgroundColor: const Color(0xFF0066FF),  // Menentukan warna tampilan.
                          shape: RoundedRectangleBorder(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                            borderRadius: BorderRadius.circular(10),  // Membulatkan sudut dengan radius yang ditentukan.
                          ),  // Menutup pemanggilan widget atau fungsi.
                          padding: const EdgeInsets.symmetric(  // Mengatur jarak bagian dalam atau luar widget.
                              horizontal: 14, vertical: 12),  // Memisahkan argumen atau properti berikutnya.
                          elevation: 0,  // Mengatur ketinggian/bayangan komponen.
                        ),  // Menutup pemanggilan widget atau fungsi.
                      ),  // Menutup pemanggilan widget atau fungsi.
                    ],  // Menutup daftar widget atau nilai.
                  ),  // Menutup pemanggilan widget atau fungsi.
                  const SizedBox(height: 14),  // Memberi jarak atau menentukan ukuran widget.
                  ClipRRect(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                    borderRadius: BorderRadius.circular(4),  // Membulatkan sudut dengan radius yang ditentukan.
                    child: const LinearProgressIndicator(  // Menampilkan indikator kemajuan.
                      value: 1.0,  // Menentukan nilai properti.
                      backgroundColor: Color(0xFFE2E8F0),  // Menentukan warna tampilan.
                      valueColor:  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                          AlwaysStoppedAnimation<Color>(Color(0xFF0066FF)),  // Menentukan warna tampilan.
                      minHeight: 4,  // Memisahkan argumen atau properti berikutnya.
                    ),  // Menutup pemanggilan widget atau fungsi.
                  ),  // Menutup pemanggilan widget atau fungsi.
                ],  // Menutup daftar widget atau nilai.
              ),  // Menutup pemanggilan widget atau fungsi.
            ),  // Menutup pemanggilan widget atau fungsi.

            const SizedBox(height: 16),  // Memberi jarak atau menentukan ukuran widget.

            // GRID REKOMENDASI 6 ITEM
            GridView.count(  // Menyusun kartu rekomendasi dalam grid dengan jumlah kolom tertentu.
              crossAxisCount: 2,  // Menentukan jumlah kolom grid.
              shrinkWrap: true,  // Menyesuaikan ukuran daftar dengan isi kontennya.
              physics: const NeverScrollableScrollPhysics(),  // Mengatur perilaku gulir widget.
              crossAxisSpacing: 12,  // Mengatur jarak antaritem pada grid.
              mainAxisSpacing: 12,  // Mengatur jarak antaritem pada grid.
              childAspectRatio: 0.86,  // Menentukan perbandingan lebar dan tinggi item grid.
              children: [  // Menentukan kumpulan widget anak.
                _buildRecommendationCard(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                  tag: '#1 Utama',  // Memisahkan argumen atau properti berikutnya.
                  tagBgColor: Colors.white,  // Menggunakan warna bawaan Flutter.
                  tagTextColor: const Color(0xFF0066FF),  // Menentukan warna tampilan.
                  title: 'Pantai Sulamadaha',  // Memisahkan argumen atau properti berikutnya.
                  category: 'Pantai • Kota Ternate',  // Memisahkan argumen atau properti berikutnya.
                  imageUrl:  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/Pantai.jpeg',  // Nilai teks untuk daftar atau tampilan.
                ),  // Menutup pemanggilan widget atau fungsi.
                _buildRecommendationCard(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                  tag: '#2 Sejarah',  // Memisahkan argumen atau properti berikutnya.
                  tagBgColor: Colors.white,  // Menggunakan warna bawaan Flutter.
                  tagTextColor: const Color(0xFF0066FF),  // Menentukan warna tampilan.
                  title: 'Benteng Tolluko',  // Memisahkan argumen atau properti berikutnya.
                  category: 'Sejarah • Kota Ternate',  // Memisahkan argumen atau properti berikutnya.
                  imageUrl:  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                      'https://indotimur.com/images/nits/2023/08/preview_brtcc0hw_gzrlhpmv.jpg',  // Nilai teks untuk daftar atau tampilan.
                ),  // Menutup pemanggilan widget atau fungsi.
                _buildRecommendationCard(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                  tag: '#3 Pantai',  // Memisahkan argumen atau properti berikutnya.
                  tagBgColor: Colors.white,  // Menggunakan warna bawaan Flutter.
                  tagTextColor: const Color(0xFF0066FF),  // Menentukan warna tampilan.
                  title: 'Pantai Jikomalamo',  // Memisahkan argumen atau properti berikutnya.
                  category: 'Pantai • Kota Ternate',  // Memisahkan argumen atau properti berikutnya.
                  imageUrl:  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/Pantai.jpeg',  // Nilai teks untuk daftar atau tampilan.
                ),  // Menutup pemanggilan widget atau fungsi.
                _buildRecommendationCard(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                  tag: '#4 Alam',  // Memisahkan argumen atau properti berikutnya.
                  tagBgColor: Colors.white,  // Menggunakan warna bawaan Flutter.
                  tagTextColor: const Color(0xFF0066FF),  // Menentukan warna tampilan.
                  title: 'Danau Tolire Besar',  // Memisahkan argumen atau properti berikutnya.
                  category: 'Alam • Kota Ternate',  // Memisahkan argumen atau properti berikutnya.
                  imageUrl:  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/newsOg_2024_6_9_1717902356726-iifq7h.jpeg',  // Nilai teks untuk daftar atau tampilan.
                ),  // Menutup pemanggilan widget atau fungsi.
                _buildRecommendationCard(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                  tag: '#5 Siap Ditukar',  // Memisahkan argumen atau properti berikutnya.
                  tagBgColor: const Color(0xFFD35400),  // Menentukan warna tampilan.
                  tagTextColor: Colors.white,  // Menggunakan warna bawaan Flutter.
                  title: 'Danau Tolire Kecil',  // Memisahkan argumen atau properti berikutnya.
                  category: 'Alam • Kota Ternate',  // Memisahkan argumen atau properti berikutnya.
                  imageUrl:  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                      'https://sultanbabullah-airport.com/wp-content/uploads/2025/02/newsOg_2024_6_9_1717902356726-iifq7h.jpeg',  // Nilai teks untuk daftar atau tampilan.
                  isSwapIconHighlight: true,  // Memisahkan argumen atau properti berikutnya.
                ),  // Menutup pemanggilan widget atau fungsi.
                _buildRecommendationCard(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                  tag: '#6 Baru Ditautkan',  // Memisahkan argumen atau properti berikutnya.
                  tagBgColor: Colors.white,  // Menggunakan warna bawaan Flutter.
                  tagTextColor: const Color(0xFF0066FF),  // Menentukan warna tampilan.
                  title: 'Kedaton Kesultanan',  // Memisahkan argumen atau properti berikutnya.
                  category: 'Sejarah • Kota Ternate',  // Memisahkan argumen atau properti berikutnya.
                  imageUrl:  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                      'https://indotimur.com/images/nits/2023/08/preview_brtcc0hw_gzrlhpmv.jpg',  // Nilai teks untuk daftar atau tampilan.
                ),  // Menutup pemanggilan widget atau fungsi.
              ],  // Menutup daftar widget atau nilai.
            ),  // Menutup pemanggilan widget atau fungsi.

            const SizedBox(height: 16),  // Memberi jarak atau menentukan ukuran widget.

            // BANNER TOAST BIRU (URUNGKAN)
            Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
              padding:  // Mengatur jarak widget.
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),  // Mengatur jarak bagian dalam atau luar widget.
              decoration: BoxDecoration(  // Mengatur dekorasi wadah.
                color: const Color(0xFF0066FF),  // Menentukan warna tampilan.
                borderRadius: BorderRadius.circular(12),  // Membulatkan sudut dengan radius yang ditentukan.
              ),  // Menutup pemanggilan widget atau fungsi.
              child: Row(  // Menyusun widget secara horizontal.
                children: [  // Menentukan kumpulan widget anak.
                  Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
                    padding: const EdgeInsets.all(2),  // Mengatur jarak bagian dalam atau luar widget.
                    decoration: const BoxDecoration(  // Mengatur dekorasi wadah.
                      color: Colors.white,  // Menggunakan warna bawaan Flutter.
                      shape: BoxShape.circle,  // Memisahkan argumen atau properti berikutnya.
                    ),  // Menutup pemanggilan widget atau fungsi.
                    child: const Icon(  // Menampilkan ikon.
                      Icons.check,  // Memilih ikon yang ditampilkan.
                      color: Color(0xFF0066FF),  // Menentukan warna tampilan.
                      size: 12,  // Memisahkan argumen atau properti berikutnya.
                    ),  // Menutup pemanggilan widget atau fungsi.
                  ),  // Menutup pemanggilan widget atau fungsi.
                  const SizedBox(width: 8),  // Memberi jarak atau menentukan ukuran widget.
                  const Expanded(  // Menggunakan ruang yang tersedia pada tata letak.
                    child: Text(  // Menampilkan teks pada antarmuka.
                      'Danau Toba berhasil dipasang ke Slo',  // Nilai teks untuk daftar atau tampilan.
                      style: TextStyle(  // Mengatur gaya teks.
                        color: Colors.white,  // Menggunakan warna bawaan Flutter.
                        fontSize: 11,  // Menentukan ukuran huruf.
                        fontWeight: FontWeight.w500,  // Menentukan ketebalan teks.
                      ),  // Menutup pemanggilan widget atau fungsi.
                      overflow: TextOverflow.ellipsis,  // Menentukan perilaku teks ketika ruang tidak cukup.
                    ),  // Menutup pemanggilan widget atau fungsi.
                  ),  // Menutup pemanggilan widget atau fungsi.
                  TextButton(  // Membuat tombol teks.
                    onPressed: () {},  // Menentukan tindakan saat tombol ditekan.
                    style: TextButton.styleFrom(  // Menentukan gaya tampilan.
                      padding: EdgeInsets.zero,  // Mengatur jarak bagian dalam atau luar widget.
                      minimumSize: Size.zero,  // Memisahkan argumen atau properti berikutnya.
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,  // Memisahkan argumen atau properti berikutnya.
                    ),  // Menutup pemanggilan widget atau fungsi.
                    child: const Text(  // Menampilkan teks pada antarmuka.
                      'URUNGKAN',  // Nilai teks untuk daftar atau tampilan.
                      style: TextStyle(  // Mengatur gaya teks.
                        color: Colors.white,  // Menggunakan warna bawaan Flutter.
                        fontSize: 11,  // Menentukan ukuran huruf.
                        fontWeight: FontWeight.bold,  // Menentukan ketebalan teks.
                      ),  // Menutup pemanggilan widget atau fungsi.
                    ),  // Menutup pemanggilan widget atau fungsi.
                  ),  // Menutup pemanggilan widget atau fungsi.
                  const SizedBox(width: 10),  // Memberi jarak atau menentukan ukuran widget.
                  GestureDetector(  // Mendeteksi sentuhan atau ketukan pengguna.
                    onTap: () {},  // Menentukan tindakan saat area ini diketuk.
                    child: const Icon(Icons.close,  // Menampilkan ikon.
                        color: Colors.white, size: 16),  // Menggunakan warna bawaan Flutter.
                  ),  // Menutup pemanggilan widget atau fungsi.
                ],  // Menutup daftar widget atau nilai.
              ),  // Menutup pemanggilan widget atau fungsi.
            ),  // Menutup pemanggilan widget atau fungsi.

            const SizedBox(height: 20),  // Memberi jarak atau menentukan ukuran widget.

            // KATALOG DESTINASI TERSEDIA SECTION
            Row(  // Menyusun widget secara horizontal.
              mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Menentukan posisi atau perataan widget.
              children: [  // Menentukan kumpulan widget anak.
                Row(  // Menyusun widget secara horizontal.
                  children: [  // Menentukan kumpulan widget anak.
                    Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
                      padding: const EdgeInsets.all(4),  // Mengatur jarak bagian dalam atau luar widget.
                      decoration: BoxDecoration(  // Mengatur dekorasi wadah.
                        color: const Color(0xFFE8F8F0),  // Menentukan warna tampilan.
                        borderRadius: BorderRadius.circular(6),  // Membulatkan sudut dengan radius yang ditentukan.
                      ),  // Menutup pemanggilan widget atau fungsi.
                      child: const Icon(  // Menampilkan ikon.
                        Icons.insert_drive_file_outlined,  // Memilih ikon yang ditampilkan.
                        color: Color(0xFF27AE60),  // Menentukan warna tampilan.
                        size: 16,  // Memisahkan argumen atau properti berikutnya.
                      ),  // Menutup pemanggilan widget atau fungsi.
                    ),  // Menutup pemanggilan widget atau fungsi.
                    const SizedBox(width: 8),  // Memberi jarak atau menentukan ukuran widget.
                    const Text(  // Menampilkan teks pada antarmuka.
                      'Katalog Destinasi Tersedia',  // Nilai teks untuk daftar atau tampilan.
                      style: TextStyle(  // Mengatur gaya teks.
                        fontSize: 14,  // Menentukan ukuran huruf.
                        fontWeight: FontWeight.bold,  // Menentukan ketebalan teks.
                        color: Colors.black87,  // Menggunakan warna bawaan Flutter.
                      ),  // Menutup pemanggilan widget atau fungsi.
                    ),  // Menutup pemanggilan widget atau fungsi.
                  ],  // Menutup daftar widget atau nilai.
                ),  // Menutup pemanggilan widget atau fungsi.
                const Text(  // Menampilkan teks pada antarmuka.
                  '42 Destinasi Total',  // Nilai teks untuk daftar atau tampilan.
                  style: TextStyle(fontSize: 11, color: Colors.grey),  // Menggunakan warna bawaan Flutter.
                ),  // Menutup pemanggilan widget atau fungsi.
              ],  // Menutup daftar widget atau nilai.
            ),  // Menutup pemanggilan widget atau fungsi.

            const SizedBox(height: 12),  // Memberi jarak atau menentukan ukuran widget.

            // SEARCH BAR
            TextField(  // Membuat kolom input teks untuk pencarian.
              decoration: InputDecoration(  // Mengatur petunjuk, ikon, dan dekorasi kolom input.
                hintText: 'Cari nama pulau, gunung, atau kota...',  // Memisahkan argumen atau properti berikutnya.
                hintStyle:  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                    TextStyle(color: Colors.grey.shade400, fontSize: 12),  // Menggunakan warna bawaan Flutter.
                prefixIcon:  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                    Icon(Icons.search, color: Colors.grey.shade400, size: 18),  // Menampilkan ikon.
                filled: true,  // Memisahkan argumen atau properti berikutnya.
                fillColor: Colors.white,  // Menggunakan warna bawaan Flutter.
                contentPadding: const EdgeInsets.symmetric(vertical: 10),  // Mengatur jarak bagian dalam atau luar widget.
                border: OutlineInputBorder(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                  borderRadius: BorderRadius.circular(10),  // Membulatkan sudut dengan radius yang ditentukan.
                  borderSide: BorderSide(color: Colors.grey.shade200),  // Menggunakan warna bawaan Flutter.
                ),  // Menutup pemanggilan widget atau fungsi.
                enabledBorder: OutlineInputBorder(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                  borderRadius: BorderRadius.circular(10),  // Membulatkan sudut dengan radius yang ditentukan.
                  borderSide: BorderSide(color: Colors.grey.shade200),  // Menggunakan warna bawaan Flutter.
                ),  // Menutup pemanggilan widget atau fungsi.
              ),  // Menutup pemanggilan widget atau fungsi.
            ),  // Menutup pemanggilan widget atau fungsi.

            const SizedBox(height: 12),  // Memberi jarak atau menentukan ukuran widget.

            // CHIP FILTER HORIZONTAL
            SizedBox(  // Memberi jarak atau menentukan ukuran widget.
              height: 34,  // Menentukan ukuran widget.
              child: ListView.separated(  // Membuat daftar horizontal dengan pemisah antaritem.
                scrollDirection: Axis.horizontal,  // Menentukan arah gulir daftar.
                itemCount: _filters.length,  // Menentukan jumlah item yang dibuat.
                separatorBuilder: (context, index) => const SizedBox(width: 6),  // Menentukan jarak atau widget pemisah antaritem.
                itemBuilder: (context, index) {  // Menentukan widget yang dibuat untuk setiap item.
                  final isSelected = _selectedFilterIndex == index;  // Memeriksa apakah filter pada indeks ini sedang dipilih.
                  return GestureDetector(  // Mendeteksi sentuhan atau ketukan pengguna.
                    onTap: () {  // Menentukan tindakan saat area ini diketuk.
                      setState(() {  // Memberi tahu Flutter bahwa state berubah sehingga tampilan dibangun ulang.
                        _selectedFilterIndex = index;  // Menyimpan indeks filter yang baru dipilih.
                      });  // Menutup callback dan pemanggilan fungsi.
                    },  // Menutup blok atau pemanggilan widget sebelumnya.
                    child: Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
                      padding: const EdgeInsets.symmetric(  // Mengatur jarak bagian dalam atau luar widget.
                          horizontal: 14, vertical: 6),  // Memisahkan argumen atau properti berikutnya.
                      decoration: BoxDecoration(  // Mengatur dekorasi wadah.
                        color: isSelected  // Menentukan warna properti.
                            ? const Color(0xFF0066FF)  // Menentukan warna tampilan.
                            : Colors.white,  // Menggunakan warna bawaan Flutter.
                        borderRadius: BorderRadius.circular(16),  // Membulatkan sudut dengan radius yang ditentukan.
                        border: Border.all(  // Mengatur garis tepi di semua sisi.
                          color: isSelected  // Menentukan warna properti.
                              ? const Color(0xFF0066FF)  // Menentukan warna tampilan.
                              : Colors.grey.shade200,  // Menggunakan warna bawaan Flutter.
                        ),  // Menutup pemanggilan widget atau fungsi.
                      ),  // Menutup pemanggilan widget atau fungsi.
                      child: Center(  // Menentukan widget anak yang ditampilkan.
                        child: Text(  // Menampilkan teks pada antarmuka.
                          _filters[index],  // Memisahkan argumen atau properti berikutnya.
                          style: TextStyle(  // Mengatur gaya teks.
                            color: isSelected  // Menentukan warna properti.
                                ? Colors.white  // Menggunakan warna bawaan Flutter.
                                : Colors.grey.shade700,  // Menggunakan warna bawaan Flutter.
                            fontSize: 11,  // Menentukan ukuran huruf.
                            fontWeight: isSelected  // Menentukan ketebalan huruf.
                                ? FontWeight.bold  // Menentukan ketebalan teks.
                                : FontWeight.normal,  // Menentukan ketebalan teks.
                          ),  // Menutup pemanggilan widget atau fungsi.
                        ),  // Menutup pemanggilan widget atau fungsi.
                      ),  // Menutup pemanggilan widget atau fungsi.
                    ),  // Menutup pemanggilan widget atau fungsi.
                  );  // Menutup blok atau pemanggilan widget sebelumnya.
                },  // Menutup blok atau pemanggilan widget sebelumnya.
              ),  // Menutup pemanggilan widget atau fungsi.
            ),  // Menutup pemanggilan widget atau fungsi.
          ],  // Menutup daftar widget atau nilai.
        ),  // Menutup pemanggilan widget atau fungsi.
      ),  // Menutup pemanggilan widget atau fungsi.
    );  // Menutup blok atau pemanggilan widget sebelumnya.
  }  // Menutup blok atau pemanggilan widget sebelumnya.

  // WIDGET PEMBANTU UNTUK KARTU REKOMENDASI
  Widget _buildRecommendationCard({  // Membuat widget pembantu untuk satu kartu rekomendasi.
    required String tag,  // Parameter teks wajib untuk mengisi informasi kartu.
    required Color tagBgColor,  // Parameter warna wajib untuk mengatur tampilan kartu.
    required Color tagTextColor,  // Parameter warna wajib untuk mengatur tampilan kartu.
    required String title,  // Parameter teks wajib untuk mengisi informasi kartu.
    required String category,  // Parameter teks wajib untuk mengisi informasi kartu.
    required String imageUrl,  // Parameter teks wajib untuk mengisi informasi kartu.
    bool isSwapIconHighlight = false,  // Parameter opsional untuk menyorot ikon tukar.
  }) {  // Menutup blok kode.
    return Container(  // Mengembalikan wadah untuk menyusun tampilan.
      decoration: BoxDecoration(  // Mengatur dekorasi wadah.
        color: Colors.white,  // Menggunakan warna bawaan Flutter.
        borderRadius: BorderRadius.circular(14),  // Membulatkan sudut dengan radius yang ditentukan.
        border: Border.all(color: const Color(0xFFEDF2F7)),  // Mengatur garis tepi di semua sisi.
      ),  // Menutup pemanggilan widget atau fungsi.
      child: Column(  // Menyusun widget secara vertikal.
        crossAxisAlignment: CrossAxisAlignment.start,  // Menentukan posisi atau perataan widget.
        children: [  // Menentukan kumpulan widget anak.
          // Gambar dengan Overlay Tag dan Title
          Stack(  // Menumpuk widget agar dapat saling menindih.
            children: [  // Menentukan kumpulan widget anak.
              ClipRRect(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                borderRadius:  // Mengatur pembulatan sudut.
                    const BorderRadius.vertical(top: Radius.circular(14)),  // Mengatur bentuk sudut widget.
                child: Image.network(  // Memuat gambar dari alamat internet.
                  imageUrl,  // Memisahkan argumen atau properti berikutnya.
                  height: 100,  // Menentukan ukuran widget.
                  width: double.infinity,  // Menentukan ukuran widget.
                  fit: BoxFit.cover,  // Mengatur cara gambar menyesuaikan ruang.
                  errorBuilder: (context, error, stackTrace) => Container(  // Menampilkan tampilan pengganti jika gambar gagal dimuat.
                    height: 100,  // Menentukan ukuran widget.
                    width: double.infinity,  // Menentukan ukuran widget.
                    color: Colors.grey.shade300,  // Menggunakan warna bawaan Flutter.
                    child: const Icon(Icons.image, color: Colors.grey),  // Menampilkan ikon.
                  ),  // Menutup pemanggilan widget atau fungsi.
                ),  // Menutup pemanggilan widget atau fungsi.
              ),  // Menutup pemanggilan widget atau fungsi.

              // Tag Atas (Misal: #1 Utama)
              Positioned(  // Menempatkan widget pada posisi tertentu di dalam Stack.
                top: 8,  // Memisahkan argumen atau properti berikutnya.
                left: 8,  // Memisahkan argumen atau properti berikutnya.
                child: Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
                  padding:  // Mengatur jarak widget.
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),  // Mengatur jarak bagian dalam atau luar widget.
                  decoration: BoxDecoration(  // Mengatur dekorasi wadah.
                    color: tagBgColor,  // Menentukan warna properti.
                    borderRadius: BorderRadius.circular(10),  // Membulatkan sudut dengan radius yang ditentukan.
                  ),  // Menutup pemanggilan widget atau fungsi.
                  child: Text(  // Menampilkan teks pada antarmuka.
                    tag,  // Memisahkan argumen atau properti berikutnya.
                    style: TextStyle(  // Mengatur gaya teks.
                      color: tagTextColor,  // Menentukan warna properti.
                      fontSize: 9,  // Menentukan ukuran huruf.
                      fontWeight: FontWeight.bold,  // Menentukan ketebalan teks.
                    ),  // Menutup pemanggilan widget atau fungsi.
                  ),  // Menutup pemanggilan widget atau fungsi.
                ),  // Menutup pemanggilan widget atau fungsi.
              ),  // Menutup pemanggilan widget atau fungsi.

              // Judul Tempat di Bawah Gambar
              Positioned(  // Menempatkan widget pada posisi tertentu di dalam Stack.
                bottom: 8,  // Memisahkan argumen atau properti berikutnya.
                left: 8,  // Memisahkan argumen atau properti berikutnya.
                right: 8,  // Memisahkan argumen atau properti berikutnya.
                child: Text(  // Menampilkan teks pada antarmuka.
                  title,  // Memisahkan argumen atau properti berikutnya.
                  style: const TextStyle(  // Mengatur gaya teks.
                    color: Colors.white,  // Menggunakan warna bawaan Flutter.
                    fontSize: 11,  // Menentukan ukuran huruf.
                    fontWeight: FontWeight.bold,  // Menentukan ketebalan teks.
                    shadows: [  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                      Shadow(  // Mengatur bagian kode ini sesuai struktur widget Flutter.
                        blurRadius: 4,  // Memisahkan argumen atau properti berikutnya.
                        color: Colors.black87,  // Menggunakan warna bawaan Flutter.
                        offset: Offset(0, 1),  // Memisahkan argumen atau properti berikutnya.
                      ),  // Menutup pemanggilan widget atau fungsi.
                    ],  // Menutup daftar widget atau nilai.
                  ),  // Menutup pemanggilan widget atau fungsi.
                  maxLines: 1,  // Membatasi jumlah baris teks.
                  overflow: TextOverflow.ellipsis,  // Menentukan perilaku teks ketika ruang tidak cukup.
                ),  // Menutup pemanggilan widget atau fungsi.
              ),  // Menutup pemanggilan widget atau fungsi.
            ],  // Menutup daftar widget atau nilai.
          ),  // Menutup pemanggilan widget atau fungsi.

          // Area Info Kategori & Tombol Aksi Bottom
          Padding(  // Memberikan ruang kosong di sekitar widget.
            padding: const EdgeInsets.all(8.0),  // Mengatur jarak bagian dalam atau luar widget.
            child: Row(  // Menyusun widget secara horizontal.
              children: [  // Menentukan kumpulan widget anak.
                Expanded(  // Menggunakan ruang yang tersedia pada tata letak.
                  child: Text(  // Menampilkan teks pada antarmuka.
                    category,  // Memisahkan argumen atau properti berikutnya.
                    style: TextStyle(  // Mengatur gaya teks.
                      fontSize: 9,  // Menentukan ukuran huruf.
                      color: Colors.grey.shade700,  // Menggunakan warna bawaan Flutter.
                      fontWeight: FontWeight.w500,  // Menentukan ketebalan teks.
                    ),  // Menutup pemanggilan widget atau fungsi.
                    maxLines: 1,  // Membatasi jumlah baris teks.
                    overflow: TextOverflow.ellipsis,  // Menentukan perilaku teks ketika ruang tidak cukup.
                  ),  // Menutup pemanggilan widget atau fungsi.
                ),  // Menutup pemanggilan widget atau fungsi.

                // Tombol Tukar (Swap)
                Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
                  width: 26,  // Menentukan ukuran widget.
                  height: 26,  // Menentukan ukuran widget.
                  decoration: BoxDecoration(  // Mengatur dekorasi wadah.
                    color: isSwapIconHighlight  // Menentukan warna properti.
                        ? const Color(0xFFEBF2FF)  // Menentukan warna tampilan.
                        : const Color(0xFFF1F5F9),  // Menentukan warna tampilan.
                    borderRadius: BorderRadius.circular(6),  // Membulatkan sudut dengan radius yang ditentukan.
                  ),  // Menutup pemanggilan widget atau fungsi.
                  child: Icon(  // Menampilkan ikon.
                    isSwapIconHighlight ? Icons.sync : Icons.swap_horiz_rounded,  // Memilih ikon yang ditampilkan.
                    size: 14,  // Memisahkan argumen atau properti berikutnya.
                    color: isSwapIconHighlight  // Menentukan warna properti.
                        ? const Color(0xFF0066FF)  // Menentukan warna tampilan.
                        : Colors.black87,  // Menggunakan warna bawaan Flutter.
                  ),  // Menutup pemanggilan widget atau fungsi.
                ),  // Menutup pemanggilan widget atau fungsi.

                const SizedBox(width: 4),  // Memberi jarak atau menentukan ukuran widget.

                // Tombol Hapus (Silang)
                Container(  // Membuat wadah untuk mengatur ukuran, warna, jarak, dan dekorasi.
                  width: 26,  // Menentukan ukuran widget.
                  height: 26,  // Menentukan ukuran widget.
                  decoration: BoxDecoration(  // Mengatur dekorasi wadah.
                    color: const Color(0xFFFFF0F0),  // Menentukan warna tampilan.
                    borderRadius: BorderRadius.circular(6),  // Membulatkan sudut dengan radius yang ditentukan.
                  ),  // Menutup pemanggilan widget atau fungsi.
                  child: const Icon(  // Menampilkan ikon.
                    Icons.close,  // Memilih ikon yang ditampilkan.
                    size: 14,  // Memisahkan argumen atau properti berikutnya.
                    color: Color(0xFFE53935),  // Menentukan warna tampilan.
                  ),  // Menutup pemanggilan widget atau fungsi.
                ),  // Menutup pemanggilan widget atau fungsi.
              ],  // Menutup daftar widget atau nilai.
            ),  // Menutup pemanggilan widget atau fungsi.
          ),  // Menutup pemanggilan widget atau fungsi.
        ],  // Menutup daftar widget atau nilai.
      ),  // Menutup pemanggilan widget atau fungsi.
    );  // Menutup blok atau pemanggilan widget sebelumnya.
  }  // Menutup blok atau pemanggilan widget sebelumnya.
}  // Menutup blok atau pemanggilan widget sebelumnya.
