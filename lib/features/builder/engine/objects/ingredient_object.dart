import 'package:kota_ai/models/ingredient.dart';

// import '../../../models/ingredient.dart';

class IngredientObject {
  final Ingredient ingredient;

  double x;
  double y;

  double rotation;

  double scale;

  bool landed;

  IngredientObject({
    required this.ingredient,
    required this.x,
    required this.y,
    this.rotation = 0,
    this.scale = 1,
    this.landed = false,
  });
}