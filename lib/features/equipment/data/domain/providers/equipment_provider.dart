import 'package:flutter/material.dart';
import 'package:maqueta/features/equipment/data/models/equipment.dart';
import 'package:maqueta/features/equipment/data/datasources/equipment_service.dart';

class EquipmentProvider with ChangeNotifier {
  final EquipmentService _equipmentService = EquipmentService();
  List<Equipment> _equipments = [];
  bool _isLoading = false;
  String? _error;

  List<Equipment> get equipments => _equipments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEquipments(List<int> equipmentIds) async {
    try {
      _equipments = await _equipmentService.fetchEquipments(equipmentIds);
      notifyListeners(); // Notifica a los widgets para que se actualicen
    } catch (e) {
      print('[ERROR] Error fetching equipments in provider: $e');
    }
  }

  /// Adds a new equipment and updates the state.
  Future<void> addEquipment(Equipment equipment) async {
    _setLoading(true);
    try {
      await _equipmentService.addEquipment(equipment);
      _equipments.add(equipment); // Adds the equipment to the local list
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add equipment: $e';
    }
    _setLoading(false);
  }

  /// Edits an existing equipment and updates the state.
  Future<void> editEquipment(Equipment equipment) async {
    _setLoading(true);
    try {
      await _equipmentService.editEquipment(equipment);
      final index = _equipments.indexWhere((e) => e.id == equipment.id);
      if (index != -1) {
        _equipments[index] = equipment; // Updates the local list
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to edit equipment: $e';
    }
    _setLoading(false);
  }

  /// Toggles the active/inactive state of an equipment and updates the state.
  Future<void> toggleEquipmentState(Equipment equipment) async {
    _setLoading(true);
    try {
      await _equipmentService.toggleEquipmentState(equipment);
      final index = _equipments.indexWhere((e) => e.id == equipment.id);
      if (index != -1) {
        _equipments[index].state = !_equipments[index].state;
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to toggle equipment state: $e';
    }
    _setLoading(false);
  }

  Future<void> updateEquipment(Equipment equipment) async {
    try {
      await _equipmentService.editEquipment(equipment);
      final index = _equipments.indexWhere((e) => e.id == equipment.id);
      if (index != -1) {
        _equipments[index] = equipment;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update equipment';
      notifyListeners();
    }
  }

  /// Sets the loading state and notifies listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
