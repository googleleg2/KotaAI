import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/ingredient.dart';

class CartController extends ChangeNotifier {
  static const double _baseKotaPrice = 15.0;

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  /// Base kota + toppings
  double get totalPrice {
    double total = _baseKotaPrice;

    for (final item in _items) {
      total += item.subtotal;
    }

    return total;
  }

  /// Number of toppings
  int get totalItems {
    int total = 0;

    for (final item in _items) {
      total += item.quantity;
    }

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  bool contains(Ingredient ingredient) {
    return _items.any(
      (item) => item.ingredient.id == ingredient.id,
    );
  }

  int quantityOf(Ingredient ingredient) {
    try {
      return _items
          .firstWhere(
            (item) => item.ingredient.id == ingredient.id,
          )
          .quantity;
    } catch (_) {
      return 0;
    }
  }

  /// Add one ingredient
  void addIngredient(Ingredient ingredient) {
    final index = _items.indexWhere(
      (item) => item.ingredient.id == ingredient.id,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(
        CartItem(
          ingredient: ingredient,
        ),
      );
    }

    notifyListeners();
  }

  /// Remove one ingredient
  void decreaseIngredient(Ingredient ingredient) {
    final index = _items.indexWhere(
      (item) => item.ingredient.id == ingredient.id,
    );

    if (index == -1) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  /// Remove ingredient completely
  void removeIngredient(Ingredient ingredient) {
    _items.removeWhere(
      (item) => item.ingredient.id == ingredient.id,
    );

    notifyListeners();
  }

  /// Used by KotaSceneController
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Backwards compatibility
  void clearCart() {
    clear();
  }
}