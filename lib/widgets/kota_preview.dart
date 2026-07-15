import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../controllers/cart_controller.dart';

class KotaPreview extends StatelessWidget {
  const KotaPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();

    return Container(
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          const Icon(
            Icons.lunch_dining,
            size: 90,
            color: AppColors.primary,
          ),

          const SizedBox(height: 20),

          const Text(
            "Your Kota",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.ingredient.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        "x${item.quantity}",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}