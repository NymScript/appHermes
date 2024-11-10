import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current theme's color scheme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return DropdownButtonFormField<String>(
      value: value,
      // Display hint text when no value is selected, adapting color to theme
      hint: Text(
        hint,
        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.grey),
      ),
      // Map each item in the list to a DropdownMenuItem widget
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          // Text color adapts to theme
          child: Text(
            item,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged, // Callback when item is selected
      decoration: InputDecoration(
        // Styling for the dropdown's border, with color adapting to theme
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white54 : Colors.grey,
          ),
        ),
        // Padding inside the dropdown
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        // Dropdown background color adapting to theme
        filled: true,
        fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
      ), // InputDecoration
      dropdownColor: isDarkMode
          ? Colors.grey[900]
          : Colors.white, // Dropdown menu background color
    ); // DropdownButtonFormField
  }
}
