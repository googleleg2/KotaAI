import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/firestore_service.dart';
import '../models/customer_order.dart';

class OrderService {
  const OrderService();

  FirebaseFirestore get _firestore {
    return FirebaseFirestore.instance;
  }

  FirebaseAuth get _auth {
    return FirebaseAuth.instance;
  }

  // ============================================================
  // CREATE ORDER
  //
  // IMPORTANT:
  // Creating an order does NOT increase totalOrders.
  //
  // totalOrders is increased only after the order is paid.
  // ============================================================

  Future<void> createOrder(
    CustomerOrder order,
  ) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message:
            'You must be signed in to create an order.',
      );
    }

    final String customerName =
        order.customerName.trim().isNotEmpty
            ? order.customerName.trim()
            : _getFirebaseCustomerName(user);

    final String customerEmail =
        user.email ?? order.customerEmail;

    final CustomerOrder updatedOrder =
        order.copyWith(
      userId: user.uid,
      customerEmail: customerEmail,
      customerName: customerName,
    );

    // ----------------------------------------------------------
    // SAVE ORDER
    // ----------------------------------------------------------

    await FirestoreService.orders()
        .doc(updatedOrder.orderNumber)
        .set(
          updatedOrder.toMap(),
        );

    // ----------------------------------------------------------
    // CREATE / UPDATE USER PROFILE
    //
    // DO NOT increment totalOrders here.
    // ----------------------------------------------------------

    await _createOrUpdateUserProfile(
      user: user,
      customerName: customerName,
      customerEmail: customerEmail,
    );
  }

  // ============================================================
  // CREATE / UPDATE USER PROFILE
  // ============================================================

  Future<void> _createOrUpdateUserProfile({
    required User user,
    required String customerName,
    required String customerEmail,
  }) async {
    final DocumentReference<Map<String, dynamic>>
        userRef =
        _firestore
            .collection('users')
            .doc(user.uid);

    final DocumentSnapshot<Map<String, dynamic>>
        existing =
        await userRef.get();

    final Map<String, dynamic> data = {
      'uid': user.uid,
      'email': customerEmail,
      'displayName': customerName,
      'photoUrl': user.photoURL ?? '',
      'phoneNumber': user.phoneNumber ?? '',
      'emailVerified': user.emailVerified,
      'updatedAt':
          FieldValue.serverTimestamp(),
    };

    if (!existing.exists) {
      data['createdAt'] =
          FieldValue.serverTimestamp();

      data['loyaltyPoints'] = 0;
      data['totalOrders'] = 0;
      data['amountSaved'] = 0.0;
      data['favouriteKotas'] = <dynamic>[];
    }

    await userRef.set(
      data,
      SetOptions(merge: true),
    );
  }

  // ============================================================
  // GET FIREBASE CUSTOMER NAME
  // ============================================================

  String _getFirebaseCustomerName(
    User user,
  ) {
    if (user.displayName != null &&
        user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }

    if (user.email != null &&
        user.email!.contains('@')) {
      return user.email!.split('@').first;
    }

    return 'Kota Customer';
  }

  // ============================================================
  // GET SINGLE ORDER
  // ============================================================

  Future<CustomerOrder?> getOrder(
    String orderNumber,
  ) async {
    final snapshot =
        await FirestoreService.orders()
            .doc(orderNumber)
            .get();

    if (!snapshot.exists) {
      return null;
    }

    final dynamic rawData =
        snapshot.data();

    if (rawData == null) {
      return null;
    }

    final Map<String, dynamic> data =
        Map<String, dynamic>.from(
      rawData as Map,
    );

    return CustomerOrder.fromMap(data);
  }

  // ============================================================
  // STREAM CUSTOMER ORDERS
  // ============================================================

  Stream<List<CustomerOrder>>
      streamCustomerOrders() {
    final User? user =
        _auth.currentUser;

    if (user == null) {
      return Stream.value(
        <CustomerOrder>[],
      );
    }

    return FirestoreService.orders()
        .where(
          'userId',
          isEqualTo: user.uid,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            final dynamic rawData =
                doc.data();

            final Map<String, dynamic>
                data =
                Map<String, dynamic>.from(
              rawData as Map,
            );

            return CustomerOrder.fromMap(
              data,
            );
          },
        ).toList();
      },
    );
  }

  // ============================================================
  // GET CUSTOMER ORDERS
  // ============================================================

  Future<List<CustomerOrder>>
      getCustomerOrders() async {
    final User? user =
        _auth.currentUser;

    if (user == null) {
      return <CustomerOrder>[];
    }

    final snapshot =
        await FirestoreService.orders()
            .where(
              'userId',
              isEqualTo: user.uid,
            )
            .orderBy(
              'createdAt',
              descending: true,
            )
            .get();

    return snapshot.docs.map(
      (doc) {
        final dynamic rawData =
            doc.data();

        final Map<String, dynamic>
            data =
            Map<String, dynamic>.from(
          rawData as Map,
        );

        return CustomerOrder.fromMap(
          data,
        );
      },
    ).toList();
  }

  // ============================================================
  // MARK ORDER AS PAID
  //
  // This is now where totalOrders is incremented.
  //
  // A transaction prevents duplicate increments if markPaid()
  // is accidentally called more than once for the same order.
  // ============================================================

  Future<void> markPaid({
    required String orderNumber,
    required String paypalOrderId,
    required String captureId,
  }) async {
    final User? user =
        _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message:
            'You must be signed in to complete payment.',
      );
    }

    final orderRef =
        FirestoreService.orders()
            .doc(orderNumber);

    final userRef =
        _firestore
            .collection('users')
            .doc(user.uid);

    await _firestore.runTransaction(
      (transaction) async {
        final orderSnapshot =
            await transaction.get(
          orderRef,
        );

        if (!orderSnapshot.exists) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'order-not-found',
            message:
                'Order $orderNumber was not found.',
          );
        }

        final Map<String, dynamic> orderData =
    orderSnapshot.data() is Map
        ? Map<String, dynamic>.from(
            orderSnapshot.data() as Map,
          )
        : <String, dynamic>{};

        final currentPaymentStatus =
            orderData['paymentStatus']
                ?.toString()
                .toLowerCase()
                .trim() ??
            '';

        // ------------------------------------------------------
        // ALREADY PAID
        //
        // Do not increment totalOrders again.
        // ------------------------------------------------------

        if (currentPaymentStatus == 'paid') {
          return;
        }

        final userSnapshot =
            await transaction.get(
          userRef,
        );

        final userData =
            userSnapshot.data() ??
                <String, dynamic>{};

        final currentTotalOrders =
            _toInt(
          userData['totalOrders'],
        );

        // ------------------------------------------------------
        // UPDATE ORDER
        // ------------------------------------------------------

        transaction.update(
          orderRef,
          {
            'paymentStatus': 'Paid',
            'status': 'Preparing',
            'paypalOrderId':
                paypalOrderId,
            'paypalCaptureId':
                captureId,
            'paidAt':
                FieldValue.serverTimestamp(),
          },
        );

        // ------------------------------------------------------
        // UPDATE CUSTOMER PROFILE
        // ------------------------------------------------------

        transaction.set(
          userRef,
          {
            'totalOrders':
                currentTotalOrders + 1,
            'lastOrderAt':
                FieldValue.serverTimestamp(),
            'updatedAt':
                FieldValue.serverTimestamp(),
          },
          SetOptions(
            merge: true,
          ),
        );
      },
    );
  }

  // ============================================================
  // UPDATE PAYPAL PAYMENT INFORMATION
  // ============================================================

  Future<void> updatePaymentStatus({
    required String orderNumber,
    required String paymentStatus,
    required String paypalOrderId,
    required String paypalCaptureId,
  }) async {
    await FirestoreService.orders()
        .doc(orderNumber)
        .update({
      'paymentStatus': paymentStatus,
      'paypalOrderId':
          paypalOrderId,
      'paypalCaptureId':
          paypalCaptureId,
    });
  }

  // ============================================================
  // UPDATE DELIVERY STATUS
  // ============================================================

  Future<void> updateDeliveryStatus({
    required String orderNumber,
    required String status,
  }) async {
    await FirestoreService.orders()
        .doc(orderNumber)
        .update({
      'deliveryStatus': status,
    });
  }

  // ============================================================
  // DELETE ORDER
  // ============================================================

  Future<void> deleteOrder(
    String orderNumber,
  ) async {
    await FirestoreService.orders()
        .doc(orderNumber)
        .delete();
  }

  // ============================================================
  // LEGACY ADMIN ORDER STREAM
  // ============================================================

  Stream<List<CustomerOrder>>
      streamOrders() {
    return FirestoreService.orders()
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            final dynamic rawData =
                doc.data();

            final Map<String, dynamic>
                data =
                Map<String, dynamic>.from(
              rawData as Map,
            );

            return CustomerOrder.fromMap(
              data,
            );
          },
        ).toList();
      },
    );
  }

  // ============================================================
  // VALUE HELPER
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
}