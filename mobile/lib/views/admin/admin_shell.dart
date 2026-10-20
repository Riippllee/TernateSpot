import 'package:flutter/material.dart';
import 'package:ternatespot/views/admin/katalog_destinasi.dart';
import 'package:ternatespot/views/admin/management_user_page.dart';
import 'package:ternatespot/views/admin/profile_admin_page.dart';
import 'package:ternatespot/views/admin/review_admin_page.dart';

import 'home_page.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  // Urutan halaman harus sama dengan urutan menu navigasi.
  late final List<Widget> _pages = [
    const HomePage(),
    const KatalogDestinasiPage(),
    const ManagementUserPage(),
    const ReviewPage(),
    const ProfileAdminPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF1D61E7),
        unselectedItemColor: const Color(0xFFA0AEC0),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: 'Destinasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_outlined),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Halaman sementara untuk fitur yang belum dibuat.
class _ComingSoonPage extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const _ComingSoonPage({
    required this.title,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A212A),
        elevation: 0.5,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: const Color(0xFF1D61E7)),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
