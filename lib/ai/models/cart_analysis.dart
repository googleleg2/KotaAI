class CartAnalysis {
  final double total;

  final int items;

  final bool containsCombo;

  final double profitMargin;

  final double amountToNextReward;

  const CartAnalysis({
    required this.total,
    required this.items,
    required this.containsCombo,
    required this.profitMargin,
    required this.amountToNextReward,
  });
}