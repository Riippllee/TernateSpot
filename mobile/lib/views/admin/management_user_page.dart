
import '../../controllers/user_management_controller.dart';
import '../../models/user_model.dart';

import 'package:flutter/material.dart';

class ManagementUserPage extends StatefulWidget {
  const ManagementUserPage({super.key});

  @override
  State<ManagementUserPage> createState() => _ManagementUserPageState();
}

class _ManagementUserPageState extends State<ManagementUserPage> {
  // Controller pencarian dan pengelolaan pengguna.
  final TextEditingController searchController = TextEditingController();
  final UserManagementController _controller = UserManagementController();
  final TextEditingController passwordController = TextEditingController();

  // Filter yang sedang dipilih.
  String selectedFilter = 'Semua';

  // Daftar pengguna dari backend.
  List<Map<String, dynamic>> users = [];

  bool isLoading = true;
  String? loadError;

  // Memuat data ketika halaman pertama kali dibuka.
  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Menghitung total seluruh pengguna.
  int get totalUserCount => users.length;

  // Menghitung pengguna aktif.
  int get activeUserCount =>
      users.where((user) => user['active'] == true).length;

  // Menghitung jumlah administrator.
  int get adminCount => users
      .where((user) => user['role'].toString().toLowerCase() == 'admin')
      .length;

  // Menghitung persentase pengguna aktif.
  double get activePercentage =>
      users.isEmpty ? 0 : activeUserCount / users.length * 100;

