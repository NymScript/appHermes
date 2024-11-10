import 'package:flutter/material.dart';
import 'package:maqueta/features/auth/presentation/page/login_page.dart';
import 'package:maqueta/features/carnet/presentation/page/carnet_page.dart';
import 'package:maqueta/features/equipment/presentation/page/equipments_page.dart';
import 'package:maqueta/features/profile/presentation/page/profile_page.dart';
import 'package:maqueta/features/home/presentation/page/home_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String equipment = '/equipment';
  static const String carnet = '/carnet';
  static const String profile = '/profile';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case equipment:
        return MaterialPageRoute(builder: (_) => const EquipmentPage());
      case carnet:
        return MaterialPageRoute(builder: (_) => const CarnetPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
