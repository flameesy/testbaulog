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
          headline6: headlineTextStyle.copyWith(color: Colors.white),
        ).bodyText2, titleTextStyle: TextTheme(
          headline6: headlineTextStyle.copyWith(color: Colors.white),
        ).headline6,
      ),
      textTheme: const TextTheme(
        headline6: headlineTextStyle,
        bodyText2: bodyTextStyle,
      ),
      // Add more theme properties as needed
    );
  }
}
