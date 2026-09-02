import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografía centralizada para EVIA
/// Basada en Material 3 Design System
class AppTypography {
  static TextTheme buildTextTheme(Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final baseTextColor = isLight ? const Color(0xFF1C1B1F) : const Color(0xFFE6E1E6);

    return TextTheme(
      // Display - Títulos muy grandes
      displayLarge: GoogleFonts.roboto(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        height: 64 / 57,
        letterSpacing: -0.25,
        color: baseTextColor,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        height: 52 / 45,
        letterSpacing: 0,
        color: baseTextColor,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        height: 44 / 36,
        letterSpacing: 0,
        color: baseTextColor,
      ),

      // Headline - Títulos grandes
      headlineLarge: GoogleFonts.roboto(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        height: 40 / 32,
        letterSpacing: 0,
        color: baseTextColor,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 36 / 28,
        letterSpacing: 0,
        color: baseTextColor,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        height: 32 / 24,
        letterSpacing: 0,
        color: baseTextColor,
      ),

      // Title - Títulos medianos
      titleLarge: GoogleFonts.roboto(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 28 / 22,
        letterSpacing: 0,
        color: baseTextColor,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        letterSpacing: 0.15,
        color: baseTextColor,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 0.1,
        color: baseTextColor,
      ),

      // Body - Texto normal
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        letterSpacing: 0.15,
        color: baseTextColor,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: 0.25,
        color: baseTextColor,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        letterSpacing: 0.4,
        color: baseTextColor,
      ),

      // Label - Etiquetas y botones pequeños
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        letterSpacing: 0.1,
        color: baseTextColor,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        letterSpacing: 0.5,
        color: baseTextColor,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 16 / 11,
        letterSpacing: 0.5,
        color: baseTextColor,
      ),
    );
  }
}
