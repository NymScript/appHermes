import 'package:flutter/material.dart';
import 'package:maqueta/features/carnet/data/models/student.dart';
import 'package:maqueta/features/carnet/data/datasources/student_service.dart';
import 'package:maqueta/core/providers/token_storage.dart';

class StudentProvider with ChangeNotifier {
  final StudentService _studentService = StudentService();
  final TokenStorage _tokenStorage = TokenStorage();
  Student? _student;
  bool _isLoading = false;
  String? _error;

  Student? get student => _student;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetches user data and updates state.
  Future<void> fetchStudentData() async {
    _setLoading(true);
    try {
      _student = await _studentService.getUserData();
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch student data: $e';
    }
    _setLoading(false);
  }

  /// Updates student data and notifies listeners.
  Future<void> updateStudent(Student student) async {
    _setLoading(true);
    try {
      final document = await _tokenStorage
          .getDocumentFromToken(); // Retrieve document from token
      await _studentService.updateStudentData(student, document);
      _student = student;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update student data: $e';
    }
    _setLoading(false);
  }

  /// Helper to set loading state and notify listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
