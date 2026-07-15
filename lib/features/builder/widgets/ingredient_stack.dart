import 'package:flutter/material.dart';

import '../models/stacked_ingredient.dart';

// import '../../../models/stacked_ingredient.dart';

class IngredientStack extends StatelessWidget {
  final List<StackedIngredient> ingredients;

  const IngredientStack({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: List.generate(
          ingredients.length,
          (index) {
            final item = ingredients[index];

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutBack,
              bottom: item.yOffset,
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 250),
                turns: item.rotation,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 250),
                  scale: item.scale,
                  child: Hero(
                    tag:
                        "ingredient_${item.addedAt.microsecondsSinceEpoch}",
                    child: Image.asset(
                      item.ingredient.imagePath,
                      width: item.ingredient.width,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}