import '../models/business_state.dart';

class BusinessScore {

  const BusinessScore();

  double calculate(
    BusinessState state,
  ) {

    double score = 50;

    final salesProgress =
        state.salesToday /
        state.targetSales;

    if (salesProgress > .90) {

      score += 35;

    } else if (salesProgress > .70) {

      score += 20;

    } else if (salesProgress > .50) {

      score += 10;

    } else {

      score -= 20;

    }

    if (state.ordersToday <
        state.targetOrders) {

      score -= 10;

    }

    if (state.payday) {

      score += 15;

    }

    if (state.holiday) {

      score += 10;

    }

    return score.clamp(0, 100);
  }

}