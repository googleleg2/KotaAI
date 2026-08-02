import 'package:flutter/material.dart';

import '../models/customer_order.dart';

class OrderController extends ChangeNotifier {

  CustomerOrder? _currentOrder;

  CustomerOrder? get currentOrder =>
      _currentOrder;

  void createOrder(
    CustomerOrder order,
  ) {

    _currentOrder = order;

    notifyListeners();
  }

  void clear() {

    _currentOrder = null;

    notifyListeners();
  }
}