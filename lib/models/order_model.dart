import 'ingredient.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<Ingredient> ingredients;
  final double totalPrice;
  final DateTime createdAt;
  final String status;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.ingredients,
    required this.totalPrice,
    required this.createdAt,
    this.status = "pending",
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      ingredients: (map['ingredients'] as List)
          .map((e) => Ingredient.fromMap(e))
          .toList(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'ingredients': ingredients.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}