import 'dart:convert';
import 'dart:io';
import 'package:maqueta/features/carnet/data/models/student.dart';
import 'package:maqueta/features/carnet/data/datasources/student_service.dart';

class ProfileUpdateService {
  final StudentService _studentService;

  ProfileUpdateService(this._studentService);

  /// Checks if there are changes in the user data fields compared to the initial state.
  bool hasChanges({
    required File? currentImage,
    required File? initialImage,
    required String? currentBloodType,
    required String? initialBloodType,
    required String currentDateBirth,
    required String initialDateBirth,
    required String currentAddress,
    required String initialAddress,
  }) {
    return currentImage != initialImage ||
        currentBloodType != initialBloodType ||
        currentDateBirth != initialDateBirth ||
        currentAddress != initialAddress;
  }

  /// Updates the profile data, uploading the image if changed,
  /// and then updating the other fields if necessary.
  Future<void> updateProfile({
    required File? image,
    required File? initialImage,
    required String bloodType,
    required String dateBirth,
    required String address,
    required int document,
  }) async {
    try {
      // Check and upload image if it has changed.
      if (image != null && image != initialImage) {
        final base64Image = await _convertImageToBase64(image);
        await _studentService.sendImageBase64(base64Image, document);
      }

      // Update other fields if there are changes.
      final updatedData = Student(
        dateBirth: dateBirth,
        bloodType: bloodType,
        address: address,
      );
      await _studentService.updateStudentData(updatedData, document);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  /// Converts the image file to a Base64 string for backend compatibility.
  Future<String> _convertImageToBase64(File image) async {
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }
}
