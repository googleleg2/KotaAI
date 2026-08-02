class RevenueScore {
  final double salesScore;
  final double customerScore;
  final double cartScore;
  final double timeScore;
  final double loyaltyScore;

  const RevenueScore({
    required this.salesScore,
    required this.customerScore,
    required this.cartScore,
    required this.timeScore,
    required this.loyaltyScore,
  });

  double get total =>
      salesScore +
      customerScore +
      cartScore +
      timeScore +
      loyaltyScore;
}