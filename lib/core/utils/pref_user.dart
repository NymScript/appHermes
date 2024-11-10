import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefs;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Getter and setter for lastPage preference
  String get lastPage {
    return _prefs.getString('lastPage') ?? '/'; // Default to login route
  }

  set lastPage(String value) {
    _prefs.setString('lastPage', value);
  }

  // Getter and setter for isDarkMode preference
  bool get isDarkMode {
    return _prefs.getBool('isDarkMode') ?? false;
  }

  set isDarkMode(bool value) {
    _prefs.setBool('isDarkMode', value);
  }
}
