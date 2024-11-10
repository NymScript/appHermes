import 'dart:convert';
import 'dart:typed_data';
import 'package:maqueta/features/equipment/data/models/equipment.dart';

class User {
  final String name;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String bloodType;
  final String documentNumber;
  final String acronym;
  final String studySheet;
  final String program;
  final String journey;
  final String trainingCenter;
  final Uint8List? photo;
  final List<Equipment> equipments;

  User({
    required this.name,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.bloodType,
    required this.documentNumber,
    required this.acronym,
    required this.studySheet,
    required this.program,
    required this.journey,
    required this.trainingCenter,
    required this.equipments,
    this.photo,
  });

  /// Factory method to create a User instance from JSON data.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'N/A',
      lastName: json['lastname'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      phoneNumber: json['phone'] ?? 'N/A',
      bloodType: json['bloodType']?.trim() ?? 'N/A',
      documentNumber: json['document'].toString(),
      photo: json['photo'] != null ? base64Decode(json['photo']) : null,
      acronym: json['acronym'] ?? 'N/A',
      studySheet: json['studySheet']?.toString() ?? 'N/A',
      program: json['program'] ?? 'N/A',
      journey: json['journey'] ?? 'N/A',
      trainingCenter: json['trainingCenter'] ?? 'CSF',
      equipments: (json['equipments'] as List<dynamic>?)
              ?.map((e) => Equipment.fromJson(e))
              .toList() ??
          [],
    );
  }

  /// Method to convert a User instance to a JSON-compatible Map.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastname': lastName,
      'email': email,
      'phone': phoneNumber,
      'bloodType': bloodType,
      'document': documentNumber,
      'photo': photo != null ? base64Encode(photo!) : null,
      'acronym': acronym,
      'studySheet': studySheet,
      'program': program,
      'journey': journey,
      'trainingCenter': trainingCenter,
      'equipments': equipments.map((e) => e.toJson()).toList(),
    };
  }
}
