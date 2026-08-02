class SalesScore {

  const SalesScore();

  double calculate({
    required double salesToday,
    required double targetSales,
  }) {

    if (targetSales == 0) {
      return 0;
    }

    final progress =
        salesToday / targetSales;

    return (100 * progress)
        .clamp(0, 100);
  }
}