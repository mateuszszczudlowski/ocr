import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B9AC4),
      primary: const Color(0xFF6B9AC4),
      secondary: const Color(0xFF97C1D9),
      surface: const Color(0xFFF8F9FA),
      error: const Color(0xFFE76F51),
      tertiary: const Color(0xFF000000),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF8F9FA),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Color(0xFF6B9AC4)),
      titleTextStyle: TextStyle(
        color: Color(0xFF2D3436),
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6B9AC4),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(60),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFF2F2F7),
      // Add this line for the shadow color
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF97C1D9),
      labelStyle: const TextStyle(color: Color(0xFF2D3436)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B9AC4),
      brightness: Brightness.dark,
      primary: const Color(0xFF6B9AC4),
      secondary: const Color(0xFF97C1D9),
      surface: const Color(0xFF2D3436),
      error: const Color(0xFFE76F51),
      tertiary: const Color(0xFFFFFFFF),
    ),
    scaffoldBackgroundColor: const Color(0xFF1B1B1D),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B1B1D),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF6B9AC4)),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6B9AC4),
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(60),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF1C1B1F),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF171718),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2D3436),
      labelStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
