class RewardThresholdEngine {
  const RewardThresholdEngine();

  double calculate({
    required double averageOrder,
    required bool quietDay,
    required bool payday,
  }) {
    if (payday) {
      return 180;
    }

    if (quietDay) {
      return 70;
    }

    if (averageOrder > 120) {
      return 150;
    }

    return 90;
  }
}