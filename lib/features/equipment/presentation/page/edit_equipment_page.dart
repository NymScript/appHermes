import 'package:flutter/material.dart';

class EditEquipmentModal extends StatelessWidget {
  final TextEditingController _colorController;
  final TextEditingController _serialController;
  final Function(String, String) onSave;

  EditEquipmentModal({
    super.key,
    required String initialColor,
    required String initialSerial,
    required this.onSave,
  })  : _colorController = TextEditingController(text: initialColor),
        _serialController = TextEditingController(text: initialSerial);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Editar registro",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39A900),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Color', _colorController),
            const SizedBox(height: 20),
            _buildTextField('Serial', _serialController),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  onSave(_colorController.text, _serialController.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF39A900),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Guardar registro",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF39A900),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'Ingresa el nuevo $label',
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          ),
        ),
      ],
    );
  }
}

void showEditEquipmentModal(
  BuildContext context, {
  required String initialColor,
  required String initialSerial,
  required Function(String, String) onSave,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditEquipmentModal(
        initialColor: initialColor,
        initialSerial: initialSerial,
        onSave: onSave,
      );
    },
  );
}
