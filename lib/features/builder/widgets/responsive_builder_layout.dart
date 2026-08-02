import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';

class ResponsiveBuilderLayout extends StatelessWidget {
  final Widget discountBar;
  final Widget price;
  final Widget builder;
  final Widget tray;
  final Widget checkout;

  const ResponsiveBuilderLayout({
    super.key,
    required this.discountBar,
    required this.price,
    required this.builder,
    required this.tray,
    required this.checkout,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return _desktop();

    } else if (Responsive.isTablet(context)) {
      return _tablet();

    } else {
      return _mobile();
    }
  }

  Widget _mobile() {
    return Column(
      children: [

        discountBar,

        const SizedBox(height: 12),

        price,

        const SizedBox(height: 12),

        Expanded(
          flex: 6,
          child: Center(
            child: builder,
          ),
        ),

        Expanded(
          flex: 2,
          child: tray,
        ),

        checkout,
      ],
    );
  }

  Widget _tablet() {
    return Column(
      children: [

        discountBar,

        const SizedBox(height: 12),

        price,

        Expanded(
          child: Row(
            children: [

              Expanded(
                flex: 5,
                child: Center(
                  child: builder,
                ),
              ),

              Expanded(
                flex: 3,
                child: tray,
              ),
            ],
          ),
        ),

        checkout,
      ],
    );
  }

  Widget _desktop() {
    return Column(
      children: [

        discountBar,

        const SizedBox(height: 20),

        Expanded(
          child: Row(
            children: [

              Expanded(
                flex: 7,
                child: Center(
                  child: builder,
                ),
              ),

              Expanded(
                flex: 4,
                child: Column(
                  children: [

                    price,

                    const SizedBox(height: 25),

                    Expanded(
                      child: tray,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        checkout,
      ],
    );
  }
}