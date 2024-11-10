import 'package:flutter/material.dart';
import 'package:maqueta/provider/app_router.dart';
import 'package:provider/provider.dart';
import 'package:maqueta/core/utils/pref_user.dart';
import 'package:maqueta/features/auth/domain/providers/auth_provider.dart';
import 'package:maqueta/features/carnet/domain/providers/card_provider.dart';
import 'package:maqueta/features/equipment/data/domain/providers/equipment_provider.dart';
import 'package:maqueta/features/carnet/domain/providers/student_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = UserPreferences();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => EquipmentProvider()),
        ChangeNotifierProvider(
            create: (_) =>
                UserProvider()), // Adjust this based on your provider structure
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        initialRoute: prefs.lastPage,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
