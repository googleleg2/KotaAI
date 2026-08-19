import 'package:cloud_firestore/cloud_firestore.dart';

class SalesDay {
  final DateTime date;
  final double revenue;
  final int orders;
  final int paidOrders;

  const SalesDay({
    required this.date,
    required this.revenue,
    required this.orders,
    required this.paidOrders,
  });
}

class HourlySales {
  final int hour;
  final double revenue;
  final int orders;

  const HourlySales({
    required this.hour,
    required this.revenue,
    required this.orders,
  });
}

class SalesAnalytics {
  final List<SalesDay> dailySales;
  final List<HourlySales> hourlySales;

  final double sevenDayRevenue;
  final int sevenDayOrders;
  final double averageDailyRevenue;

  final double bestDayRevenue;
  final DateTime? bestDay;

  const SalesAnalytics({
    required this.dailySales,
    required this.hourlySales,
    required this.sevenDayRevenue,
    required this.sevenDayOrders,
    required this.averageDailyRevenue,
    required this.bestDayRevenue,
    required this.bestDay,
  });

  const SalesAnalytics.empty()
      : dailySales = const [],
        hourlySales = const [],
        sevenDayRevenue = 0.0,
        sevenDayOrders = 0,
        averageDailyRevenue = 0.0,
        bestDayRevenue = 0.0,
        bestDay = null;

  factory SalesAnalytics.fromOrders(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> orders,
  ) {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final sevenDaysAgo = today.subtract(
      const Duration(days: 6),
    );

    final dailyMap = <String, _MutableSalesDay>{};

    final hourlyMap = <int, _MutableHourlySales>{};

    // ----------------------------------------------------------
    // CREATE THE LAST 7 DAYS
    // ----------------------------------------------------------

    for (int i = 0; i < 7; i++) {
      final date = sevenDaysAgo.add(
        Duration(days: i),
      );

      final key = _dateKey(date);

      dailyMap[key] = _MutableSalesDay(
        date: date,
      );
    }

    // ----------------------------------------------------------
    // CREATE TODAY'S 24 HOURS
    // ----------------------------------------------------------

    for (int hour = 0; hour < 24; hour++) {
      hourlyMap[hour] = _MutableHourlySales(
        hour: hour,
      );
    }

    // ----------------------------------------------------------
    // PROCESS ORDERS
    // ----------------------------------------------------------

    for (final order in orders) {
      final data = order.data();

      final createdAt = data['createdAt'];

      if (createdAt is! Timestamp) {
        continue;
      }

      final orderDate = createdAt.toDate();

      final normalizedDate = DateTime(
        orderDate.year,
        orderDate.month,
        orderDate.day,
      );

      // --------------------------------------------------------
      // ONLY LOOK AT THE LAST 7 DAYS
      // --------------------------------------------------------

      if (normalizedDate.isBefore(sevenDaysAgo)) {
        continue;
      }

      if (normalizedDate.isAfter(today)) {
        continue;
      }

      final paymentStatus =
          data['paymentStatus']
              ?.toString()
              .toLowerCase()
              .trim() ??
          '';

      final total = _toDouble(
        data['total'],
      );

      final dayKey = _dateKey(
        normalizedDate,
      );

      final day = dailyMap[dayKey];

      if (day == null) {
        continue;
      }

      day.orders++;

      // --------------------------------------------------------
      // REVENUE ONLY COMES FROM PAID ORDERS
      // --------------------------------------------------------

      if (paymentStatus == 'paid') {
        day.paidOrders++;
        day.revenue += total;
      }

      // --------------------------------------------------------
      // TODAY'S HOURLY DATA
      // --------------------------------------------------------

      if (_isSameDay(
        normalizedDate,
        today,
      )) {
        final hour = hourlyMap[orderDate.hour];

        if (hour != null) {
          hour.orders++;

          if (paymentStatus == 'paid') {
            hour.revenue += total;
          }
        }
      }
    }

    // ----------------------------------------------------------
    // CONVERT DAILY DATA
    // ----------------------------------------------------------

    final dailySales = dailyMap.values
        .map(
          (day) => SalesDay(
            date: day.date,
            revenue: day.revenue,
            orders: day.orders,
            paidOrders: day.paidOrders,
          ),
        )
        .toList();

    dailySales.sort(
      (a, b) => a.date.compareTo(b.date),
    );

    // ----------------------------------------------------------
    // CONVERT HOURLY DATA
    // ----------------------------------------------------------

    final hourlySales = hourlyMap.values
        .map(
          (hour) => HourlySales(
            hour: hour.hour,
            revenue: hour.revenue,
            orders: hour.orders,
          ),
        )
        .toList();

    hourlySales.sort(
      (a, b) => a.hour.compareTo(b.hour),
    );

    // ----------------------------------------------------------
    // TOTALS
    // ----------------------------------------------------------

    final sevenDayRevenue = dailySales.fold<double>(
      0.0,
      (sum, day) => sum + day.revenue,
    );

    final sevenDayOrders = dailySales.fold<int>(
      0,
      (sum, day) => sum + day.orders,
    );

    final averageDailyRevenue =
        sevenDayRevenue / 7.0;

    // ----------------------------------------------------------
    // BEST DAY
    // ----------------------------------------------------------

    SalesDay? bestDayObject;

    for (final day in dailySales) {
      if (bestDayObject == null ||
          day.revenue > bestDayObject.revenue) {
        bestDayObject = day;
      }
    }

    return SalesAnalytics(
      dailySales: dailySales,
      hourlySales: hourlySales,
      sevenDayRevenue: sevenDayRevenue,
      sevenDayOrders: sevenDayOrders,
      averageDailyRevenue: averageDailyRevenue,
      bestDayRevenue:
          bestDayObject?.revenue ?? 0.0,
      bestDay:
          bestDayObject?.date,
    );
  }

  static bool _isSameDay(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  static String _dateKey(
    DateTime date,
  ) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
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

// ============================================================
// INTERNAL MUTABLE CLASSES
// ============================================================

class _MutableSalesDay {
  final DateTime date;

  double revenue = 0.0;
  int orders = 0;
  int paidOrders = 0;

  _MutableSalesDay({
    required this.date,
  });
}

class _MutableHourlySales {
  final int hour;

  double revenue = 0.0;
  int orders = 0;

  _MutableHourlySales({
    required this.hour,
  });
}