import 'package:flutter/material.dart';

class BauLogTheme {
  // Define theme colors
  static const Color primaryColor = Colors.orange;
  static const Color secondaryColor = Colors.grey;

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
      hintColor: secondaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor, toolbarTextStyle: TextTheme(
          titleLarge: headlineTextStyle.copyWith(color: Colors.white),
        ).bodyMedium, titleTextStyle: TextTheme(
          titleLarge: headlineTextStyle.copyWith(color: Colors.white),
        ).titleLarge,
      ),
      textTheme: const TextTheme(
        titleLarge: headlineTextStyle,
        bodyMedium: bodyTextStyle,
      ),
      // Add more theme properties as needed
    );
  }
}
