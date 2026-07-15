import '../../../models/ingredient.dart';

class StackedIngredient {
  final Ingredient ingredient;

  final double yOffset;

  double animationOffset;

  double scale;

  StackedIngredient({
    required this.ingredient,
    required this.yOffset,
    this.animationOffset = 40,
    this.scale = 1.15,
  });
}