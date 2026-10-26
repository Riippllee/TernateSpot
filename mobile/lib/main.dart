import 'package:flutter/material.dart';
import 'views/review/detail_destinasi_page.dart'; // Sesuaikan lokasi file kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DetailPage(), // Mengarah ke DetailPage
    );
  }
}