import 'display_builder.dart';
import 'models/cart_analysis.dart';
import 'models/customer_profile.dart';
import 'models/discount_display.dart';
import 'reward_progress_engine.dart';
import 'reward_threshold_engine.dart';
import 'revenue_engine.dart';
import 'revenue_score.dart';
import 'savings_engine.dart';

class DiscountEngine {
  const DiscountEngine();

  DiscountDisplay calculate({
    required RevenueScore revenueScore,
    required CustomerProfile customer,
    required CartAnalysis cart,
    bool quietDay = false,
    bool payday = false,
  }) {
    final offer =
        const RevenueEngine().calculateOffer(
      revenueScore,
    );

    final rewardTarget =
        const RewardThresholdEngine().calculate(
      averageOrder:
          customer.averageOrderValue,
      quietDay: quietDay,
      payday: payday,
    );

    final reward =
        const RewardProgressEngine().calculate(
      cartTotal: cart.total,
      rewardTarget: rewardTarget,
    );

    final savings =
        const SavingsEngine().calculate(
      subtotal: cart.total,
      offer: offer,
    );

    return const DisplayBuilder().build(
      offer: offer,
      reward: reward,
      savings: savings,
    );
  }
}