import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../controllers/cart_controller.dart';
import '../controllers/checkout_controller.dart';
import '../controllers/order_controller.dart';
import '../models/customer_order.dart';
import '../services/order_service.dart';
import '../../../services/paypal_service.dart';
import 'order_confirmation_screen.dart';

class PayPalSuccessScreen extends StatefulWidget {
  const PayPalSuccessScreen({
    super.key,
  });

  @override
  State<PayPalSuccessScreen> createState() =>
      _PayPalSuccessScreenState();
}

class _PayPalSuccessScreenState
    extends State<PayPalSuccessScreen> {
  bool loading = true;

  String message = "Finalizing your payment...";

  bool _finished = false;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    finishCheckout();
  }

  // ============================================================
  // COMPLETE CHECKOUT
  // ============================================================

  Future<void> finishCheckout() async {
    // Prevent the callback from being processed twice
    // by accidental rebuilds/navigation.
    if (_finished) return;

    _finished = true;

    try {
      final user = _auth.currentUser;

      if (user == null) {
        _showError(
          "You are no longer signed in. "
          "Please sign in again.",
        );
        return;
      }

      final uri = Uri.base;

      final orderNumber =
          uri.queryParameters["order"];

      final paypalOrderId =
          uri.queryParameters["token"];

      if (orderNumber == null ||
          orderNumber.isEmpty) {
        _showError(
          "Missing order number.",
        );
        return;
      }

      if (paypalOrderId == null ||
          paypalOrderId.isEmpty) {
        _showError(
          "Missing PayPal Order ID.",
        );
        return;
      }

      final orderService =
          const OrderService();

      // ========================================================
      // LOAD ORIGINAL ORDER
      // ========================================================

      final CustomerOrder? originalOrder =
          await orderService.getOrder(
        orderNumber,
      );

      if (originalOrder == null) {
        _showError(
          "Order not found.",
        );
        return;
      }

      // ========================================================
      // CAPTURE PAYPAL PAYMENT
      // ========================================================

      if (mounted) {
        setState(() {
          message =
              "Confirming your PayPal payment...";
        });
      }

      final result =
          await const PayPalService().captureOrder(
        orderNumber: orderNumber,
        paypalOrderId: paypalOrderId,
      );

      if (result["success"] != true) {
        _showError(
          result["error"]?.toString() ??
              "Unable to capture payment.",
        );
        return;
      }

      // ========================================================
      // INCREMENT CUSTOMER TOTAL ORDERS
      //
      // IMPORTANT:
      //
      // We use a Firestore transaction and a flag on the
      // order document so refreshing the PayPal success URL
      // cannot increment totalOrders more than once.
      // ========================================================

      if (mounted) {
        setState(() {
          message =
              "Updating your customer profile...";
        });
      }

      await _incrementCustomerTotalOrders(
        orderNumber: orderNumber,
        userId: user.uid,
      );

      // ========================================================
      // LOAD FINAL ORDER
      // ========================================================

      if (mounted) {
        setState(() {
          message =
              "Preparing your receipt...";
        });
      }

      final updatedOrder =
          await orderService.getOrder(
        orderNumber,
      );

      if (updatedOrder == null) {
        _showError(
          "Unable to load updated order.",
        );
        return;
      }

      if (!mounted) return;

      // ========================================================
      // CLEAR LOCAL CHECKOUT STATE
      // ========================================================

      context
          .read<CartController>()
          .clear();

      context
          .read<CheckoutController>()
          .clear();

      context
          .read<OrderController>()
          .clear();

      // ========================================================
      // SHOW ORDER CONFIRMATION
      // ========================================================

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              OrderConfirmationScreen(
            order: updatedOrder,
          ),
        ),
      );
    } catch (e) {
      _finished = false;

      if (!mounted) return;

      setState(() {
        loading = false;
        message = e.toString();
      });
    }
  }

  // ============================================================
  // INCREMENT TOTAL ORDERS
  // ============================================================

  Future<void> _incrementCustomerTotalOrders({
    required String orderNumber,
    required String userId,
  }) async {
    final orderRef = _firestore
        .collection('orders')
        .doc(orderNumber);

    final userRef = _firestore
        .collection('users')
        .doc(userId);

    await _firestore.runTransaction(
      (transaction) async {
        final orderSnapshot =
            await transaction.get(orderRef);

        if (!orderSnapshot.exists) {
          throw Exception(
            "Order does not exist.",
          );
        }

        final orderData =
            orderSnapshot.data();

        if (orderData == null) {
          throw Exception(
            "Order data is missing.",
          );
        }

        // ======================================================
        // SECURITY CHECK
        // ======================================================

        final orderUserId =
            orderData['userId']?.toString() ?? '';

        if (orderUserId.isNotEmpty &&
            orderUserId != userId) {
          throw Exception(
            "This order does not belong to the "
            "signed-in customer.",
          );
        }

        // ======================================================
        // PREVENT DOUBLE COUNTING
        // ======================================================

        final alreadyCounted =
            orderData[
                    'customerProfileOrderCounted'] ==
                true;

        if (alreadyCounted) {
          return;
        }

        // ======================================================
        // READ CUSTOMER PROFILE
        // ======================================================

        final userSnapshot =
            await transaction.get(userRef);

        if (userSnapshot.exists) {
          final userData =
              userSnapshot.data();

          final currentTotal =
              _toInt(
            userData?['totalOrders'],
          );

          transaction.update(
            userRef,
            {
              'totalOrders':
                  currentTotal + 1,
            },
          );
        } else {
          // Profile doesn't exist yet.
          transaction.set(
            userRef,
            {
              'id': userId,
              'totalOrders': 1,
              'firstOrder': true,
              'lifetimeSpend': 0.0,
              'averageOrderValue': 0.0,
              'loyaltyPoints': 0,
              'daysSinceLastOrder': 0,
            },
            SetOptions(
              merge: true,
            ),
          );
        }

        // ======================================================
        // MARK THIS ORDER AS COUNTED
        // ======================================================

        transaction.update(
          orderRef,
          {
            'customerProfileOrderCounted': true,
          },
        );
      },
    );
  }

  // ============================================================
  // INTEGER HELPER
  // ============================================================

  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  // ============================================================
  // ERROR
  // ============================================================

  void _showError(String error) {
    if (!mounted) return;

    setState(() {
      loading = false;
      message = error;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Processing Payment",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: loading
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),

                  const SizedBox(height: 24),

                  Text(
                    message,
                    textAlign:
                        TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              )
            : Padding(
                padding:
                    const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 70,
                    ),

                    const SizedBox(height: 20),

                    Text(
                      message,
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 30),

                    FilledButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      child: const Text(
                        "Return Home",
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}