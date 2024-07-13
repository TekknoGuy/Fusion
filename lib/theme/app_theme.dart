import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimaryColor = Color(0xFF3A86FF);
  static const Color lightBackgroundColor = Color(0xFFF3F4F6);
  static const Color lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color lightErrorColor = Color(0xFFD32F2F);
  static const Color lightOnPrimaryColor = Color(0xFFFFFFFF);
  static const Color lightOnBackgroundColor = Color(0xFF000000);
  static const Color lightOnSurfaceColor = Color(0xFF000000);
  static const Color lightOnErrorColor = Color(0xFFFFFFFF);

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF3A86FF);
  static const Color darkBackgroundColor = Color(0xFF1A1A1A);
  static const Color darkSurfaceColor = Color(0xFF252525);
  static const Color darkErrorColor = Color(0xFFCF6679);
  static const Color darkOnPrimaryColor = Color(0xFFFFFFFF);
  static const Color darkOnBackgroundColor = Color(0xFFFFFFFF);
  static const Color darkOnSurfaceColor = Color(0xFFFFFFFF);
  static const Color darkOnErrorColor = Color(0xFF000000);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: lightPrimaryColor,
      onPrimary: lightOnPrimaryColor,
      secondary: lightPrimaryColor, // You can define a separate secondary color if needed
      onSecondary: lightOnPrimaryColor,
      error: lightErrorColor,
      onError: lightOnErrorColor,
      surface: lightSurfaceColor,
      onSurface: lightOnSurfaceColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimaryColor,
      foregroundColor: lightOnPrimaryColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: lightPrimaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimaryColor,
        foregroundColor: lightOnPrimaryColor,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: lightPrimaryColor),
      bodyLarge: TextStyle(color: Colors.black87),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: darkPrimaryColor,
      onPrimary: darkOnPrimaryColor,
      secondary: darkPrimaryColor, // You can define a separate secondary color if needed
      onSecondary: darkOnPrimaryColor,
      error: darkErrorColor,
      onError: darkOnErrorColor,
      surface: darkSurfaceColor,
      onSurface: darkOnSurfaceColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimaryColor,
      foregroundColor: darkOnPrimaryColor,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: darkPrimaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
        foregroundColor: darkOnPrimaryColor,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: darkPrimaryColor),
      bodyLarge: TextStyle(color: Colors.white70),
    ),
  );

  static bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}