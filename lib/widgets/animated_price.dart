import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';

class AnimatedPrice extends StatelessWidget {
  const AnimatedPrice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();

    return TweenAnimationBuilder<double>(
      duration: const Duration(
        milliseconds: 300,
      ),
      tween: Tween(
        begin: 0,
        end: cart.totalPrice,
      ),
      builder: (_, value, __) {
        return Column(
          children: [

            const Text(
              "YOUR KOTA",
              style: TextStyle(
                color: Colors.white54,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "R ${value.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}