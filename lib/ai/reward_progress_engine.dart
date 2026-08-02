import 'models/reward_progress.dart';

class RewardProgressEngine {
  const RewardProgressEngine();

  RewardProgress calculate({
    required double cartTotal,
    required double rewardTarget,
  }) {
    final progress =
        (cartTotal / rewardTarget)
            .clamp(0.0, 1.0);

    final remaining =
        (rewardTarget - cartTotal)
            .clamp(0.0, rewardTarget);

    return RewardProgress(
      progress: progress,
      remaining: remaining,
      target: rewardTarget,
    );
  }
}