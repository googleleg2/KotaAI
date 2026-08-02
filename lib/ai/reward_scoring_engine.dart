import '/models/reward.dart';
import 'models/reward_priority.dart';
import 'revenue_score.dart';

class RewardScoringEngine {
  const RewardScoringEngine();

  RewardPriority score({
    required Reward reward,
    required RevenueScore revenue,
  }) {
    double score = 0;

    // Business is busy
    if (revenue.total >= 80) {
      score -= reward.value * 2;
    }

    // Business needs customers
    else if (revenue.total <= 40) {
      score += reward.value;
    }

    // Medium demand
    else {
      score += reward.value * .5;
    }

    return RewardPriority(
      rewardId: reward.id,
      score: score,
    );
  }
}