  // Mengambil daftar pengguna dari controller.
  Future<void> _loadUsers() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      loadError = null;
    });

    try {
      final List<UserModel> data = await _controller.getAllUsers();

      if (!mounted) return;

      setState(() {
        users = data.map((user) {
          final name = user.nama;

          return {
            'id_user': user.idUser,
            'name': name,
            'email': user.email,
            'role': user.role,
            'active': user.status,
            'date': _formatDate(user.tanggalDaftar),
            'updatedAt': _formatDate(user.tanggalPerubahan),
            'initials': name
                .trim()
                .split(RegExp(r'\s+'))
                .where((part) => part.isNotEmpty)
                .take(2)
                .map((part) => part[0].toUpperCase())
                .join(),
            'color': const Color(0xFFDCE8FF),
            'last': user.status ? 'Aktif' : 'Nonaktif',
          };
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        loadError = e.toString();
      });
    }
  }

  // Mengubah format tanggal agar mudah dibaca.
  String _formatDate(DateTime? date) {
    if (date == null) return '-';

    final utcDate = date.toUtc();

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final day = utcDate.day.toString().padLeft(2, '0');
    final month = months[utcDate.month - 1];
    final year = utcDate.year;

    return '$day $month $year';
  }

  // Menghapus pengguna melalui backend.
  Future<void> _deleteUser(Map<String, dynamic> user) async {
    final idUser = user['id_user']?.toString();

    if (idUser == null || idUser.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID pengguna tidak ditemukan.')),
      );
      return;
    }

    try {
      await _controller.deleteUserProfile(idUser);

      if (!mounted) return;

      setState(() {
        users.removeWhere((item) => item['id_user']?.toString() == idUser);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengguna berhasil dihapus.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus pengguna: $e')),
      );
    }
  }

  // Mengambil data sesuai kata pencarian dan filter.
  List<Map<String, dynamic>> get filteredUsers {
    final q = searchController.text.trim().toLowerCase();

    return users.where((u) {
      final matchText =
          (u['name'] as String).toLowerCase().contains(q) ||
          (u['email'] as String).toLowerCase().contains(q);

      final matchFilter = switch (selectedFilter) {
        'Aktif' => u['active'] == true,
        'Nonaktif' => u['active'] == false,
        'Admin' => u['role'] == 'Administrator',
        _ => true,
      };

      return matchText && matchFilter;
    }).toList();
  }

  // Membersihkan controller ketika halaman ditutup.
  @override
  void dispose() {
    searchController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ======================================================
  // HALAMAN UTAMA MANAJEMEN PENGGUNA
  // ======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FD),

      // Header halaman.
      appBar: AppBar(
        toolbarHeight: 53,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        title: const Text(
          'Detail Pengguna',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3048),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Color(0xFFDCE5F2),
              child: Icon(
                Icons.person,
                size: 19,
                color: Color(0xFF405879),
              ),
            ),
          ),
        ],
      ),

      // Konten halaman yang dapat digulir.
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
        children: [
          // Judul dan tombol tambah pengguna.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manajemen Pengguna',
                      style: TextStyle(
                        fontSize: 19,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: Color(0xFF172A43),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Kelola akses, peran, dan status akun...',
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.35,
                        color: Color(0xFF687487),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Tombol untuk membuka popup tambah pengguna.
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: addUser,
                  icon: const Icon(
                    Icons.person_add_alt_1,
                    size: 16,
                  ),
                  label: const Text(
                    '+ Tambah',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF294DB7),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Kartu statistik jumlah pengguna.
          SizedBox(
            height: 82,
            child: Row(
              children: [
                Expanded(
                  child: statCard(
                    'Total User',
                    totalUserCount.toString(),
                    'Semua pengguna',
                    Icons.groups,
                    const Color(0xFFE0E9FF),
                    const Color(0xFF2858B6),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: statCard(
                    'Aktif',
                    activeUserCount.toString(),
                    '${activePercentage.toStringAsFixed(1)}%',
                    Icons.verified_user_outlined,
                    const Color(0xFFDDF5E9),
                    const Color(0xFF167956),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: statCard(
                    'Admin',
                    adminCount.toString(),
                    'Role',
                    Icons.admin_panel_settings_outlined,
                    const Color(0xFFE3E9FF),
                    const Color(0xFF3A58A8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Kolom pencarian pengguna.
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: const Color(0xFFEDF0F5)),
            ),
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                hintText: 'Cari nama atau email...',
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA0A7B4),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Color(0xFF7A8495),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 42),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Filter cepat pengguna.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Semua', 'Aktif', 'Nonaktif', 'Admin'].map((label) {
                final selected = selectedFilter == label;

                return Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = label;
                      });
                    },
                    child: Container(
                      height: 33,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF075BC9)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF075BC9)
                              : const Color(0xFFEDF0F5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF586276),
                            ),
                          ),
                          if (selected) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.circle,
                              size: 4,
                              color: Colors.white,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 14),

          // Judul daftar pengguna.
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Daftar Pengguna',
                  style: TextStyle(
                    color: Color(0xFF1E3048),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${filteredUsers.length} pengguna',
                style: const TextStyle(
                  color: Color(0xFF8993A3),
                  fontSize: 10,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Tampilan loading, error, kosong, atau daftar pengguna.
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF294DB7),
                ),
              ),
            )
          else if (loadError != null)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_off_outlined,
                    size: 40,
                    color: Color(0xFF8993A3),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Gagal Memuat Pengguna',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    loadError!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF748094),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _loadUsers,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF294DB7),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          else if (filteredUsers.isEmpty)
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.person_search_outlined,
                    size: 42,
                    color: Color(0xFF9AA4B5),
                  ),
                  SizedBox(height: 9),
                  Text(
                    'Pengguna tidak ditemukan.',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Coba kata pencarian atau filter lainnya.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8993A3),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            )
          else
            ...filteredUsers.map(userCard),
        ],
      ),
    );
  }

  // ======================================================
  // KARTU STATISTIK
  // ======================================================

  Widget statCard(
    String title,
    String value,
    String note,
    IconData icon,
    Color iconBg,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 8, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDF0F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4F596B),
                  ),
                ),
              ),
              CircleAvatar(
                radius: 10,
                backgroundColor: iconBg,
                child: Icon(icon, size: 11, color: iconColor),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C2E47),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    color: title == 'Total User'
                        ? const Color(0xFF16865E)
                        : const Color(0xFF697386),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ======================================================
  // KARTU PENGGUNA
  // ======================================================

  Widget userCard(Map<String, dynamic> user) {
    final active = user['active'] as bool;
    final role = user['role'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFEDF0F5)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF273B5B).withOpacity(0.035),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 13, 8, 12),
            child: Row(
              children: [
                // Avatar inisial pengguna.
                CircleAvatar(
                  radius: 21,
                  backgroundColor: user['color'] as Color,
                  child: Text(
                    user['initials'] as String,
                    style: const TextStyle(
                      color: Color(0xFF31538F),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Nama, role, dan email.
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        runSpacing: 3,
                        children: [
                          Text(
                            user['name'] as String,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF26384F),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: roleBg(role),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                fontSize: 9.5,
                                height: 1,
                                fontWeight: FontWeight.w600,
                                color: roleFg(role),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['email'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF697386),
                        ),
                      ),
                    ],
                  ),
                ),

                // Switch status aktif atau nonaktif.
                Transform.scale(
                  scale: 0.83,
                  child: Switch(
                    value: active,
                    onChanged: (value) async {
                      final idUser = user['id_user'] as String;
                      final oldStatus = user['active'] as bool;

                      setState(() {
                        user['active'] = value;
                        user['last'] = value
                            ? 'Aktif sekarang'
                            : 'Nonaktif sekarang';
                      });

                      try {
                        await _controller.updateUserStatus(idUser, value);

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Status pengguna berhasil diperbarui.',
                            ),
                          ),
                        );
                      } catch (e) {
                        if (!mounted) return;

                        setState(() {
                          user['active'] = oldStatus;
                          user['last'] = oldStatus ? 'Aktif' : 'Nonaktif';
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal memperbarui status: $e'),
                          ),
                        );
                      }
                    },
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF006347),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFC8CAD8),
                  ),
                ),
              ],
            ),
          ),

          // Tanggal, status, tombol detail, dan hapus.
          Container(
            color: const Color(0xFFF5F7FD),
            padding: const EdgeInsets.fromLTRB(12, 7, 8, 7),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Color(0xFF81899A),
                ),
                const SizedBox(width: 4),
                Text(
                  user['date'] as String,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF657084),
                  ),
                ),
                const SizedBox(width: 7),
                Icon(
                  Icons.circle,
                  size: 6,
                  color: active
                      ? const Color(0xFF007452)
                      : const Color(0xFF9399A7),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    user['last'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF657084),
                    ),
                  ),
                ),

                // Tombol detail.
                SizedBox(
                  width: 29,
                  height: 29,
                  child: IconButton(
                    tooltip: 'Lihat detail',
                    padding: EdgeInsets.zero,
                    onPressed: () => showDetails(user),
                    icon: const Icon(
                      Icons.visibility_outlined,
                      size: 17,
                      color: Color(0xFF596273),
                    ),
                  ),
                ),

                const SizedBox(width: 3),

                // Tombol hapus.
                SizedBox(
                  width: 29,
                  height: 29,
                  child: IconButton(
                    tooltip: 'Hapus pengguna',
                    padding: EdgeInsets.zero,
                    onPressed: () => confirmDelete(user),
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 17,
                      color: Color(0xFFE53935),
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

  // Warna latar badge role.
  Color roleBg(String role) => switch (role) {
        'Administrator' => const Color(0xFFBBC7FF),
        'Editor' => const Color(0xFFD5E6FF),
        _ => const Color(0xFFE8EDF6),
      };

  // Warna tulisan badge role.
  Color roleFg(String role) => switch (role) {
        'Administrator' => const Color(0xFF1E347B),
        'Editor' => const Color(0xFF1B63B8),
        _ => const Color(0xFF697386),
      };

  // ======================================================
  // FILTER PENGGUNA
  // ======================================================

  void showFilter() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Pengguna',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3048),
                ),
              ),
              const SizedBox(height: 10),

              // Pilihan filter.
              ...['Semua', 'Aktif', 'Nonaktif', 'Admin'].map(
                (option) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(option),
                  trailing: selectedFilter == option
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF075BC9),
                        )
                      : null,
                  onTap: () {
                    setState(() => selectedFilter = option);
                    Navigator.pop(sheetContext);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======================================================
  // POPUP TAMBAH PENGGUNA
  // Role: User dihapus dari tampilan popup.
  // ======================================================

  void addUser() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    bool passwordVisible = false;
    bool isSaving = false;
    String? formError;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              elevation: 12,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(23),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header popup.
                          Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE9EFFF),
                                      Color(0xFFDCE6FF),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.person_add_alt_1_rounded,
                                  color: Color(0xFF294DB7),
                                  size: 27,
                                ),
                              ),
                              const SizedBox(width: 13),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tambah Pengguna',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1E3048),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Tambahkan akun pengguna baru',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF8993A3),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                tooltip: 'Tutup',
                                onPressed: isSaving
                                    ? null
                                    : () => Navigator.pop(dialogContext),
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Color(0xFF8993A3),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          const Divider(
                            color: Color(0xFFEEF0F5),
                            height: 1,
                          ),

                          const SizedBox(height: 20),

                          // Judul form.
                          const Text(
                            'Informasi Akun',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E3048),
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            'Lengkapi informasi berikut untuk menambahkan pengguna baru.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF8993A3),
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // INPUT NAMA LENGKAP
                          _addUserLabel('Nama Lengkap'),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: nameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: _addUserInputDecoration(
                              hint: 'Masukkan nama lengkap',
                              icon: Icons.person_outline_rounded,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama lengkap wajib diisi.';
                              }

                              if (value.trim().length < 3) {
                                return 'Nama minimal 3 karakter.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 17),

                          // INPUT EMAIL
                          _addUserLabel('Alamat Email'),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _addUserInputDecoration(
                              hint: 'contoh@email.com',
                              icon: Icons.email_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Email wajib diisi.';
                              }

                              final validEmail = RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              ).hasMatch(value.trim());

                              if (!validEmail) {
                                return 'Format email tidak valid.';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 17),

                          // INPUT PASSWORD
                          _addUserLabel('Password Sementara'),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: passwordController,
                            obscureText: !passwordVisible,
                            decoration: _addUserInputDecoration(
                              hint: 'Masukkan password',
                              icon: Icons.lock_outline_rounded,
                            ).copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setDialogState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF8993A3),
                                  size: 19,
                                ),
                              ),
                              helperText: 'Minimal 8 karakter.',
                              helperStyle: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF8993A3),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password wajib diisi.';
                              }

                              if (value.length < 8) {
                                return 'Password minimal 8 karakter.';
                              }

                              return null;
                            },
                          ),

                          // Pesan error backend di dalam popup.
                          if (formError != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEEEE),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Text(
                                formError!,
                                style: const TextStyle(
                                  color: Color(0xFFCA3838),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 18),

                          // Informasi tambahan.
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Color(0xFF294DB7),
                                  size: 19,
                                ),
                                SizedBox(width: 9),
                                Expanded(
                                  child: Text(
                                    'Pastikan alamat email dan informasi akun sudah benar sebelum disimpan.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF596B91),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Tombol batal dan simpan.
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: isSaving
                                      ? null
                                      : () => Navigator.pop(dialogContext),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF596579),
                                    side: const BorderSide(
                                      color: Color(0xFFE4E8EF),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Batal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 11),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: isSaving
                                      ? null
                                      : () async {
                                          if (!formKey.currentState!.validate()) {
                                            return;
                                          }

                                          FocusScope.of(dialogContext).unfocus();

                                          setDialogState(() {
                                            isSaving = true;
                                            formError = null;
                                          });

                                          final name =
                                              nameController.text.trim();
                                          final email =
                                              emailController.text.trim();
                                          final password =
                                              passwordController.text;

                                          try {
                                            // Menyimpan akun melalui controller.
                                            await _controller.createUser(
                                              nama: name,
                                              email: email,
                                              password: password,
                                            );

                                            if (!mounted) return;

                                            // Menutup popup setelah berhasil.
                                            Navigator.of(dialogContext).pop();

                                            // Mengambil ulang data pengguna.
                                            await _loadUsers();

                                            if (!mounted) return;

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Pengguna berhasil ditambahkan.',
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          } catch (e) {
                                            if (!mounted) return;

                                            setDialogState(() {
                                              isSaving = false;
                                              formError =
                                                  'Gagal menambahkan pengguna: $e';
                                            });
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF294DB7),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: isSaving
                                      ? const SizedBox(
                                          width: 19,
                                          height: 19,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.person_add_alt_1,
                                              size: 16,
                                            ),
                                            SizedBox(width: 7),
                                            Text(
                                              'Simpan',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      emailController.dispose();

      if (mounted) {
        passwordController.clear();
      }
    });
  }

  // Label untuk kolom input popup.
  Widget _addUserLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF35445B),
      ),
    );
  }

  // Dekorasi kolom input popup.
  InputDecoration _addUserInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFFA0A8B6),
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF8490A4),
        size: 19,
      ),
      filled: true,
      fillColor: const Color(0xFFF8F9FC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E9F1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFE5E9F1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFF294DB7),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.3,
        ),
      ),
    );
  }

  // ======================================================
  // DETAIL PENGGUNA
  // ======================================================

  void showDetails(Map<String, dynamic> user) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Pengguna',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Avatar, nama, dan email pengguna.
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: user['color'] as Color,
                    child: Text(
                      user['initials'] as String,
                      style: const TextStyle(
                        color: Color(0xFF31538F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          user['email'] as String,
                          style: const TextStyle(
                            color: Color(0xFF70798A),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 28),

              detailRow('Peran', user['role'] as String),
              detailRow(
                'Status',
                user['active'] ? 'Aktif' : 'Nonaktif',
              ),
              detailRow(
                'Tanggal bergabung',
                user['date']?.toString() ?? '-',
              ),
              detailRow(
                'Terakhir diperbarui',
                user['updatedAt']?.toString() ?? '-',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Membuat satu baris informasi pada panel detail.
  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF747D8D),
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF26384F),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // KONFIRMASI HAPUS PENGGUNA
  // ======================================================

  Future<void> confirmDelete(Map<String, dynamic> user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Hapus pengguna?'),
        content: Text(
          'Kamu yakin ingin menghapus ${user['name']}?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false);
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(true);
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _deleteUser(user);
    }
  }
}
