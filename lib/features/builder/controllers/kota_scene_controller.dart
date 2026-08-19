import 'package:flutter/material.dart';

import '../../../controllers/cart_controller.dart';
import '../../../models/ingredient.dart';
import '../models/stacked_ingredient.dart';

class KotaSceneController extends ChangeNotifier {
  final CartController cartController;

  KotaSceneController({
    required this.cartController,
  });

  /// Ingredients currently stacked on the Kota.
  ///
  /// IMPORTANT:
  /// This controller stores WHAT has been added.
  ///
  /// It does NOT calculate screen coordinates.
  /// IngredientStack is responsible for deciding WHERE each
  /// ingredient is rendered based on the available canvas size.
  final List<StackedIngredient> _stack = [];

  List<StackedIngredient> get stack =>
      List.unmodifiable(_stack);

  /// Whether the Kota currently has ingredients.
  bool get isEmpty => _stack.isEmpty;

  /// Number of ingredients currently stacked.
  int get count => _stack.length;

  /// Adds an ingredient to the top of the current stack.
  ///
  /// No fixed y-position is stored here.
  /// The renderer calculates the correct position responsively.
  void addIngredient(Ingredient ingredient) {
    final stacked = StackedIngredient(
      ingredient: ingredient,

      // Animation only.
      //
      // The ingredient will visually animate upward into
      // its calculated stack position.
      animationOffset: 40,

      // Normal rendering scale.
      //
      // Actual image dimensions are calculated by
      // IngredientStack from the available Kota size.
      scale: 1.0,
    );

    _stack.add(stacked);

    // Keep the cart synchronized with the visual stack.
    cartController.addIngredient(ingredient);

    notifyListeners();
  }

  /// Removes the last ingredient added to the Kota.
  void removeLastIngredient() {
    if (_stack.isEmpty) {
      return;
    }

    final removed = _stack.removeLast();

    cartController.removeIngredient(
      removed.ingredient,
    );

    notifyListeners();
  }

  /// Removes every ingredient from the Kota.
  void clear() {
    _stack.clear();

    cartController.clear();

    notifyListeners();
  }
}