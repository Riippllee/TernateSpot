import 'package:flutter/material.dart';

import '../../controller/log_admin_controller.dart';
import '../../model/log_admin_model.dart';

class LogAdminPage extends StatefulWidget {
  const LogAdminPage({super.key});

  @override
  State<LogAdminPage> createState() => _LogAdminPageState();
}

class _LogAdminPageState extends State<LogAdminPage> {
  final controller = LogAdminController();

  List<LogAdmin> logs = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    ambilLog();
  }

  Future<void> ambilLog() async {
    final data = await controller.lihatLog();

    setState(() {
      logs = data;

      loading = false;
    });
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
          : logs.isEmpty
          ? const Center(
              child: Text(
                "Belum ada aktivitas admin",
                style: TextStyle(fontSize: 16),
              ),
            )
          : Column(
              children: [
                // jumlah log
                Padding(
                  padding: const EdgeInsets.all(16),

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

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    itemCount: logs.length,

                    itemBuilder: (context, index) {
                      final log = logs[index];

                      return Card(
                        elevation: 4,

                        margin: const EdgeInsets.only(bottom: 12),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),

                          leading: CircleAvatar(
                            radius: 25,

                            child: const Icon(
                              Icons.admin_panel_settings,
                              size: 28,
                            ),
                          ),

                          title: Text(
                            log.aktivitas,

                            style: const TextStyle(
                              fontWeight: FontWeight.bold,

                              fontSize: 15,
                            ),
                          ),

                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),

                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),

                                const SizedBox(width: 5),

                                Text(log.tanggalAktivitas.toString()),
                              ],
                            ),
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
}
