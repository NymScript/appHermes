import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/core/network/url_storage.dart';

class AuthService {
  final UrlStorage _urlStorage = UrlStorage();

  /// Envía credenciales y devuelve el token JWT
  Future<String> logIn(int document, String password) async {
    final String loginUrl = _urlStorage.urlLogin;

    print('Attempting to log in at: $loginUrl');

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'document': document, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final token = jsonResponse['jwt'];
          return token;
        } else {
          throw Exception('Login failed: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Error logging in: $e');
      throw Exception('Error during login process.');
    }
  }
}
