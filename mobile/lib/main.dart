import 'package:flutter/material.dart';
import 'views/review/edit_destinasi_page.dart'; // Jalur import disesuaikan ke folder views/review

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TernateSpot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
      ),
      home: const EditDestinasiPage(),
    );
  }
}