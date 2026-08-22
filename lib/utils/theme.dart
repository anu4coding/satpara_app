import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Satpara Naturals brand palette - earthy green/beige to match a
/// natural, herbal, handmade-soap identity.
class AppColors {
  static const primary = Color(0xFF3E6B4F); // deep herbal green
  static const primaryLight = Color(0xFF6FA383);
  static const accent = Color(0xFFD98E3B); // turmeric/haldi orange-gold
  static const background = Color(0xFFFAF6EF); // soft beige
  static const surface = Colors.white;
  static const textDark = Color(0xFF2B2B2B);
  static const textMuted = Color(0xFF6F6F6F);
  static const error = Color(0xFFB3261E);
  static const success = Color(0xFF2E7D32);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
