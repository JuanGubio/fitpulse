import 'package:flutter/material.dart';

class AppColors {
  // Primary: oklch(0.62 0.26 160) - Vibrant teal-green
  static const Color primary = Color(0xFF00BFA5); // Approximate hex

  // Secondary: oklch(0.65 0.22 260) - Rich purple-blue
  static const Color secondary = Color(0xFF6B46C1); // Approximate

  // Accent: oklch(0.72 0.24 35) - Warm coral-orange
  static const Color accent = Color(0xFFFF6B35); // Approximate

  // Background
  static const Color background = Color(0xFFFCFCFC);

  // Foreground
  static const Color foreground = Color(0xFF1A1A1A);

  // Muted
  static const Color muted = Color(0xFFF5F5F5);

  // Muted foreground
  static const Color mutedForeground = Color(0xFF737373);

  // Card
  static const Color card = Color(0xFFFFFFFF);

  // Border
  static const Color border = Color(0xFFE5E5E5);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Nunito', // Will use Google Fonts
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900),
        headlineMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w800),
        headlineSmall: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontFamily: 'Nunito'),
        bodyMedium: TextStyle(fontFamily: 'Nunito'),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.muted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.primary.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}