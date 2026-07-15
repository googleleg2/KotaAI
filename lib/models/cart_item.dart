import 'ingredient.dart';

class CartItem {
  final Ingredient ingredient;
  int quantity;

  CartItem({
    required this.ingredient,
    this.quantity = 1,
  });

  double get subtotal => ingredient.price * quantity;
}