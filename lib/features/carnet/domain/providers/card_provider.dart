import 'package:flutter/material.dart';
import 'package:maqueta/features/carnet/data/models/user.dart';
import 'package:maqueta/features/carnet/data/datasources/card_service.dart';
import 'package:maqueta/features/equipment/data/models/equipment.dart';

class UserProvider with ChangeNotifier {
  final CardService _cardService = CardService();
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetches user data and updates state.
  Future<void> fetchUserData() async {
    _setLoading(true);
    try {
      _user = await _cardService.getUser();
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch user data: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Updates equipment list locally after an edit or state toggle.
  void updateEquipment(Equipment updatedEquipment) {
    final equipmentIndex =
        _user?.equipments.indexWhere((eq) => eq.id == updatedEquipment.id);
    if (equipmentIndex != null && equipmentIndex != -1) {
      _user?.equipments[equipmentIndex] = updatedEquipment;
      notifyListeners(); // Notify listeners of the update.
    } else {
      print("Error: Equipment with ID ${updatedEquipment.id} not found.");
    }
  }

  /// Helper to set loading state and notify listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
