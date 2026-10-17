import 'package:flutter/material.dart';
import 'package:ternatespot/views/admin/admin_shell.dart';
import 'package:ternatespot/views/admin/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TernateSpot Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const AdminShell(),
    );
  }
}