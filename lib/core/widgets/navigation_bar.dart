import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:maqueta/provider/app_router.dart';

/// CustomNavigationBar provides navigation between screens using AppRouter routes.
class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required void Function(int index) onTabTapped,
  });

  // Navigates to the selected route using AppRouter
  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRouter.equipment);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRouter.carnet);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRouter.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      height: 70,
      color: const Color(0xFF39A900),
      buttonBackgroundColor: const Color(0xFF007D78),
      items: const [
        Icon(Icons.computer, size: 30, color: Colors.white),
        Icon(Icons.qr_code, size: 30, color: Colors.white),
        Icon(Icons.people_alt_outlined, size: 30, color: Colors.white),
      ],
      index: selectedIndex,
      onTap: (index) => _onTabTapped(context, index), // Use AppRouter onTap
    );
  }
}
