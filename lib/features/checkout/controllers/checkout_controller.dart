import 'package:flutter/material.dart';

import '../models/checkout_order.dart';

class CheckoutController extends ChangeNotifier {
  CheckoutOrder? _order;

  CheckoutOrder? get order => _order;

  void loadOrder(CheckoutOrder order) {
    _order = order;
    notifyListeners();
  }

  void clear() {
    _order = null;
    notifyListeners();
  }
}