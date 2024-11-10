import 'package:flutter/material.dart';
import 'package:maqueta/features/carnet/presentation/page/carnet_page.dart';
import 'package:maqueta/features/equipment/presentation/page/equipments_page.dart';
import 'package:maqueta/features/profile/presentation/page/my_account_page.dart';
import 'package:maqueta/core/widgets/navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // Index to manage the active tab

  // Lazy initialization of pages list
  late final List<Widget> _pages = [
    const EquipmentPage(), // Index 0
    const CarnetPage(), // Index 1
    const MyAccountPage(), // Index 2
  ];

  // Method called when a tab is selected in the navigation bar
  void _onTabTapped(int index) {
    // Only update the state if the selected index is different
    if (_currentIndex != index) {
      setState(() {
        _currentIndex =
            index; // Change the current index to show the corresponding page
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps the state of pages when switching tabs
      body: IndexedStack(
        index: _currentIndex,
        children: _pages, // Show the page corresponding to the current index
      ),
      bottomNavigationBar: CustomNavigationBar(
        onTabTapped: _onTabTapped,
        selectedIndex:
            _currentIndex, // Pass the selectedIndex to the navigation bar
      ),
    );
  }
}
