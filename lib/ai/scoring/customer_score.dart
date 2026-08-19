import '../models/customer_profile.dart';

class CustomerScore {
  const CustomerScore();

  double calculate(
    CustomerProfile customer,
  ) {
    double score = 50;

    if (customer.firstOrder) {
      score -= 20;
    }

    if (customer.daysSinceLastOrder > 30) {
      score -= 25;
    }

    if (customer.daysSinceLastOrder > 14 &&
        customer.daysSinceLastOrder <= 30) {
      score -= 15;
    }

    if (customer.totalOrders > 25) {
      score += 15;
    }

    if (customer.lifetimeSpend > 5000) {
      score += 20;
    }

    return score.clamp(0, 100);
  }
}