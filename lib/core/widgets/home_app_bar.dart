import 'package:flutter/material.dart';

/// HomeAppBar displays the top bar with the logo and a subtitle text.
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the theme and determine if dark mode is enabled
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Set the primary color based on the theme mode
    Color color = isDarkMode ? Colors.grey[900]! : const Color(0xFF39A900);

    // Get the screen size for responsive design
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color, // Background color of the app bar
        borderRadius: BorderRadius.circular(5), // Rounded corners
      ),
      padding: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.02, // Vertical padding
        horizontal: screenSize.width * 0.05, // Horizontal padding
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo with height proportional to the screen size
          Image.asset(
            "images/logo.png",
            color: isDarkMode ? Colors.white70 : const Color(0xFFF5F4F4),
            height: screenSize.height * 0.07, // Adjust height to screen height
          ),
          SizedBox(
              width: screenSize.width * 0.02), // Space between logo and text

          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title text, scaled to the screen width
                Text(
                  "Hermes",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.08, // Responsive font size
                    fontWeight: FontWeight.w300,
                    color:
                        isDarkMode ? Colors.white70 : const Color(0xFFF5F4F4),
                    letterSpacing: 2.0, // Letter spacing
                    height: 1.0, // Line height
                  ),
                ),

                // Subtitle text, smaller and also responsive to the screen width
                Text(
                  "Transformando vidas, construyendo futuro.",
                  style: TextStyle(
                    fontSize:
                        screenSize.width * 0.02, // Smaller, responsive size
                    color:
                        isDarkMode ? Colors.white54 : const Color(0xFFF5F4F4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
