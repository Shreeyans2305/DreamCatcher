import 'package:flutter/material.dart';

/// App theme designed specifically for accessibility and low digital literacy.
/// Features large tap targets (minimum 48dp, recommended 56dp for buttons),
/// high contrast ratios, and clear iconography.
class AppTheme {
  AppTheme._();

  // Primary palette: trustworthy deep blue with warm golden saffron accents
  static const Color primaryBlue = Color(0xFF0D47A1);
  static const Color primaryContainer = Color(0xFFE3F2FD);
  static const Color secondaryAmber = Color(0xFFE65100);
  static const Color secondaryContainer = Color(0xFFFFE0B2);
  static const Color accentGreen = Color(0xFF2E7D32);
  static const Color surfaceBackground = Color(0xFFF8F9FA);
  static const Color cardSurface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF616161);
  static const Color errorRed = Color(0xFFC62828);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: secondaryAmber,
        surface: surfaceBackground,
        error: errorRed,
      ),
      scaffoldBackgroundColor: surfaceBackground,
      fontFamily: 'Roboto',

      // Elevated button: Large 56dp height tap target for rural mobile usability
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          foregroundColor: primaryBlue,
          side: const BorderSide(color: primaryBlue, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Card theme with clear outline and elevated border
      cardTheme: CardThemeData(
        color: cardSurface,
        elevation: 1.5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
      ),

      // Input decoration with prominent touch targets and distinct borders
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryBlue, width: 2.2),
        ),
        labelStyle: const TextStyle(fontSize: 16, color: textSecondary),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
