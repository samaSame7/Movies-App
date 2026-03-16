import 'package:flutter/material.dart';
import '../../../../core/app_assets/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../browse/ui/tabs/browse_tab.dart';
import '../../../home/ui/tabs/home_tab.dart';
import '../../../profile/ui/tabs/profile_tab.dart';
import '../../../search/ui/tabs/search_tab.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const SearchTab(),
    const BrowseTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) => setState(() => _selectedIndex = index),
          items: [
            buildBottomNavigationBarItem(label: 'Home', icon: AppAssets.icHome),
            buildBottomNavigationBarItem(
              label: 'Search',
              icon: AppAssets.icSearch,
            ),
            buildBottomNavigationBarItem(
              label: 'Browse',
              icon: AppAssets.icBrowse,
            ),
            buildBottomNavigationBarItem(
              label: 'Profile',
              icon: AppAssets.icProfile,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem buildBottomNavigationBarItem({
    required String icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Image.asset(icon, color: AppColors.textLight),
      activeIcon: Image.asset(icon, color: AppColors.primary),
      label: label,
    );
  }
}
