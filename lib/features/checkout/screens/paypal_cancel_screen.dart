import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PayPalCancelScreen extends StatelessWidget {
  const PayPalCancelScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Cancelled",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.cancel_rounded,
                size: 90,
                color: Colors.red,
              ),

              const SizedBox(height: 30),

              const Text(
                "Payment Cancelled",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Your PayPal payment was cancelled.\n\n"
                "Your order has not been charged and is still waiting for payment.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(
                    Icons.payment,
                  ),
                  label: const Text(
                    "Try Payment Again",
                  ),
                  onPressed: () {
                    context.go("/checkout");
                  },
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.shopping_cart,
                  ),
                  label: const Text(
                    "Return to Cart",
                  ),
                  onPressed: () {
                    context.go("/cart");
                  },
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  context.go("/home");
                },
                child: const Text(
                  "Continue Shopping",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}