import 'package:flutter/material.dart';

import '../../../models/ingredient.dart';
import 'drag_ingredient.dart';

class IngredientTray extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientTray({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return DragIngredient(
            ingredient: ingredients[index],
          );
        },
        separatorBuilder: (_, __) =>
            const SizedBox(width: 18),
        itemCount: ingredients.length,
      ),
    );
  }
}