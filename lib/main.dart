import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kota_ai/controllers/revenue_controller.dart';
import 'package:provider/provider.dart';

import 'config/app_router.dart';
import 'config/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/menu_controller.dart';
import 'controllers/notification_controller.dart';
import 'features/checkout/controllers/order_controller.dart';
import 'features/checkout/controllers/checkout_controller.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const KotaAI());
}

class KotaAI extends StatelessWidget {
  const KotaAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ------------------------------------------------------------
        // AUTH
        // ------------------------------------------------------------
        ChangeNotifierProvider(
          create: (_) => AuthController(),
        ),

        // ------------------------------------------------------------
        // CART
        // ------------------------------------------------------------
        ChangeNotifierProvider(
          create: (_) => CartController(),
        ),

        // ------------------------------------------------------------
        // MENU
        // ------------------------------------------------------------
        ChangeNotifierProvider(
          create: (_) => MenusController()..loadMenu(),
        ),

        // ------------------------------------------------------------
        // NOTIFICATIONS
        // ------------------------------------------------------------
        ChangeNotifierProvider(
          create: (_) => NotificationController(),
        ),

        // ------------------------------------------------------------
        // ORDERS
        // ------------------------------------------------------------
        ChangeNotifierProvider(
          create: (_) => OrderController(),
        ),

        // ------------------------------------------------------------
        // CHECKOUT
        // ------------------------------------------------------------
        ChangeNotifierProvider(
          create: (_) => CheckoutController(),
        ),

        // ------------------------------------------------------------
        // AI / REVENUE ENGINE
        // ------------------------------------------------------------
        ChangeNotifierProvider(
          create: (_) => RevenueController(),
        ),
      ],

      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Kota AI',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}