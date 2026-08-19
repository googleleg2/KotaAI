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
      return _desktop(context);
    }

    if (Responsive.isTablet(context)) {
      return _tablet(context);
    }

    return _mobile(context);
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _mobile(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          if (width <= 0 || height <= 0) {
            return const SizedBox.shrink();
          }

          /*
           * ========================================================
           * MOBILE LAYOUT
           * ========================================================
           *
           * Structure:
           *
           * DISCOUNT
           * PRICE
           * LARGE KOTA
           * INGREDIENTS
           * CHECKOUT
           *
           * The checkout section is protected first.
           *
           * The builder receives whatever vertical space remains.
           */

          // --------------------------------------------------------
          // CHECKOUT
          // --------------------------------------------------------

          /*
           * Checkout must ALWAYS have enough height for its
           * contents and bottom safe-area padding.
           *
           * We intentionally do not calculate this as a tiny
           * percentage of the viewport.
           */
          final checkoutHeight = (height * 0.09).clamp(
            58.0,
            76.0,
          );

          // --------------------------------------------------------
          // DISCOUNT
          // --------------------------------------------------------

          /*
           * The discount bar is deliberately much shorter on
           * mobile.
           *
           * The SmartDiscountBar itself is responsible for being
           * visually compact.
           */
          final discountHeight = (height * 0.055).clamp(
            40.0,
            52.0,
          );

          // --------------------------------------------------------
          // PRICE
          // --------------------------------------------------------

          final priceHeight = (height * 0.055).clamp(
            34.0,
            46.0,
          );

          // --------------------------------------------------------
          // INGREDIENT TRAY
          // --------------------------------------------------------

          /*
           * Enough room for the horizontal ingredient cards,
           * while keeping the Kota large.
           */
          final trayHeight = (height * 0.135).clamp(
            92.0,
            118.0,
          );

          // --------------------------------------------------------
          // GAPS
          // --------------------------------------------------------

          final gap = (height * 0.008).clamp(
            3.0,
            7.0,
          );

          /*
           * There are four gaps:
           *
           * discount -> price
           * price -> builder
           * builder -> tray
           * tray -> checkout
           */
          final fixedHeight =
              discountHeight +
              priceHeight +
              trayHeight +
              checkoutHeight +
              (gap * 4);

          /*
           * Whatever remains belongs to the Kota.
           *
           * Most importantly, checkout has already been reserved,
           * so the builder can NEVER push checkout outside the
           * viewport.
           */
          final builderHeight = (height - fixedHeight).clamp(
            150.0,
            height,
          );

          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // ==================================================
              // DISCOUNT
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: discountHeight,
                child: ClipRect(
                  child: discountBar,
                ),
              ),

              SizedBox(height: gap),

              // ==================================================
              // PRICE
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: priceHeight,
                child: Center(
                  child: price,
                ),
              ),

              SizedBox(height: gap),

              // ==================================================
              // LARGE KOTA
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: builderHeight,
                child: ClipRect(
                  child: builder,
                ),
              ),

              SizedBox(height: gap),

              // ==================================================
              // INGREDIENT TRAY
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: trayHeight,
                child: tray,
              ),

              SizedBox(height: gap),

              // ==================================================
              // CHECKOUT
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: checkoutHeight,
                child: checkout,
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // TABLET
  // ============================================================

  Widget _tablet(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ==================================================
          // DISCOUNT
          // ==================================================

          Flexible(
            flex: 1,
            child: discountBar,
          ),

          const SizedBox(height: 8),

          // ==================================================
          // MAIN WORKSPACE
          // ==================================================

          Expanded(
            flex: 8,
            child: Row(
              children: [
                // ------------------------------------------------
                // KOTA
                // ------------------------------------------------

                Expanded(
                  flex: 6,
                  child: Center(
                    child: builder,
                  ),
                ),

                // ------------------------------------------------
                // RIGHT PANEL
                // ------------------------------------------------

                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      price,

                      const SizedBox(height: 12),

                      Expanded(
                        child: tray,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // CHECKOUT
          // ==================================================

          checkout,
        ],
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _desktop(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ==================================================
          // DISCOUNT
          // ==================================================

          discountBar,

          const SizedBox(height: 12),

          // ==================================================
          // MAIN WORKSPACE
          // ==================================================

          Expanded(
            child: Row(
              children: [
                // ------------------------------------------------
                // KOTA
                // ------------------------------------------------

                Expanded(
                  flex: 7,
                  child: Center(
                    child: builder,
                  ),
                ),

                // ------------------------------------------------
                // RIGHT PANEL
                // ------------------------------------------------

                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      price,

                      const SizedBox(height: 20),

                      Expanded(
                        child: tray,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // CHECKOUT
          // ==================================================

          checkout,
        ],
      ),
    );
  }
}