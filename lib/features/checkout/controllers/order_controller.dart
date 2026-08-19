import 'package:flutter/material.dart';

import '../models/customer_order.dart';
import '../services/order_service.dart';

class OrderController extends ChangeNotifier {
  final OrderService _orderService = const OrderService();

  CustomerOrder? _currentOrder;

  CustomerOrder? get currentOrder => _currentOrder;

  Future<void> createOrder(
    CustomerOrder order,
  ) async {
    _currentOrder = order;

    await _orderService.createOrder(
      order,
    );

    notifyListeners();
  }

  Future<void> updatePaymentStatus({
    required String orderNumber,
    required String paymentStatus,
    required String paypalOrderId,
    required String paypalCaptureId,
  }) async {
    await _orderService.updatePaymentStatus(
      orderNumber: orderNumber,
      paymentStatus: paymentStatus,
      paypalOrderId: paypalOrderId,
      paypalCaptureId: paypalCaptureId,
    );

    if (_currentOrder?.orderNumber == orderNumber) {
      _currentOrder = _currentOrder!.copyWith(
        paymentStatus: paymentStatus,
        paypalOrderId: paypalOrderId,
        paypalCaptureId: paypalCaptureId,
      );

      notifyListeners();
    }
  }

  Future<void> markPaid({
    required String orderNumber,
    required String paypalOrderId,
    required String captureId,
  }) async {
    await _orderService.markPaid(
      orderNumber: orderNumber,
      paypalOrderId: paypalOrderId,
      captureId: captureId,
    );

    if (_currentOrder?.orderNumber == orderNumber) {
      _currentOrder = _currentOrder!.copyWith(
        paymentStatus: 'Paid',
        paypalOrderId: paypalOrderId,
        paypalCaptureId: captureId,
      );

      notifyListeners();
    }
  }

  Stream<List<CustomerOrder>> streamCustomerOrders() {
    return _orderService.streamCustomerOrders();
  }

  Future<List<CustomerOrder>> getCustomerOrders() {
    return _orderService.getCustomerOrders();
  }

  void clear() {
    _currentOrder = null;
    notifyListeners();
  }
}