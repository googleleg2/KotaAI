import '../models/cart_analysis.dart';

class CartScore {
  const CartScore();

  double calculate(
    CartAnalysis cart,
  ) {
    double score = 50;

    if (cart.total > 150) {
      score += 20;
    }

    if (cart.containsCombo) {
      score += 10;
    }

    if (cart.profitMargin > 60) {
      score += 15;
    }

    if (cart.amountToNextReward < 20) {
      score -= 15;
    }

    return score.clamp(0, 100);
  }
}