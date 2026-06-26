import 'package:flutter/material.dart';

class SenaColors {
  static const verde = Color(0xFF39A900);
  static const verdeOscuro = Color(0xFF2A7A00);
  static const verdeClaro = Color(0xFFE8F5E0);
  static const grisOscuro = Color(0xFF333333);
  static const grisTexto = Color(0xFF555555);
  static const fondo = Color(0xFFF5F5F5);
}

ThemeData senaTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: SenaColors.verde,
    primary: SenaColors.verde,
    onPrimary: Colors.white,
    secondary: SenaColors.verdeOscuro,
    surface: Colors.white,
    background: SenaColors.fondo,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,

    textTheme: const TextTheme(
      displaySmall: TextStyle(
        fontWeight: FontWeight.bold,
        color: SenaColors.grisOscuro,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: SenaColors.grisOscuro,
      ),
      bodyLarge: TextStyle(color: SenaColors.grisTexto),
      bodyMedium: TextStyle(color: SenaColors.grisTexto),
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: SenaColors.verde,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    scaffoldBackgroundColor: SenaColors.fondo,

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SenaColors.verde, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      labelStyle: const TextStyle(color: SenaColors.grisTexto),
      prefixIconColor: SenaColors.verde,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    // Botones rellenos
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: SenaColors.verde,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),
  );
}