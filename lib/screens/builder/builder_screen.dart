import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ai/display_builder.dart';
import '../../ai/models/cart_analysis.dart';
import '../../ai/models/customer_profile.dart';
import '../../ai/models/discount_display.dart';
import '../../ai/models/reward_progress.dart';
import '../../ai/models/savings.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/menu_controller.dart';
import '../../controllers/revenue_controller.dart';

import '../../features/builder/background/animated_background.dart';
import '../../features/builder/controllers/kota_scene_controller.dart';
import '../../features/builder/widgets/builder_canvas.dart';
// import '../../features/builder/widgets/floating_checkout.dart';
import '../../features/builder/widgets/floating_checkout.dart';
import '../../features/builder/widgets/ingredient_tray.dart';

import '../../features/checkout/screens/checkout_screen.dart';
import '../../widgets/animated_price.dart';
import '../../widgets/smart_discount_bar.dart';

import '../../features/builder/widgets/responsive_builder_layout.dart';

class BuilderScreen extends StatelessWidget {
  const BuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartController>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => KotaSceneController(
            cartController: cart,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => RevenueController(),
        ),
      ],

      child: Consumer2<MenusController, RevenueController>(
        builder: (_, menu, revenue, __) {

          // Temporary AI initialization
          revenue.initialize(
            salesToday: 3200,
            targetSales: 8000,
            customer: const CustomerProfile(
              id: "guest",
              firstOrder: true,
              totalOrders: 0,
              lifetimeSpend: 0,
              averageOrderValue: 0,
              loyaltyPoints: 0,
              daysSinceLastOrder: 0,
              birthdayMonth: false,
            ),
            cart: CartAnalysis(
              total: cart.totalPrice,
              items: cart.totalItems,
              containsCombo: false,
              profitMargin: 60,
              amountToNextReward:
                  (90 - cart.totalPrice).clamp(0.0, 90.0),
            ),
          );

          final offer = revenue.offer;

          DiscountDisplay? display;

          if (offer != null) {
            final reward = RewardProgress(
              progress: (cart.totalPrice / 90).clamp(0.0, 1.0),
              remaining:
                  (90 - cart.totalPrice).clamp(0.0, 90.0),
              target: 90,
            );

            final savings = Savings(
              subtotal: cart.totalPrice,
              discount: cart.totalPrice *
                  (offer.discountPercent / 100),
              total: cart.totalPrice -
                  (cart.totalPrice *
                      (offer.discountPercent / 100)),
            );

            display = const DisplayBuilder().build(
              offer: offer,
              reward: reward,
              savings: savings,
            );
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: AnimatedBackground(
              child: SafeArea(
                child: ResponsiveBuilderLayout(
  discountBar: display != null
      ? SmartDiscountBar(
          display: display,
        )
      : const SizedBox(),

  price: const AnimatedPrice(),

  builder: const BuilderCanvas(),

  tray: IngredientTray(
    ingredients: menu.menu,
  ),

  checkout: FloatingCheckout(
     onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CheckoutScreen(),
      ),
    );
  },
  ),
),
              ),
            ),
          );
        },
      ),
    );
  }
}