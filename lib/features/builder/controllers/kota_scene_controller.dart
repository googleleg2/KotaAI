import 'package:flutter/material.dart';

import '../../../controllers/cart_controller.dart';
import '../../../models/ingredient.dart';
import '../models/stacked_ingredient.dart';

class KotaSceneController extends ChangeNotifier {
  final CartController cartController;

  KotaSceneController({
    required this.cartController,
  });

  /// Ingredients currently stacked on the Kota
  final List<StackedIngredient> _stack = [];

  List<StackedIngredient> get stack => List.unmodifiable(_stack);

  /// Current total height of the stack
  double get stackHeight {
    double height = 55;

    for (final item in _stack) {
      height += item.ingredient.stackHeight;
    }

    return height;
  }

  /// Add ingredient onto the Kota
  void addIngredient(Ingredient ingredient) {
    double yPosition = 55;

    for (final item in _stack) {
      yPosition += item.ingredient.stackHeight;
    }

    final stacked = StackedIngredient(
      ingredient: ingredient,
      yOffset: yPosition,
      animationOffset: 40,
      scale: 1.15,
    );

    _stack.add(stacked);

    cartController.addIngredient(ingredient);

    notifyListeners();
  }

  /// Remove the last ingredient
  void removeLastIngredient() {
    if (_stack.isEmpty) return;

    final removed = _stack.removeLast();

    cartController.removeIngredient(removed.ingredient);

    notifyListeners();
  }

  /// Remove all ingredients
  void clear() {
    _stack.clear();

    cartController.clear();

    notifyListeners();
  }

  /// Returns true if the Kota has no toppings
  bool get isEmpty => _stack.isEmpty;

  /// Number of stacked ingredients
  int get count => _stack.length;
}