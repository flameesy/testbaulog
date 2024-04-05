import 'package:flutter/material.dart';

class BauLogTheme {
  // Define primary color
  static const Color primaryColor = Colors.orange;

  // Define accent color
  static const Color accentColor = Color.fromRGBO(189, 162, 91, 1);

  // Define text styles
  static const TextStyle headlineTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  // Define theme data
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        toolbarTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Set app bar text color
        ),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Set app bar title color
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: headlineTextStyle, // Change headline6 to headlineTextStyle
        bodyMedium: bodyTextStyle, // Change bodyText2 to bodyTextStyle
      ),
      // Add more theme properties as needed
    ).copyWith(
      hintColor: accentColor, // Set accent color
    );
  }
}
