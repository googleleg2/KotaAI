class InventoryItem {

  final String ingredientId;

  final int stock;

  final int minimumStock;

  final double profitMargin;

  const InventoryItem({

    required this.ingredientId,

    required this.stock,

    required this.minimumStock,

    required this.profitMargin,
  });

  bool get lowStock =>
      stock <= minimumStock;

}