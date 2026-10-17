
import 'package:flutter/material.dart';

enum AdminTab {
  dashboard,
  destinations,
  users,
  reviews,
  profile,
}

class AdminBottomNav extends StatelessWidget {
  final AdminTab currentTab;
  final ValueChanged<AdminTab> onTabSelected;

  const AdminBottomNav({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentTab.index,
      onTap: (index) {
        onTabSelected(AdminTab.values[index]);
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
    );
  }
}
