import 'package:flutter/material.dart';

import 'breakpoints.dart';

class Responsive {
  const Responsive._();

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <
        Breakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    return width >= Breakpoints.mobile &&
        width < Breakpoints.desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >=
        Breakpoints.desktop;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double scale(
    BuildContext context,
  ) {
    final width = Responsive.width(context);

    if (width >= Breakpoints.largeDesktop) {
      return 1.35;
    }

    if (width >= Breakpoints.desktop) {
      return 1.15;
    }

    if (width >= Breakpoints.tablet) {
      return 1.0;
    }

    return .85;
  }
}