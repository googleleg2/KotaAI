import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/cart_controller.dart';
import '../../../core/responsive/responsive.dart';

class FloatingCheckout extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingCheckout({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();

    final bool desktop = Responsive.isDesktop(context);
    final bool tablet = Responsive.isTablet(context);
    final bool mobile = Responsive.isMobile(context);

    /*
     * ============================================================
     * RESPONSIVE SIZING
     * ============================================================
     */

    final double horizontalPadding = desktop
        ? 20.0
        : tablet
            ? 16.0
            : 10.0;

    final double verticalPadding = desktop
        ? 12.0
        : tablet
            ? 10.0
            : 6.0;

    final double height = desktop
        ? 68.0
        : tablet
            ? 64.0
            : 58.0;

    final double iconSize = desktop
        ? 24.0
        : tablet
            ? 22.0
            : 20.0;

    final double titleSize = desktop
        ? 18.0
        : tablet
            ? 17.0
            : 15.0;

    final double priceFontSize = desktop
        ? 15.0
        : tablet
            ? 14.0
            : 13.0;

    final double sidePadding = desktop
        ? 24.0
        : tablet
            ? 20.0
            : 14.0;

    /*
     * On mobile we allow almost the entire viewport width.
     *
     * This is important because the previous implementation had:
     *
     *     Padding(all: 20)
     *
     * which effectively removed 40px from the available width.
     *
     * On small phones that can make the button unnecessarily narrow.
     */

    final double maxWidth = desktop
        ? 650.0
        : tablet
            ? 600.0
            : double.infinity;

    return SafeArea(
      top: false,
      bottom: true,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: SizedBox(
              width: double.infinity,
              height: height,
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 250,
                ),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: cart.items.isEmpty
                      ? AppColors.primary.withOpacity(.55)
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(
                    height / 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(
                        cart.items.isEmpty ? .15 : .40,
                      ),
                      blurRadius: desktop ? 25 : 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      height / 2,
                    ),
                    onTap: cart.items.isEmpty
                        ? null
                        : onPressed,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: sidePadding,
                        right: 8,
                      ),
                      child: Row(
                        children: [
                          // ==================================================
                          // SHOPPING ICON
                          // ==================================================

                          Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.white,
                            size: iconSize,
                          ),

                          SizedBox(
                            width: mobile
                                ? 9
                                : 15,
                          ),

                          // ==================================================
                          // CHECKOUT TEXT
                          // ==================================================

                          Expanded(
                            child: Text(
                              'Checkout',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: titleSize,
                              ),
                            ),
                          ),

                          // ==================================================
                          // TOTAL
                          // ==================================================

                          Container(
                            constraints: BoxConstraints(
                              /*
                               * Prevent the price container from
                               * becoming too wide on small phones.
                               */
                              maxWidth: mobile
                                  ? 125.0
                                  : 170.0,
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 7,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: mobile
                                  ? 12
                                  : 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius:
                                  BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'R ${cart.totalPrice.toStringAsFixed(2)}',
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: priceFontSize,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}