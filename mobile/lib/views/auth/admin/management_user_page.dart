// Mengambil komponen Flutter untuk membuat tampilan,
// seperti tombol, teks, kolom input, dan dialog.
import 'package:flutter/material.dart';

// Class ini merupakan halaman utama Management User.
// StatefulWidget digunakan karena data dan tampilan bisa berubah,
// misalnya ketika pengguna ditambah atau statusnya diubah.
class ManagementUserPage extends StatefulWidget {
  const ManagementUserPage({super.key});

  @override
  State<ManagementUserPage> createState() => _ManagementUserPageState();
}

// Bagian ini mengatur data dan perubahan tampilan halaman.
class _ManagementUserPageState extends State<ManagementUserPage> {
  // Controller untuk membaca tulisan yang dimasukkan
  // pada kolom pencarian nama atau email.
  final TextEditingController searchController = TextEditingController();
  // Menyimpan pilihan filter yang sedang digunakan.
  // Pilihan awal adalah menampilkan semua pengguna.
  String selectedFilter = 'Semua';

  // Daftar pengguna contoh yang ditampilkan di layar.
  // Setiap pengguna memiliki nama, email, peran, tanggal,
  // dan status aktif atau nonaktif.
  // Data ini masih berada di dalam aplikasi, belum dari Supabase.
  final List<Map<String, dynamic>> users = [
    {'name': 'Sarah', 'email': 'sarah.h@acme.io', 'role': 'Administrator', 'date': '12 Jan 2024', 'active': true, 'initials': 'S', 'color': const Color(0xFFD8C8B8), 'last': 'Aktif 5m lalu'},
    {'name': 'Aliyah Jenkins', 'email': 'aliyah.j@acme.io', 'role': 'Editor', 'date': '03 Feb 2024', 'active': true, 'initials': 'AJ', 'color': const Color(0xFFE7C5A8), 'last': 'Aktif 12m lalu'},
    {'name': 'Ahmad Fauzi', 'email': 'ahmad.f@acme.io', 'role': 'Viewer', 'date': '18 Nov 2023', 'active': false, 'initials': 'AF', 'color': const Color(0xFFDCE8FF), 'last': 'Nonaktif 3h lalu'},
    {'name': 'Jessica Lee', 'email': 'jessica.l@acme.io', 'role': 'Editor', 'date': '29 Des 2023', 'active': true, 'initials': 'JL', 'color': const Color(0xFFD8C8B8), 'last': 'Aktif 1j lalu'},
    {'name': 'Rian Pratama', 'email': 'rian.p@acme.io', 'role': 'Viewer', 'date': '10 Jan 2024', 'active': true, 'initials': 'RP', 'color': const Color(0xFFDCE8FF), 'last': 'Aktif 8m lalu'},
  ];


  // Mengambil daftar pengguna sesuai tulisan pencarian dan filter.
  List<Map<String, dynamic>> get filteredUsers {
    final q = searchController.text.trim().toLowerCase();
    return users.where((u) {
      // Memeriksa apakah nama atau email cocok dengan pencarian.
      final matchText = (u['name'] as String).toLowerCase().contains(q) ||
          (u['email'] as String).toLowerCase().contains(q);
      // Memeriksa apakah pengguna sesuai dengan filter.
      final matchFilter = switch (selectedFilter) {
        'Aktif' => u['active'] == true,
        'Nonaktif' => u['active'] == false,
        'Admin' => u['role'] == 'Administrator',
        _ => true,
      };

      // Pengguna ditampilkan jika pencarian dan filter cocok.
      return matchText && matchFilter;
    }).toList();
  }

