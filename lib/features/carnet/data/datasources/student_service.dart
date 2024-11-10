import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/features/carnet/data/models/student.dart';
import 'package:maqueta/core/providers/token_storage.dart';
import 'package:maqueta/core/network/url_storage.dart';

class StudentService {
  final String baseUrl = UrlStorage().getFullUrl(UrlStorage().urlStudent);
  final TokenStorage tokenStorage = TokenStorage();

  /// Sends an image in Base64 format to the backend.
  Future<void> sendImageBase64(String base64Image, int document) async {
    final url = Uri.parse('$baseUrl/updatePhoto/$document');
    var token = await tokenStorage.getToken();

    final body = jsonEncode({
      "data": {
        "photo": base64Image,
      }
    });

    try {
      print('[DEBUG] Sending Base64 image to URL: $url');
      print('[DEBUG] Authorization token: $token');
      print('[DEBUG] Request body: $body');

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Exception while uploading image: $e');
      throw Exception('Exception while uploading image: $e');
    }
  }

  /// Fetches user data using the JWT token.
  Future<Student> getUserData() async {
    try {
      var document = await tokenStorage.getDocumentFromToken();
      var token = await tokenStorage.getToken();

      final url = Uri.parse('$baseUrl/findDocument/$document');

      print('[DEBUG] Fetching user data from URL: $url');
      print('[DEBUG] Authorization token: $token');
      print('[DEBUG] Document ID from token: $document');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('[DEBUG] Parsed JSON response: $jsonResponse');

        final userData = jsonResponse['data']['person'];

        return Student(
          dateBirth: userData['date_birth'] ?? 'N/A',
          bloodType: userData['blood_type']?.trim() ?? 'N/A',
          address: userData['address'] ?? 'N/A',
        );
      } else {
        throw Exception(
            'Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Error fetching user data: $e');
      throw Exception('Error fetching user data: $e');
    }
  }

  /// Updates student information based on the given student object.
  Future<void> updateStudentData(Student student, int? document) async {
    final url = Uri.parse('$baseUrl/updateMovil/$document');
    var token = await tokenStorage.getToken();

    final payload = {
      'data': {
        "date_birth": student.dateBirth,
        "blood_type": student.bloodType,
        "address": student.address,
      },
    };

    try {
      print('[DEBUG] Updating student data at URL: $url');
      print('[DEBUG] Authorization token: $token');
      print('[DEBUG] Payload: $payload');

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Error updating student data: $e');
      throw Exception('Error updating student data: $e');
    }
  }
}
