import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kota_ai/models/cart_item.dart';

class CustomerOrder {
  final String orderNumber;

  /// Firebase Authentication UID.
  final String userId;

  /// Firebase Authentication email.
  final String customerEmail;

  final String customerName;
  final String phone;

  final bool delivery;

  final String address;
  final String notes;

  final List<CartItem> items;

  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;

  final String paymentStatus;
  final String paymentMethod;

  final String paypalOrderId;
  final String paypalCaptureId;

  final DateTime createdAt;

  const CustomerOrder({
    required this.orderNumber,
    this.userId = '',
    this.customerEmail = '',
    required this.customerName,
    required this.phone,
    required this.delivery,
    required this.address,
    required this.notes,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.paypalOrderId,
    required this.paypalCaptureId,
    required this.createdAt,
  });

  factory CustomerOrder.fromMap(
    Map<String, dynamic> map,
  ) {
    final rawItems = map['items'] as List<dynamic>? ?? [];

    DateTime createdAt;

    final createdValue = map['createdAt'];

    if (createdValue is Timestamp) {
      createdAt = createdValue.toDate();
    } else if (createdValue is String) {
      createdAt = DateTime.tryParse(createdValue) ??
          DateTime.fromMillisecondsSinceEpoch(0);
    } else {
      createdAt = DateTime.now();
    }

    return CustomerOrder(
      orderNumber: map['orderNumber'] ?? '',
      userId: map['userId'] ?? '',
      customerEmail: map['customerEmail'] ?? '',
      customerName: map['customerName'] ?? '',
      phone: map['phone'] ?? '',
      delivery: map['delivery'] ?? false,
      address: map['address'] ?? '',
      notes: map['notes'] ?? '',
      items: rawItems
          .map(
            (item) => CartItem.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),
      subtotal: _toDouble(map['subtotal']),
      discount: _toDouble(map['discount']),
      deliveryFee: _toDouble(map['deliveryFee']),
      total: _toDouble(map['total']),
      paymentStatus: map['paymentStatus'] ?? 'Pending',
      paymentMethod: map['paymentMethod'] ?? 'PayPal',
      paypalOrderId: map['paypalOrderId'] ?? '',
      paypalCaptureId: map['paypalCaptureId'] ?? '',
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderNumber': orderNumber,
      'userId': userId,
      'customerEmail': customerEmail,
      'customerName': customerName,
      'phone': phone,
      'delivery': delivery,
      'address': address,
      'notes': notes,
      'items': items
          .map(
            (item) => item.toMap(),
          )
          .toList(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'total': total,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'paypalOrderId': paypalOrderId,
      'paypalCaptureId': paypalCaptureId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  CustomerOrder copyWith({
    String? orderNumber,
    String? userId,
    String? customerEmail,
    String? customerName,
    String? phone,
    bool? delivery,
    String? address,
    String? notes,
    List<CartItem>? items,
    double? subtotal,
    double? discount,
    double? deliveryFee,
    double? total,
    String? paymentStatus,
    String? paymentMethod,
    String? paypalOrderId,
    String? paypalCaptureId,
    DateTime? createdAt,
  }) {
    return CustomerOrder(
      orderNumber: orderNumber ?? this.orderNumber,
      userId: userId ?? this.userId,
      customerEmail: customerEmail ?? this.customerEmail,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      delivery: delivery ?? this.delivery,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paypalOrderId: paypalOrderId ?? this.paypalOrderId,
      paypalCaptureId: paypalCaptureId ?? this.paypalCaptureId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }
}