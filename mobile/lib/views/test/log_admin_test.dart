import 'package:flutter/material.dart';

import '../../controller/log_admin_controller.dart';
import '../../model/log_admin_model.dart';

class LogAdminTest extends StatefulWidget {
  const LogAdminTest({super.key});

  @override
  State<LogAdminTest> createState() => _LogAdminTestState();
}

class _LogAdminTestState extends State<LogAdminTest> {
  final controller = LogAdminController();

  List<LogAdmin> logs = [];

  @override
  void initState() {
    super.initState();
    ambilLog();
  }

  Future<void> ambilLog() async {
    print("Mulai ambil log");

    final data = await controller.lihatLog();

    print("Jumlah log: ${data.length}");

    setState(() {
      logs = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Log Admin")),

      body: ListView.builder(
        itemCount: logs.length,

        itemBuilder: (context, index) {
          final log = logs[index];

          return ListTile(
            title: Text(log.aktivitas),
            subtitle: Text(log.tanggalAktivitas.toString()),
          );
        },
      ),
    );
  }
}
