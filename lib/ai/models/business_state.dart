class BusinessState {

  final double salesToday;

  final double targetSales;

  final int ordersToday;

  final int targetOrders;

  final bool raining;

  final bool payday;

  final bool holiday;

  const BusinessState({

    required this.salesToday,

    required this.targetSales,

    required this.ordersToday,

    required this.targetOrders,

    this.raining = false,

    this.payday = false,

    this.holiday = false,
  });

}