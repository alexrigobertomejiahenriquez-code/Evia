import 'package:flutter/material.dart';

/// Valores de color centralizados para EVIA.
/// Añade o ajusta los colores aquí para mantener coherencia en toda la app.
class AppColors {
  // Primary
  static const Color primary = Color(0xFF6750A4);
  static const Color primaryLight = Color(0xFF9A7FFF);
  static const Color primaryDark = Color(0xFF46306B);

  // Secondary
  static const Color secondary = Color(0xFF006B5A);
  static const Color secondaryLight = Color(0xFF47D6B3);
  static const Color secondaryDark = Color(0xFF00443A);

  // Tertiary
  static const Color tertiary = Color(0xFF806000);
  static const Color tertiaryLight = Color(0xFFBF8A33);
  static const Color tertiaryDark = Color(0xFF5A4100);

  // Error
  static const Color error = Color(0xFFB00020);

  // Greys
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);

  // Light theme tokens
  static const Color lightOutline = Color(0xFFDDDDDD);
  static const Color lightOutlineVariant = Color(0xFFEBE0F7);
  static const Color lightBackground = Color(0xFFF8F7FB);
  static const Color lightOnBackground = Color(0xFF1C1B1F);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1C1B1F);
  static const Color lightScrim = Color(0x66000000);

  // Dark theme tokens
  static const Color darkOutline = Color(0xFF3C3C3C);
  static const Color darkOutlineVariant = Color(0xFF2E2A33);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkOnBackground = Color(0xFFECECEC);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnSurface = Color(0xFFF2F2F2);
  static const Color darkScrim = Color(0x99FFFFFF);

  // Convenience aliases
  static const Color lightPrimaryContainer = primaryLight;
  static const Color darkPrimaryContainer = primaryDark;
}