  // Membersihkan controller ketika halaman ditutup.
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Fungsi build digunakan untuk menyusun tampilan halaman.
  @override
  Widget build(BuildContext context) {

    // Scaffold menjadi kerangka dasar halaman aplikasi.
    return Scaffold(
      // Memberikan warna latar belakang halaman.
      backgroundColor: const Color(0xFFF5F7FD),
      // AppBar bagian atas halaman.
      // Di dalamnya terdapat tombol kembali, judul,
      // dan avatar pengguna.
      appBar: AppBar(
        toolbarHeight: 53,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        // Ikon kembali. Ikon ini belum diberi aksi navigasi.
        leading: const Icon(Icons.arrow_back, color: Color(0xFF1E3048), size: 21),
        titleSpacing: 0,
        title: const Text('Detail Pengguna', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E3048))),
        // Foto profil contoh di kanan atas.
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(radius: 15, backgroundColor: Color(0xFFDCE5F2), child: Icon(Icons.person, size: 19, color: Color(0xFF405879))),
          ),
        ],
      ),

      // ListView menyusun isi halaman secara vertikal
      // dan memungkinkan halaman digulir.
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          // Judul halaman dan tombol tambah pengguna.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Manajemen Pengguna', style: TextStyle(fontSize: 19, height: 1.25, fontWeight: FontWeight.w700, letterSpacing: -0.3, color: Color(0xFF172A43))),
                    SizedBox(height: 5),
                    Text('Kelola akses, peran, dan status\\nakun...', style: TextStyle(fontSize: 11.5, height: 1.35, color: Color(0xFF687487))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Tombol untuk membuka formulir tambah pengguna.
              SizedBox(
                height: 35,
                child: ElevatedButton.icon(
                  onPressed: addUser,
                  icon: const Icon(Icons.person_add_alt_1, size: 15),
                  label: const Text('+ Tambah', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF294DB7), foregroundColor: Colors.white, elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ],
          ),

          const SizedBox(height: 17),
          // Kartu ringkasan jumlah pengguna.
          // Angka berikut masih angka contoh, bukan hasil hitung database.
          SizedBox(
            height: 72,
            child: Row(
              children: [
                Expanded(child: statCard('Total User', '1,248', '↑4%', Icons.groups, const Color(0xFFE0E9FF), const Color(0xFF2858B6))),
                const SizedBox(width: 8),
                Expanded(child: statCard('Aktif', '1,180', '94.5%', Icons.verified_user_outlined, const Color(0xFFDDF5E9), const Color(0xFF167956))),
                const SizedBox(width: 8),
                Expanded(child: statCard('Admin', '12', 'Role', Icons.admin_panel_settings_outlined, const Color(0xFFE3E9FF), const Color(0xFF3A58A8))),
              ],
            ),
          ),
          const SizedBox(height: 17),
          // Kolom pencarian dan tombol filter.
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 41,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)),
                  child: TextField(
                    controller: searchController,
                    // Memperbarui tampilan setiap kali tulisan berubah.
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(fontSize: 12),
                    decoration: const InputDecoration(
                      hintText: 'Cari nama atau email...',
                      hintStyle: TextStyle(fontSize: 12, color: Color(0xFFA0A7B4)),
                      prefixIcon: Icon(Icons.search, size: 19, color: Color(0xFF7A8495)),
                      prefixIconConstraints: BoxConstraints(minWidth: 37),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Membuka pilihan filter.
              SizedBox(
                height: 41,
                child: OutlinedButton.icon(
                  onPressed: showFilter,
                  icon: const Icon(Icons.tune, size: 16),
                  label: const Text('Filter', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF263B59), side: BorderSide.none, padding: const EdgeInsets.symmetric(horizontal: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),

          // Pilihan filter cepat di bawah kolom pencarian.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Semua', 'Aktif', 'Nonaktif', 'Admin'].map((label) {
                final selected = selectedFilter == label;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    // Mengganti filter ketika pilihan ditekan.
                    onTap: () => setState(() => selectedFilter = label),
                    child: Container(
                      height: 25,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: selected ? const Color(0xFF075BC9) : Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: selected ? Colors.white : const Color(0xFF586276))),
                          if (selected) ...[const SizedBox(width: 5), const Icon(Icons.circle, size: 4, color: Colors.white)],
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),
          // Jika tidak ada hasil, tampilkan pesan.
          if (filteredUsers.isEmpty)
            Container(padding: const EdgeInsets.all(28), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: const Text('Pengguna tidak ditemukan.', textAlign: TextAlign.center))
          else
            ...filteredUsers.map(userCard),
        ],
      ),
    );
  }

  // Membuat kartu ringkasan, seperti Total User, Aktif, dan Admin.
  Widget statCard(String title, String value, String note, IconData icon, Color iconBg, Color iconColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 9, 8, 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Color(0xFF4F596B)))),
            CircleAvatar(radius: 10, backgroundColor: iconBg, child: Icon(icon, size: 11, color: iconColor)),
          ]),
          const Spacer(),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Flexible(child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1C2E47)))),
            const SizedBox(width: 4),
            Padding(padding: const EdgeInsets.only(bottom: 2), child: Text(note, style: TextStyle(fontSize: 9, color: title == 'Total User' ? const Color(0xFF16865E) : const Color(0xFF697386)))),
          ]),
        ],
      ),
    );
  }

  // Membuat kartu informasi untuk satu pengguna.
  Widget userCard(Map<String, dynamic> user) {
    final active = user['active'] as bool;
    final role = user['role'] as String;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: const Color(0xFF273B5B).withOpacity(0.035), blurRadius: 7, offset: const Offset(0, 2))]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 8, 12),
            child: Row(
              children: [
                // Avatar berupa inisial nama pengguna.
                CircleAvatar(radius: 20, backgroundColor: user['color'] as Color, child: Text(user['initials'] as String, style: const TextStyle(color: Color(0xFF31538F), fontSize: 11, fontWeight: FontWeight.w700))),
                const SizedBox(width: 10),

                // Nama, peran, dan email pengguna.
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 6, runSpacing: 3, children: [
                      Text(user['name'] as String, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF26384F))),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: roleBg(role), borderRadius: BorderRadius.circular(20)), child: Text(role, style: TextStyle(fontSize: 9.5, height: 1, fontWeight: FontWeight.w600, color: roleFg(role)))),
                    ]),
                    const SizedBox(height: 4),
                    Text(user['email'] as String, style: const TextStyle(fontSize: 10.5, color: Color(0xFF697386))),
                  ]),
                ),

                // Switch untuk mengubah status aktif atau nonaktif.
                Transform.scale(
                  scale: 0.83,
                  child: Switch(
                    value: active,
                    onChanged: (value) => setState(() {
                      user['active'] = value;
                      user['last'] = value ? 'Aktif sekarang' : 'Nonaktif sekarang';
                    }),
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF006347),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFC8CAD8),
                  ),
                ),
              ],
            ),
          ),

          // Bagian bawah kartu berisi tanggal, status terakhir,
          // tombol detail, dan tombol hapus.
          Container(
            color: const Color(0xFFF5F7FD),
            padding: const EdgeInsets.fromLTRB(12, 7, 8, 7),
            child: Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF81899A)),
              const SizedBox(width: 4),
              Text(user['date'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF657084))),
              const SizedBox(width: 7),
              Icon(Icons.circle, size: 6, color: active ? const Color(0xFF007452) : const Color(0xFF9399A7)),
              const SizedBox(width: 4),
              Expanded(child: Text(user['last'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Color(0xFF657084)))),
              // Tombol untuk melihat detail pengguna.
              SizedBox(width: 29, height: 29, child: IconButton(tooltip: 'Lihat detail', padding: EdgeInsets.zero, onPressed: () => showDetails(user), icon: const Icon(Icons.visibility_outlined, size: 17, color: Color(0xFF596273)))),
              const SizedBox(width: 3),
              // Tombol untuk menghapus pengguna dari daftar contoh.
              SizedBox(width: 29, height: 29, child: IconButton(tooltip: 'Hapus pengguna', padding: EdgeInsets.zero, onPressed: () => confirmDelete(user), icon: const Icon(Icons.delete_outline, size: 17, color: Color(0xFFE53935)))),
            ]),
          ),
        ],
      ),
    );
  }

  // Menentukan warna latar belakang label peran pengguna.
  Color roleBg(String role) => switch (role) {
    'Administrator' => const Color(0xFFBBC7FF),
    'Editor' => const Color(0xFFD5E6FF),
    _ => const Color(0xFFE8EDF6),
  };
  // Menentukan warna tulisan label peran pengguna.
  Color roleFg(String role) => switch (role) {
    'Administrator' => const Color(0xFF1E347B),
    'Editor' => const Color(0xFF1B63B8),
    _ => const Color(0xFF697386),
  };
  // Menampilkan pilihan filter dalam panel dari bawah layar.
  void showFilter() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Filter Pengguna', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Setiap pilihan akan mengganti filter yang aktif.
            ...['Semua', 'Aktif', 'Nonaktif', 'Admin'].map((option) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(option),
              trailing: selectedFilter == option ? const Icon(Icons.check, color: Color(0xFF075BC9)) : null,
              onTap: () { setState(() => selectedFilter = option); Navigator.pop(sheetContext); },
            )),
          ]),
        ),
      ),
    );
  }

  // Menampilkan formulir untuk menambahkan pengguna baru.
  void addUser() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    // Peran awal yang dipilih adalah Viewer.
    String role = 'Viewer';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Tambah Pengguna'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Input nama lengkap pengguna.
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama lengkap', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            // Input email pengguna.
            TextField(controller: emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 12),

            // Dropdown untuk menentukan peran pengguna.
            DropdownButtonFormField<String>(
              value: role,
              decoration: const InputDecoration(labelText: 'Peran', border: OutlineInputBorder()),
              items: ['Administrator', 'Editor', 'Viewer'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (value) { if (value != null) setDialogState(() => role = value); },
            ),
          ]
        )
      ),

          actions: [
            // Menutup formulir tanpa menyimpan.
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),

            // Memeriksa input lalu menambahkan pengguna ke daftar.
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final email = emailController.text.trim();

                // Validasi sederhana untuk nama dan email.
                if (name.isEmpty || !email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Masukkan nama dan email yang benar.')));
                  return;
                }

                // Memperbarui daftar pengguna di memori aplikasi.
                setState(() => users.add({
                  'name': name, 'email': email, 'role': role, 'date': '13 Okt 2026',
                  'active': true, 
                   // Mengambil maksimal dua inisial dari nama.
                  'initials': name.split(RegExp(r'\\s+')).where((p) => p.isNotEmpty).take(2).map((p) => p[0].toUpperCase()).join(),
                  'color': const Color(0xFFDCE8FF), 'last': 'Aktif sekarang',
                }));
                Navigator.pop(dialogContext);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
      // Membersihkan controller setelah formulir ditutup.
    ).then((_) { nameController.dispose(); emailController.dispose(); });
  }

  // Menampilkan informasi lengkap dari pengguna yang dipilih.
  void showDetails(Map<String, dynamic> user) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 28),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Detail Pengguna', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Menampilkan avatar, nama, dan email.
            Row(children: [
              CircleAvatar(radius: 20, backgroundColor: user['color'] as Color, child: Text(user['initials'] as String, style: const TextStyle(color: Color(0xFF31538F)))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(user['email'] as String, style: const TextStyle(color: Color(0xFF70798A), fontSize: 12)),
              ])),
            ]),
            const Divider(height: 28),
            // Menampilkan peran, status, dan tanggal bergabung.
            detailRow('Peran', user['role'] as String),
            detailRow('Status', user['active'] ? 'Aktif' : 'Nonaktif'),
            detailRow('Tanggal bergabung', user['date'] as String),
          ]),
        ),
      ),
    );
  }

  // Membuat satu baris informasi pada panel detail.
  Widget detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF747D8D), fontSize: 13))),
      Text(value, style: const TextStyle(color: Color(0xFF26384F), fontSize: 13, fontWeight: FontWeight.w600)),
    ]),
  );
  // Meminta konfirmasi sebelum pengguna dihapus.
  void confirmDelete(Map<String, dynamic> user) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Hapus pengguna?'),
        content: Text('Kamu yakin ingin menghapus ${user['name']} dari daftar?'),
        actions: [
          // Membatalkan penghapusan.
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),

          // Menghapus pengguna dari daftar lokal.
          TextButton(
            onPressed: () {
              setState(() => users.remove(user));
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengguna dihapus dari daftar contoh.')));
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
