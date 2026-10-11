// Di dalam file lib/main.dart
import 'package:flutter/material.dart';
import 'views/review/review_page.dart'; // Import file review_page kamu

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReviewPage(), // Ubah bagian ini jadi ReviewPage()
    );
  }
}