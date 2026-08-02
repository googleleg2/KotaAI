import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/cart_controller.dart';
import '../core/responsive/responsive.dart';

class AnimatedPrice extends StatelessWidget {
  const AnimatedPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();

    final scale = Responsive.scale(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(end: cart.totalPrice),
      builder: (_, value, __) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24 * scale,
            vertical: 14 * scale,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.08),
            borderRadius:
                BorderRadius.circular(30 * scale),
          ),
          child: Column(
            children: [

              Text(
                "Current Total",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14 * scale,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "R ${value.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 34 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}