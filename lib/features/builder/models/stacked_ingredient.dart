import '../../../models/ingredient.dart';

class StackedIngredient {
  final Ingredient ingredient;

  /// Vertical position within the stack.
  final double yOffset;

  /// Slight rotation for a more natural look.
  final double rotation;

  /// Animation scale.
  final double scale;

  /// Time the ingredient was added.
  final DateTime addedAt;

  const StackedIngredient({
    required this.ingredient,
    required this.addedAt,
    this.yOffset = 0,
    this.rotation = 0,
    this.scale = 1.0,
  });

  StackedIngredient copyWith({
    Ingredient? ingredient,
    double? yOffset,
    double? rotation,
    double? scale,
    DateTime? addedAt,
  }) {
    return StackedIngredient(
      ingredient: ingredient ?? this.ingredient,
      yOffset: yOffset ?? this.yOffset,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}