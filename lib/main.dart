import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_router.dart';
import 'config/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/menu_controller.dart';
import 'controllers/notification_controller.dart';
import 'features/checkout/controllers/order_controller.dart';
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
        ChangeNotifierProvider(
          create: (_) => AuthController(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartController(),
        ),
        ChangeNotifierProvider(
          create: (_) => MenusController()..loadMenu(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationController(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderController(),
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

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const KotaAITestApp());
// }

// class KotaAITestApp extends StatelessWidget {
//   const KotaAITestApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'PayPal Test',
//       theme: ThemeData.dark(),
//       home: const CheckoutPage(),
//     );
//   }
// }

// class CheckoutPage extends StatefulWidget {
//   const CheckoutPage({super.key});

//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }

// class _CheckoutPageState extends State<CheckoutPage> {
//   bool loading = false;
//   String result = "Ready";

//   Future<void> createPaypalOrder() async {
//     setState(() {
//       loading = true;
//       result = "Creating PayPal Order...";
//     });

//     try {
//       final response = await http.post(
//         Uri.parse(
//           "http://127.0.0.1:5001/kota-discount/us-central1/createPaypalOrder",
//         ),
//         headers: {
//           "Content-Type": "application/json",
//         },
//       );

//       final data = jsonDecode(response.body);

//       setState(() {
//         result = const JsonEncoder.withIndent("  ").convert(data);
//       });

//       debugPrint(data.toString());
//     } catch (e) {
//       setState(() {
//         result = e.toString();
//       });
//     }

//     setState(() {
//       loading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("PayPal Test"),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: loading ? null : createPaypalOrder,
//                 child: Text(
//                   loading
//                       ? "Creating Order..."
//                       : "Checkout with PayPal",
//                 ),
//               ),
//               const SizedBox(height: 30),
//               SelectableText(result),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }