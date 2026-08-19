import 'ingredient.dart';

class CartItem {
  final Ingredient ingredient;
  int quantity;

  CartItem({
    required this.ingredient,
    this.quantity = 1,
  });

  double get subtotal =>
      ingredient.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      "ingredient": ingredient.toMap(),
      "quantity": quantity,
      "subtotal": subtotal,
    };
  }

  factory CartItem.fromMap(
    Map<String, dynamic> map,
  ) {
    return CartItem(
      ingredient: Ingredient.fromMap(
        Map<String, dynamic>.from(
          map["ingredient"],
        ),
      ),
      quantity: map["quantity"] ?? 1,
    );
  }

  CartItem copyWith({
    Ingredient? ingredient,
    int? quantity,
  }) {
    return CartItem(
      ingredient:
          ingredient ?? this.ingredient,
      quantity:
          quantity ?? this.quantity,
    );
  }
}