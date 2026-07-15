import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_colors.dart';
import '../../../controllers/cart_controller.dart';

class FloatingCheckout extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingCheckout({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.45),
                blurRadius: 25,
              )
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: cart.items.isEmpty ? null : onPressed,
            child: Row(
              children: [

                const SizedBox(width: 24),

                const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),

                const SizedBox(width: 15),

                const Text(
                  "Checkout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const Spacer(),

                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius:
                        BorderRadius.circular(25),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "R ${cart.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}