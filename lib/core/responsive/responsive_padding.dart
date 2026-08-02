import 'package:flutter/material.dart';

import 'responsive.dart';

class ResponsivePadding {
  const ResponsivePadding._();

  static EdgeInsets screen(
    BuildContext context,
  ) {
    final scale = Responsive.scale(context);

    return EdgeInsets.symmetric(
      horizontal: 20 * scale,
      vertical: 16 * scale,
    );
  }
}