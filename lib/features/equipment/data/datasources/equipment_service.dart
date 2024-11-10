import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/features/equipment/data/models/equipment.dart';
import 'package:maqueta/core/providers/token_storage.dart';
import 'package:maqueta/core/network/url_storage.dart';

class EquipmentService {
  final String baseUrl = UrlStorage().urlStudent;
  final TokenStorage tokenStorage = TokenStorage();

  Future<void> addEquipment(Equipment equipment) async {
    try {
      var token = await tokenStorage.getToken();
      var decodeToken = await tokenStorage.decodeJwtToken();
      var document = decodeToken['sub'];
      final url = Uri.parse('$baseUrl/add');

      print('[DEBUG] Adding equipment for document ID: $document');
      print('[DEBUG] Equipment add URL: $url');
      print('[DEBUG] Authorization token: $token');

      equipment.setDocumentId = document;

      final Map<String, dynamic> payload = {
        'data': equipment.toJson(),
      };

      print('[DEBUG] Payload: $payload');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(payload),
      );

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('[SUCCESS] Equipment registered successfully');
      } else {
        print('[ERROR] Server error response: ${response.body}');
        throw Exception('Failed to register equipment: ${response.statusCode}');
      }
    } catch (e) {
      print('[EXCEPTION] Exception registering equipment: $e');
      rethrow;
    }
  }

  Future<List<Equipment>> fetchEquipments(List<int> equipmentIds) async {
    try {
      var token = await tokenStorage.getToken();
      final baseUrl = UrlStorage().urlEquipment;

      print('[DEBUG] Token obtenido para equipos: $token');
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      print('[DEBUG] Fetching equipments by IDs: $equipmentIds');
      print('[DEBUG] Base URL para equipos: $baseUrl');

      // Realizamos la llamada HTTP para cada ID de equipo en paralelo
      var responses = await Future.wait(equipmentIds.map((id) {
        final urlWithId = Uri.parse('$baseUrl/by-id/$id');
        print('[DEBUG] Request URL: $urlWithId');
        return http.get(urlWithId, headers: headers);
      }));

      print('[DEBUG] Responses recibidas para la lista de equipos.');

      // Procesamos cada respuesta que tuvo éxito
      return responses
          .where((response) => response.statusCode == 200)
          .map((response) {
        var jsonResponse = json.decode(response.body);
        print('[DEBUG] Equipment JSON response: $jsonResponse');
        return Equipment.fromJson(jsonResponse['data']);
      }).toList();
    } catch (e) {
      print('[ERROR] Error fetching equipments: $e');
      return [];
    }
  }

  Future<void> editEquipment(Equipment equipment) async {
    try {
      var token = await tokenStorage.getToken();
      final url = Uri.parse('$baseUrl/update/${equipment.document}');

      var decodeToken = await tokenStorage.decodeJwtToken();
      var document = decodeToken['sub'];
      equipment.setDocumentId = document;

      final Map<String, dynamic> payload = {
        'data': equipment.toJson(),
      };

      print('[DEBUG] Editing equipment for document ID: $document');
      print('[DEBUG] Equipment edit URL: $url');
      print('[DEBUG] Payload: $payload');

      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(payload),
      );

      print('[DEBUG] Response status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update equipment');
      }
    } catch (e) {
      print('[ERROR] Exception editing equipment: $e');
      throw Exception('Exception editing equipment: $e');
    }
  }

  Future<void> toggleEquipmentState(Equipment equipment) async {
    print('[DEBUG] Toggling state for equipment ID: ${equipment.id}');
    equipment.state = equipment.state == true ? false : true;

    try {
      await editEquipment(equipment);
      print('[SUCCESS] Equipment state toggled and updated on server.');
    } catch (e) {
      print('[ERROR] Error toggling equipment state: $e');
      throw Exception('Error toggling equipment state: $e');
    }
  }
}
