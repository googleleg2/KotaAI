import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../ai/models/customer_profile.dart';

class CustomerProfileService {
  CustomerProfileService._();

  static final CustomerProfileService instance =
      CustomerProfileService._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  // ============================================================
  // ENSURE USER PROFILE EXISTS
  // ============================================================

  Future<void> ensureProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final ref = _firestore
        .collection('users')
        .doc(user.uid);

    final snapshot = await ref.get();

    if (snapshot.exists) {
      return;
    }

    final displayName =
        user.displayName?.trim().isNotEmpty == true
            ? user.displayName!.trim()
            : _emailName(user.email);

    await ref.set({
      'uid': user.uid,
      'email': user.email ?? '',
      'displayName': displayName,
      'photoUrl': user.photoURL ?? '',
      'phoneNumber': user.phoneNumber ?? '',
      'emailVerified': user.emailVerified,

      // Loyalty
      'loyaltyPoints': 0,

      // Customer order statistics
      'totalOrders': 0,

      // Savings / favourites
      'amountSaved': 0.0,
      'favouriteKotas': [],

      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ============================================================
  // STREAM RAW FIRESTORE USER PROFILE
  // ============================================================

  Stream<DocumentSnapshot<Map<String, dynamic>>>
      streamProfile() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots();
  }

  // ============================================================
  // GET RAW FIRESTORE USER PROFILE
  // ============================================================

  Future<DocumentSnapshot<Map<String, dynamic>>?>
      getProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .get();
  }

  // ============================================================
  // BUILD CUSTOMER PROFILE
  //
  // totalOrders comes directly from:
  //
  // users/{uid}.totalOrders
  //
  // Lifetime spend and last order information are still
  // calculated from paid orders.
  // ============================================================

  Future<CustomerProfile?> getCustomerProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    // ----------------------------------------------------------
    // GET USER DOCUMENT
    // ----------------------------------------------------------

    final userSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userSnapshot.exists) {
      return null;
    }

    final userData =
        userSnapshot.data() ??
            <String, dynamic>{};

    // ----------------------------------------------------------
    // TOTAL ORDERS
    //
    // IMPORTANT:
    // Firestore user profile is now the source of truth.
    // ----------------------------------------------------------

    final totalOrders = _toInt(
      userData['totalOrders'],
    );

    // ----------------------------------------------------------
    // LOYALTY POINTS
    // ----------------------------------------------------------

    final loyaltyPoints = _toInt(
      userData['loyaltyPoints'],
    );

    // ----------------------------------------------------------
    // GET CUSTOMER ORDERS
    // ----------------------------------------------------------

    final ordersSnapshot = await _firestore
        .collection('orders')
        .where(
          'userId',
          isEqualTo: user.uid,
        )
        .get();

    // ----------------------------------------------------------
    // ONLY COUNT PAID ORDERS FOR SPEND CALCULATIONS
    // ----------------------------------------------------------

    final paidOrders =
        ordersSnapshot.docs.where(
      (doc) {
        final data = doc.data();

        final paymentStatus =
            data['paymentStatus']
                ?.toString()
                .toLowerCase()
                .trim();

        return paymentStatus == 'paid';
      },
    ).toList();

    // ----------------------------------------------------------
    // LIFETIME SPEND
    // ----------------------------------------------------------

    double lifetimeSpend = 0.0;

    for (final order in paidOrders) {
      final data = order.data();

      lifetimeSpend += _toDouble(
        data['total'],
      );
    }

    // ----------------------------------------------------------
    // AVERAGE ORDER VALUE
    // ----------------------------------------------------------

    final double averageOrderValue =
        totalOrders > 0
            ? lifetimeSpend / totalOrders
            : 0.0;

    // ----------------------------------------------------------
    // FIRST ORDER
    // ----------------------------------------------------------

    final bool firstOrder =
        totalOrders == 0;

    // ----------------------------------------------------------
    // DAYS SINCE LAST ORDER
    // ----------------------------------------------------------

    int daysSinceLastOrder = 0;

    if (paidOrders.isNotEmpty) {
      DateTime? latestOrderDate;

      for (final order in paidOrders) {
        final data = order.data();

        final createdAt = data['createdAt'];

        if (createdAt is Timestamp) {
          final date = createdAt.toDate();

          if (latestOrderDate == null ||
              date.isAfter(latestOrderDate)) {
            latestOrderDate = date;
          }
        }
      }

      if (latestOrderDate != null) {
        final now = DateTime.now();

        final difference =
            now.difference(latestOrderDate).inDays;

        daysSinceLastOrder =
            difference < 0
                ? 0
                : difference;
      }
    }

    // ----------------------------------------------------------
    // RETURN REAL CUSTOMER PROFILE
    // ----------------------------------------------------------

    return CustomerProfile(
      id: user.uid,
      firstOrder: firstOrder,
      totalOrders: totalOrders,
      lifetimeSpend: lifetimeSpend,
      averageOrderValue: averageOrderValue,
      loyaltyPoints: loyaltyPoints,
      daysSinceLastOrder: daysSinceLastOrder,
    );
  }

  // ============================================================
  // STREAM CUSTOMER PROFILE
  //
  // Because this listens directly to users/{uid},
  // changes to totalOrders immediately rebuild the profile.
  // ============================================================

  Stream<CustomerProfile?>
      streamCustomerProfile() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .asyncMap(
      (_) async {
        return getCustomerProfile();
      },
    );
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  Future<void> updateProfile({
    String? displayName,
    String? phoneNumber,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message: 'You must be signed in.',
      );
    }

    final data = <String, dynamic>{
      'updatedAt':
          FieldValue.serverTimestamp(),
    };

    if (displayName != null) {
      data['displayName'] = displayName;
    }

    if (phoneNumber != null) {
      data['phoneNumber'] = phoneNumber;
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(
          data,
          SetOptions(merge: true),
        );

    if (displayName != null &&
        displayName.trim().isNotEmpty) {
      await user.updateDisplayName(
        displayName.trim(),
      );
    }
  }

  // ============================================================
  // FIRESTORE SNAPSHOT -> CUSTOMER PROFILE
  // ============================================================

  CustomerProfile profileFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>>
        snapshot,
  ) {
    final data = snapshot.data();

    if (data == null) {
      return const CustomerProfile(
        id: 'guest',
      );
    }

    return CustomerProfile.fromMap({
      'id': snapshot.id,
      ...data,
    });
  }

  // ============================================================
  // FIRESTORE VALUE HELPERS
  // ============================================================

  int _toInt(dynamic value) {
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

  double _toDouble(dynamic value) {
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

  String _emailName(String? email) {
    if (email == null ||
        !email.contains('@')) {
      return 'Kota Customer';
    }

    return email.split('@').first;
  }
}