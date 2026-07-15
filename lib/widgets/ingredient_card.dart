import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../controllers/cart_controller.dart';
import '../models/ingredient.dart';

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientCard({
    super.key,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartController>();

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [

            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                ingredient.name[0],
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    ingredient.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    "R${ingredient.price}",
                    style: const TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            if (!cart.contains(ingredient))

              IconButton(
                onPressed: () {
                  cart.addIngredient(ingredient);
                },
                icon: const Icon(
                  Icons.add_circle,
                  color: AppColors.primary,
                ),
              )

            else

              Row(
                children: [

                  IconButton(
                    onPressed: () {
                      cart.decreaseIngredient(
                        ingredient,
                      );
                    },
                    icon: const Icon(
                      Icons.remove_circle,
                    ),
                  ),

                  Text(
                    cart
                        .quantityOf(ingredient)
                        .toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      cart.addIngredient(
                        ingredient,
                      );
                    },
                    icon: const Icon(
                      Icons.add_circle,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}