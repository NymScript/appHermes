import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();
  static const String _authTokenKey = 'authToken';

  Future<void> saveToken(String token) async {
    print('[DEBUG] Saving token to storage: $token');
    await _storage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: _authTokenKey);
    print('[DEBUG] Retrieved token from storage: $token');
    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _authTokenKey);
    print('[DEBUG] Token deleted from storage');
  }

  Future<Map<String, dynamic>> decodeJwtToken() async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('No token found in storage');
      }
      final decodedToken = JwtDecoder.decode(token);
      print('[DEBUG] Decoded token payload: $decodedToken');
      return decodedToken;
    } catch (e) {
      print('[ERROR] Error decoding token: $e');
      return {};
    }
  }

  Future<int?> getDocumentFromToken() async {
    try {
      final decodedToken = await decodeJwtToken();
      if (decodedToken.containsKey('sub')) {
        return int.tryParse(decodedToken['sub']);
      } else {
        throw Exception('Document ID not found in token payload');
      }
    } catch (e) {
      print('[ERROR] Error retrieving document from token: $e');
      return null;
    }
  }
}
