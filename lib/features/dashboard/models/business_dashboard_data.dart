import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessDashboardData {
  final double revenueToday;
  final int ordersToday;
  final int paidOrdersToday;
  final int pendingOrdersToday;
  final int customersToday;
  final double averageOrderValue;

  const BusinessDashboardData({
    required this.revenueToday,
    required this.ordersToday,
    required this.paidOrdersToday,
    required this.pendingOrdersToday,
    required this.customersToday,
    required this.averageOrderValue,
  });

  const BusinessDashboardData.empty()
      : revenueToday = 0.0,
        ordersToday = 0,
        paidOrdersToday = 0,
        pendingOrdersToday = 0,
        customersToday = 0,
        averageOrderValue = 0.0;

  factory BusinessDashboardData.fromOrders(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> orders,
  ) {
    double revenue = 0.0;
    int paidOrders = 0;
    int pendingOrders = 0;

    final Set<String> customers = {};

    for (final order in orders) {
      final data = order.data();

      final paymentStatus =
          data['paymentStatus']?.toString().toLowerCase() ?? '';

      final total = _toDouble(data['total']);

      final userId = data['userId']?.toString();

      if (userId != null && userId.isNotEmpty) {
        customers.add(userId);
      }

      if (paymentStatus == 'paid') {
        paidOrders++;
        revenue += total;
      } else {
        pendingOrders++;
      }
    }

    final averageOrderValue =
        paidOrders > 0 ? revenue / paidOrders : 0.0;

    return BusinessDashboardData(
      revenueToday: revenue,
      ordersToday: orders.length,
      paidOrdersToday: paidOrders,
      pendingOrdersToday: pendingOrders,
      customersToday: customers.length,
      averageOrderValue: averageOrderValue,
    );
  }

  static double _toDouble(dynamic value) {
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