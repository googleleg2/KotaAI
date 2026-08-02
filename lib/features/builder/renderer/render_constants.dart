import 'package:flutter/material.dart';

class RenderConstants {
  const RenderConstants._();

  static const double designWidth = 430;

  static const double designHeight = 520;

  static const double centerX = designWidth / 2;

  static double scale(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1600) {
      return 1.45;
    }

    if (screenWidth >= 1200) {
      return 1.25;
    }

    if (screenWidth >= 900) {
      return 1.05;
    }

    return 0.85;
  }
}