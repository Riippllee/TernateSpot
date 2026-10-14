import 'package:flutter/material.dart';

import '../../controller/log_admin_controller.dart';
import '../../model/log_admin_model.dart';

// Halaman Log Aktivitas Admin
class LogAdminPage extends StatefulWidget {
  const LogAdminPage({super.key});

  @override
  State<LogAdminPage> createState() => _LogAdminPageState();
}

class _LogAdminPageState extends State<LogAdminPage> {
  // Controller penghubung View ke Service
  final controller = LogAdminController();

  // Menampung data log dari Supabase
  List<LogAdmin> logs = [];

  // Controller input form tambah log
  final idUserController = TextEditingController();
  final aktivitasController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    // Saat halaman dibuka langsung ambil data log
    ambilLog();
  }

  // READ: mengambil data log dari Supabase
  Future<void> ambilLog() async {
    final data = await controller.lihatLog();

    setState(() {
      logs = data;

      loading = false;
    });
  }

  // CREATE: menambah data log ke Supabase
  Future<void> tambahLog() async {
    // Membuat object LogAdmin sesuai model
    final log = LogAdmin(
      idUser: idUserController.text,

      aktivitas: aktivitasController.text,

      tanggalAktivitas: DateTime.now(),
    );

    // Kirim data ke Controller
    await controller.tambahLog(log);

    // Bersihkan form setelah berhasil
    idUserController.clear();

    aktivitasController.clear();

    // Refresh daftar log
    ambilLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Log Aktivitas Admin",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // FORM TAMBAH LOG ADMIN

                Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [
                      TextField(
                        controller: idUserController,

                        decoration: const InputDecoration(
                          labelText: "ID User",

                          hintText: "Masukkan UUID User",

                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: aktivitasController,

                        decoration: const InputDecoration(
                          labelText: "Aktivitas",

                          hintText: "Contoh: Menambah rekomendasi",

                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: tambahLog,

                        child: const Text("Tambah Log"),
                      ),
                    ],
                  ),
                ),

                // MENAMPILKAN JUMLAH LOG
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  child: Align(
                    alignment: Alignment.centerLeft,

                    child: Text(
                      "Total Aktivitas : ${logs.length}",

                      style: const TextStyle(
                        fontSize: 16,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // LIST DATA LOG
                Expanded(
                  child: logs.isEmpty
                      ? const Center(child: Text("Belum ada aktivitas admin"))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          itemCount: logs.length,

                          itemBuilder: (context, index) {
                            final log = logs[index];

                            return Card(
                              elevation: 4,

                              margin: const EdgeInsets.only(bottom: 12),

                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.admin_panel_settings),
                                ),

                                title: Text(
                                  log.aktivitas,

                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    const SizedBox(height: 5),

                                    Text("User ID : ${log.idUser}"),

                                    Text("Waktu : ${log.tanggalAktivitas}"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  // Membersihkan controller ketika halaman ditutup
  @override
  void dispose() {
    idUserController.dispose();

    aktivitasController.dispose();

    super.dispose();
  }
}
