import 'package:flutter/material.dart';

import 'responsive.dart';

class ResponsiveSpacing {
  const ResponsiveSpacing._();

  static double xs(BuildContext context) =>
      4 * Responsive.scale(context);

  static double sm(BuildContext context) =>
      8 * Responsive.scale(context);

  static double md(BuildContext context) =>
      16 * Responsive.scale(context);

  static double lg(BuildContext context) =>
      24 * Responsive.scale(context);

  static double xl(BuildContext context) =>
      36 * Responsive.scale(context);

  static double xxl(BuildContext context) =>
      56 * Responsive.scale(context);
}