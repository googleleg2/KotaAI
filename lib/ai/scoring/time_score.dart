class TimeScore {

  const TimeScore();

  double calculate(
    DateTime now,
  ) {

    final hour = now.hour;

    if (hour >= 12 && hour <= 14) {
      return 100;
    }

    if (hour >= 18 && hour <= 20) {
      return 95;
    }

    if (hour >= 15 && hour <= 17) {
      return 45;
    }

    if (hour >= 21) {
      return 30;
    }

    return 60;
  }
}