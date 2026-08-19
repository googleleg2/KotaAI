import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/business_dashboard_data.dart';
import '../models/sales_analytics.dart';

class BusinessDashboardService {
  BusinessDashboardService._();

  static final BusinessDashboardService instance =
      BusinessDashboardService._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // ============================================================
  // TODAY'S BUSINESS DATA
  // ============================================================

  Stream<BusinessDashboardData> streamToday() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value(
        const BusinessDashboardData.empty(),
      );
    }

    final now = DateTime.now();

    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final startTimestamp =
        Timestamp.fromDate(startOfDay);

    return _firestore
        .collection('orders')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: startTimestamp,
        )
        .snapshots()
        .map(
          (snapshot) {
            return BusinessDashboardData.fromOrders(
              snapshot.docs,
            );
          },
        );
  }

  // ============================================================
  // SALES ANALYTICS
  //
  // Last 7 days.
  // ============================================================

  Stream<SalesAnalytics> streamSalesAnalytics() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value(
        const SalesAnalytics.empty(),
      );
    }

    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    final sevenDaysAgo = today.subtract(
      const Duration(days: 6),
    );

    final startTimestamp =
        Timestamp.fromDate(sevenDaysAgo);

    return _firestore
        .collection('orders')
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: startTimestamp,
        )
        .snapshots()
        .map(
          (snapshot) {
            return SalesAnalytics.fromOrders(
              snapshot.docs,
            );
          },
        );
  }

  // ============================================================
  // ALL ORDERS
  //
  // Used later for deeper business analytics.
  // ============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>
      streamAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }

  // ============================================================
  // CURRENT USER
  // ============================================================

  User? get currentUser =>
      _auth.currentUser;
}