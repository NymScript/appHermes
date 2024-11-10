import 'package:flutter/material.dart';
import 'package:maqueta/core/providers/token_storage.dart';
import 'package:maqueta/features/auth/data/datasources/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenStorage _tokenStorage = TokenStorage();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _token;
  String? get token => _token;

  Future<void> logIn(int document, String password) async {
    try {
      // Envía las credenciales y recibe el token desde el backend
      String token = await _authService.logIn(document, password);

      // Guarda el token completo en el almacenamiento seguro
      print('[DEBUG] Storing token: $token');
      await _tokenStorage.saveToken(token);

      _token = token;
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      print('[ERROR] Login failed: $e');
      _isAuthenticated = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> logOut() async {
    await _tokenStorage.deleteToken();
    _token = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthenticationStatus() async {
    _token = await _tokenStorage.getToken();
    _isAuthenticated = _token != null;
    notifyListeners();
  }
}
