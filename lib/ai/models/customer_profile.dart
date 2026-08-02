class CustomerProfile {
  final String id;

  final bool firstOrder;

  final int totalOrders;

  final double lifetimeSpend;

  final double averageOrderValue;

  final int loyaltyPoints;

  final int daysSinceLastOrder;

  final bool birthdayMonth;

  const CustomerProfile({
    required this.id,
    this.firstOrder = false,
    this.totalOrders = 0,
    this.lifetimeSpend = 0,
    this.averageOrderValue = 0,
    this.loyaltyPoints = 0,
    this.daysSinceLastOrder = 0,
    this.birthdayMonth = false,
  });
}