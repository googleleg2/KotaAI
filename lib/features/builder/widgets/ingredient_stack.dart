import 'package:flutter/material.dart';

import '../models/stacked_ingredient.dart';

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

            return Positioned(
  bottom: item.yOffset,
  child: TweenAnimationBuilder<double>(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeOutBack,
    tween: Tween(
      begin: item.animationOffset,
      end: 0,
    ),
    builder: (context, value, child) {
      return Transform.translate(
        offset: Offset(0, -value),
        child: Transform.scale(
          scale: item.scale,
          child: child,
        ),
      );
    },
    onEnd: () {
      item.animationOffset = 0;
      item.scale = 1;
    },
    child: Image.asset(
      item.ingredient.imagePath,
      width: item.ingredient.width,
      fit: BoxFit.contain,
    ),
  ),
);
          },
        ),
      ),
    );
  }
}