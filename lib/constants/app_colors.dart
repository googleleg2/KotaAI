import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFFFF9800);
  static const Color primaryDark = Color(0xFFF57C00);
  static const Color accent = Color(0xFFFFC107);

  // Backgrounds
  static const Color background = Color(0xFF101010);
  static const Color surface = Color(0xFF181818);
  static const Color card = Color(0xFF222222);

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFBDBDBD);
  static const Color hint = Color(0xFF757575);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);

  // Extras
  static const Color divider = Color(0xFF303030);
  static const Color shadow = Colors.black54;

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      accent,
    ],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A1A1A),
      background,
    ],
  );
}