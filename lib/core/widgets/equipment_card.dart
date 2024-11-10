import 'package:flutter/material.dart';

class EquipmentCard extends StatelessWidget {
  final String type;
  final String brand;
  final String model;
  final String color;
  final String serialNumber;
  final bool isActive; // Equipment state: active/inactive
  final VoidCallback onEdit;
  final VoidCallback onDeactivate;

  const EquipmentCard({
    super.key,
    required this.type,
    required this.brand,
    required this.model,
    required this.color,
    required this.serialNumber,
    required this.isActive,
    required this.onEdit,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    // Access theme to support light/dark mode
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Define background color based on active state and theme
    final cardColor = isActive
        ? (isDarkMode ? Colors.grey[800] : const Color(0xFFF5F5F5))
        : (isDarkMode ? Colors.grey[700] : Colors.grey.shade300);

    // Text styles for modularity
    final titleTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white70 : Colors.black,
    );

    final subtitleTextStyle = TextStyle(
      fontSize: 14,
      color: isDarkMode ? Colors.white54 : Colors.black87,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Type, Brand, and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.laptop,
                      size: 30,
                      color: isDarkMode ? Colors.white70 : Colors.black54),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(type, style: titleTextStyle),
                      Text(brand, style: subtitleTextStyle),
                    ],
                  ),
                ],
              ),
              // Action Dropdown (Edit / Activate-Deactivate)
              DropdownButton<String>(
                value: null,
                icon: Icon(Icons.keyboard_arrow_down,
                    color: isDarkMode ? Colors.white70 : Colors.black54),
                hint: Text(
                  isActive ? "Active" : "Inactive",
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                underline: const SizedBox(), // Removes underline
                items: [
                  DropdownMenuItem<String>(
                    value: "Edit",
                    child: Row(
                      children: [
                        const Icon(Icons.edit, color: Color(0xFF888787)),
                        const SizedBox(width: 10),
                        Text("Edit", style: subtitleTextStyle),
                      ],
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: isActive ? "Deactivate" : "Activate",
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.remove_circle : Icons.check_circle,
                          color: isActive ? Colors.red : Colors.green,
                        ),
                        const SizedBox(width: 10),
                        Text(isActive ? "Deactivate" : "Activate",
                            style: subtitleTextStyle),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == "Edit") {
                    onEdit();
                  } else {
                    onDeactivate(); // Activate or deactivate equipment
                  }
                },
                dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
          const Divider(thickness: 1.5, color: Colors.grey),

          // Model and Color Row
          Row(
            children: [
              Icon(Icons.label,
                  size: 20,
                  color: isDarkMode ? Colors.white70 : Colors.black54),
              const SizedBox(width: 5),
              Text(model, style: subtitleTextStyle),
              const SizedBox(width: 15),
              Icon(Icons.color_lens,
                  size: 20,
                  color: isDarkMode ? Colors.white70 : Colors.black54),
              const SizedBox(width: 5),
              Text(color, style: subtitleTextStyle),
            ],
          ),
          const SizedBox(height: 10),

          // Serial Number Row
          Row(
            children: [
              Icon(Icons.qr_code,
                  size: 20,
                  color: isDarkMode ? Colors.white70 : Colors.black54),
              const SizedBox(width: 5),
              Text(serialNumber, style: subtitleTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
