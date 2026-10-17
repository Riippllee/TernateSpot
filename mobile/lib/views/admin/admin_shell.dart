
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'management_user_page.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    _AdminPlaceholderPage(
      title: 'Manajemen Destinasi',
      icon: Icons.explore_outlined,
    ),
    ManagementUserPage(),
    _AdminPlaceholderPage(
      title: 'Review & Rating',
      icon: Icons.rate_review_outlined,
    ),
    _AdminPlaceholderPage(
      title: 'Profil Administrator',
      icon: Icons.person_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
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

// Halaman sementara untuk menu yang belum dihubungkan.
class _AdminPlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _AdminPlaceholderPage({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF1D61E7)),
            const SizedBox(height: 12),
            Text('$title belum dihubungkan.'),
          ],
        ),
      ),
    );
  }
}
