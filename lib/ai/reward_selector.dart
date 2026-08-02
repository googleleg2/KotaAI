import '/models/reward.dart';
import 'reward_catalog.dart';
import 'reward_scoring_engine.dart';
import 'revenue_score.dart';

class RewardSelector {
  const RewardSelector();

  Reward select(
    RevenueScore revenue,
  ) {
    final rewards =
        const RewardCatalog().rewards;

    Reward best = rewards.first;
    double highest = -999999;

    for (final reward in rewards) {
      final priority =
          const RewardScoringEngine().score(
        reward: reward,
        revenue: revenue,
      );

      if (priority.score > highest) {
        highest = priority.score;
        best = reward;
      }
    }

    return best;
  }
}