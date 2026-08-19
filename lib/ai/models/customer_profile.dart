class CustomerProfile {
  final String id;

  final bool firstOrder;

  final int totalOrders;

  final double lifetimeSpend;

  final double averageOrderValue;

  final int loyaltyPoints;

  final int daysSinceLastOrder;

  const CustomerProfile({
    required this.id,
    this.firstOrder = false,
    this.totalOrders = 0,
    this.lifetimeSpend = 0,
    this.averageOrderValue = 0,
    this.loyaltyPoints = 0,
    this.daysSinceLastOrder = 0,
  });

  // ============================================================
  // FIRESTORE -> CUSTOMER PROFILE
  // ============================================================

  factory CustomerProfile.fromMap(
    Map<String, dynamic> map,
  ) {
    return CustomerProfile(
      id: map['id']?.toString() ?? '',
      firstOrder: map['firstOrder'] == true,
      totalOrders: _toInt(
        map['totalOrders'],
      ),
      lifetimeSpend: _toDouble(
        map['lifetimeSpend'],
      ),
      averageOrderValue: _toDouble(
        map['averageOrderValue'],
      ),
      loyaltyPoints: _toInt(
        map['loyaltyPoints'],
      ),
      daysSinceLastOrder: _toInt(
        map['daysSinceLastOrder'],
      ),
    );
  }

  // ============================================================
  // CUSTOMER PROFILE -> FIRESTORE
  // ============================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstOrder': firstOrder,
      'totalOrders': totalOrders,
      'lifetimeSpend': lifetimeSpend,
      'averageOrderValue': averageOrderValue,
      'loyaltyPoints': loyaltyPoints,
      'daysSinceLastOrder': daysSinceLastOrder,
    };
  }

  // ============================================================
  // VALUE HELPERS
  // ============================================================

  static int _toInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static double _toDouble(
    dynamic value,
  ) {
    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }
}