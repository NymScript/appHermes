import 'package:flutter/material.dart';
import 'package:maqueta/features/equipment/data/domain/providers/equipment_provider.dart';
import 'package:provider/provider.dart';
import 'package:maqueta/features/equipment/data/models/equipment.dart';
import 'package:maqueta/core/widgets/home_app_bar.dart';

class AddEquipmentPage extends StatefulWidget {
  static const routeName = 'addEquipment';

  const AddEquipmentPage({super.key});

  @override
  State<AddEquipmentPage> createState() => _AddEquipmentPageState();
}

enum FieldType { model, serialNumber, color }

class _AddEquipmentPageState extends State<AddEquipmentPage> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _equipmentTypes = ['Tablet', 'Laptop'];
  String? _selectedType;
  final List<String> _brands = [
    'Apple',
    'Dell',
    'HP',
    'Asus',
    'Acer',
    'Lenovo'
  ];
  String? _selectedBrand;

  final _modelController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final equipmentProvider = Provider.of<EquipmentProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Stack(
                children: [
                  const HomeAppBar(),
                  Positioned(
                    top: 30,
                    left: 5,
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please fill in the following information.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      _buildDropdown(
                          'Equipment Type', _equipmentTypes, _selectedType,
                          (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      }),
                      const SizedBox(height: 20),
                      _buildDropdown('Brand', _brands, _selectedBrand, (value) {
                        setState(() {
                          _selectedBrand = value;
                        });
                      }),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Model',
                        'Enter the model',
                        _modelController,
                        'Model is required.',
                        FieldType.model,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Serial Number',
                        'Enter the serial number',
                        _serialNumberController,
                        'Serial number is required.',
                        FieldType.serialNumber,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        'Color',
                        'Enter the color',
                        _colorController,
                        'Color is required.',
                        FieldType.color,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: equipmentProvider.isLoading
                                ? null
                                : _saveEquipment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF39A900),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: equipmentProvider.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Register',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF39A900)),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
          hint: Text('Select $label'),
          value: selectedValue,
          onChanged: onChanged,
          validator: (value) => value == null ? 'Please select $label.' : null,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      TextEditingController controller,
      String validationMessage,
      FieldType fieldType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF39A900)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return validationMessage;

            switch (fieldType) {
              case FieldType.model:
                if (value.length < 2 ||
                    !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                  return "Model must be at least 2 characters and contain only letters or numbers.";
                }
                break;
              case FieldType.serialNumber:
                if (value.length < 5 ||
                    !RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                  return "Serial number must be at least 5 characters and contain only letters or numbers.";
                }
                break;
              case FieldType.color:
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return "Color can only contain letters.";
                }
                break;
            }
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _saveEquipment() async {
    if (_formKey.currentState?.validate() ?? false) {
      final equipmentProvider =
          Provider.of<EquipmentProvider>(context, listen: false);

      final newEquipment = Equipment(
        brand: _selectedBrand!,
        model: _modelController.text,
        color: _colorController.text,
        serial: _serialNumberController.text,
        state: true,
      );

      try {
        await equipmentProvider.addEquipment(newEquipment);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Equipment registered successfully.')),
          );
        }
        Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register equipment: $e')),
          );
        }
      }
    }
  }
}
