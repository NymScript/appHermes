import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/features/carnet/data/models/user.dart';
import 'package:maqueta/features/equipment/data/models/equipment.dart';
import 'package:maqueta/core/providers/token_storage.dart';
import 'package:maqueta/core/network/url_storage.dart';
import 'package:maqueta/features/equipment/data/datasources/equipment_service.dart';

class CardService {
  final TokenStorage _tokenStorage = TokenStorage();
  final EquipmentService _equipmentService = EquipmentService();
  final UrlStorage _urlStorage = UrlStorage();

  /// Fetches the user data and their associated equipment details
  Future<User?> getUser() async {
    try {
      // Fetch the token and decode it
      final token = await _tokenStorage.getToken();
      final decodeToken = await _tokenStorage.decodeJwtToken();
      final document = decodeToken['sub'];

      print('[DEBUG] Fetching user data from URL: $document');
      // Access the URL directly without calling getFullUrl again
      final String url = '${_urlStorage.urlCardPerson}/card/$document';
      final uri = Uri.parse(url);

      print('[DEBUG] Fetching user data from URL: $url');
      print('[DEBUG] Authorization Token: $token');
      print('[DEBUG] User document ID from token: $document');

      // Send GET request
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Log response details
      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      // Process the response
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('[DEBUG] JSON response: $jsonResponse');

        if (jsonResponse.isNotEmpty) {
          final userData = jsonResponse;
          List<int> equipmentIds =
              List<int>.from(userData['equipments']?.map((e) => e['id']) ?? []);

          print('[DEBUG] Equipment IDs extracted: $equipmentIds');

          // Fetch detailed equipment data based on IDs
          List<Equipment> equipmentList =
              await _equipmentService.fetchEquipments(equipmentIds);

          print('[DEBUG] Fetched equipment details: $equipmentList');

          return User(
            name: userData['name'] ?? 'N/A',
            lastName: userData['lastname'] ?? 'N/A',
            email: userData['email'] ?? 'N/A',
            phoneNumber: userData['phone'] ?? 'N/A',
            bloodType: userData['bloodType']?.trim() ?? 'N/A',
            documentNumber: userData['document'].toString(),
            photo: userData['photo'] != null
                ? base64Decode(userData['photo'])
                : null,
            acronym: userData['acronym'] ?? 'N/A',
            studySheet: userData['studySheet']?.toString() ?? 'N/A',
            program: userData['program'] ?? 'N/A',
            journey: userData['journey'] ?? 'N/A',
            trainingCenter: userData['trainingCenter'] ?? 'CSF',
            equipments: equipmentList,
          );
        } else {
          print('[ERROR] User data is empty in response.');
          throw Exception('User data not available');
        }
      } else {
        print(
            '[ERROR] Failed to fetch data with status code: ${response.statusCode}');
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('[EXCEPTION] Error getting user data: $e');
      throw Exception('Error getting user data: $e');
    }
  }
}
