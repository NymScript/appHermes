import 'package:flutter/foundation.dart';

class UrlStorage {
  // Change the port based on the environment
  final String baseUrl = kReleaseMode
      ? 'https://api.yourapp.com/' // Production URL
      : 'https://kgsrt5lf-8081.use2.devtunnels.ms/'; // Development URL

  // Route paths
  final String urlLoginPath = 'api/v1/hermesapp/auth/login';
  final String urlCardPersonPath = 'api/v1/hermesapp/view';
  final String urlEquipmentPath = 'api/v1/hermesapp/equipment';
  final String urlStudentPath = 'api/v1/hermesapp/student';

  // Method to get the full URL
  String getFullUrl(String path) {
    return '$baseUrl$path';
  }

  // Convenience getters for each full URL path
  String get urlLogin => getFullUrl(urlLoginPath);
  String get urlCardPerson => getFullUrl(urlCardPersonPath);
  String get urlEquipment => getFullUrl(urlEquipmentPath);
  String get urlStudent => getFullUrl(urlStudentPath);
}
