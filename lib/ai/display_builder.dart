import 'models/ai_offer.dart';
import 'models/discount_display.dart';
import 'models/reward_progress.dart';
import 'models/savings.dart';

class DisplayBuilder {
  const DisplayBuilder();

  DiscountDisplay build({
    required AiOffer offer,
    required RewardProgress reward,
    required Savings savings,
  }) {
    return DiscountDisplay(
      title: offer.title,
      subtitle: offer.subtitle,
      progress: reward.progress,
      savings: savings.discount,
      percentage: savings.percentage,
      reward: offer.title,
      remaining: reward.remaining,
    );
  }
}