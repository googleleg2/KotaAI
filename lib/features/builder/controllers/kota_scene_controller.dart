import 'package:flutter/material.dart';

import '../../../controllers/cart_controller.dart';
import '../../../models/ingredient.dart';
import '../models/stacked_ingredient.dart';

class KotaSceneController extends ChangeNotifier {
  KotaSceneController({
    required CartController cartController,
  }) : _cartController = cartController;

  final CartController _cartController;

  final List<StackedIngredient> _stack = [];

  List<StackedIngredient> get stack =>
      List.unmodifiable(_stack);

  bool get isEmpty => _stack.isEmpty;

  int get stackCount => _stack.length;

  void addIngredient(Ingredient ingredient) {
  double currentHeight = 90;

  for (final item in _stack) {
    currentHeight += item.ingredient.stackHeight;
  }

  _stack.add(
    StackedIngredient(
      ingredient: ingredient,
      yOffset: currentHeight,
      addedAt: DateTime.now(),
      rotation: 0,
      scale: 1,
    ),
  );

  _cartController.addIngredient(ingredient);

  notifyListeners();
}

  void removeTopIngredient() {
    if (_stack.isEmpty) return;

    final removed = _stack.removeLast();

    _cartController.decreaseIngredient(
      removed.ingredient,
    );

    notifyListeners();
  }

  void removeIngredient(StackedIngredient item) {
    _stack.remove(item);

    _cartController.decreaseIngredient(
      item.ingredient,
    );

    notifyListeners();
  }

  void clear() {
    for (final item in _stack) {
      _cartController.decreaseIngredient(
        item.ingredient,
      );
    }

    _stack.clear();

    notifyListeners();
  }
}