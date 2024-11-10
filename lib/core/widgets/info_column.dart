import 'package:flutter/material.dart';

/// InfoColumnWidget displays a label-value pair in a vertical layout.
/// Useful for showing key information in a clear, compact format.
class InfoColumnWidget extends StatelessWidget {
  final String label;
  final String value;

  const InfoColumnWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label text with bold styling and theme-aware color
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF39A900), // Primary color for the label
          ),
        ),

        // Value text adapts color based on theme
        Text(
          value,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }
}
