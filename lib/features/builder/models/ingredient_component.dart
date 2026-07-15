import '../../../models/ingredient.dart';
import 'ingredient_render_data.dart';

class IngredientComponent {
  final Ingredient ingredient;

  final IngredientRenderData render;

  const IngredientComponent({
    required this.ingredient,
    required this.render,
  });
}