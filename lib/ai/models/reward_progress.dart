class RewardProgress {
  final double progress;
  final double remaining;
  final double target;

  const RewardProgress({
    required this.progress,
    required this.remaining,
    required this.target,
  });
}

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