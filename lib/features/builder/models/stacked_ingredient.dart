import '../../../models/ingredient.dart';

class StackedIngredient {
  final Ingredient ingredient;

  double animationOffset;

  double scale;

  StackedIngredient({
    required this.ingredient,
    this.animationOffset = 40,
    this.scale = 1.0,
  });
}