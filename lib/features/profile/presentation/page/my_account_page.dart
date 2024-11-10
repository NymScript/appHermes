import 'package:flutter/material.dart';
import 'package:maqueta/features/profile/presentation/page/profile_page.dart';
import 'package:maqueta/features/carnet/data/datasources/card_service.dart';
import 'package:maqueta/features/carnet/data/models/user.dart';
import 'package:maqueta/core/widgets/home_app_bar.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool isDarkMode = false; // Dark mode toggle state
  final CardService _peopleService = CardService(); // Instance of CardService
  User? user; // Holds the fetched user data

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data on initialization
  }

  // Fetches user data from CardService
  Future<void> _fetchUserData() async {
    try {
      User? fetchedUser = await _peopleService.getUser();
      setState(() {
        user = fetchedUser; // Update state with the fetched user data
      });
    } catch (e) {
      print('Error fetching user data: $e'); // Log any errors encountered
      // Optionally, show an error message in the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              const HomeAppBar(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.person, color: Color(0xFF000102)),
                      title: const Text(
                        "My Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000102),
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.dark_mode, color: Color(0xFF000102)),
                      title: const Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF000102),
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          setState(() {
                            isDarkMode = value;
                          });
                          // TODO: Implement dark mode logic (if required)
                        },
                        inactiveThumbColor:
                            const Color.fromARGB(255, 93, 171, 65),
                        inactiveTrackColor: const Color(0xFFB6E5A8),
                        activeColor: const Color.fromARGB(167, 0, 49, 77),
                        activeTrackColor:
                            const Color.fromARGB(255, 198, 197, 249),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 255, 51, 0),
                      ),
                      title: const Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 51, 0),
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 30),
                      onTap: () {
                        // TODO: Implement logout logic
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
