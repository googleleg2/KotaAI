import 'package:flutter/material.dart';

import '../ai/models/ai_offer.dart';
import '../ai/models/cart_analysis.dart';
import '../ai/models/customer_profile.dart';
import '../ai/revenue_engine.dart';
import '../ai/revenue_score.dart';
import '../ai/scoring/cart_score.dart';
import '../ai/scoring/customer_score.dart';
import '../ai/scoring/sales_score.dart';
import '../ai/scoring/time_score.dart';

class RevenueController extends ChangeNotifier {
  final RevenueEngine _engine = const RevenueEngine();

  AiOffer? _offer;
  AiOffer? get offer => _offer;

  double _score = 0;
  double get score => _score;

  RevenueScore? _revenueScore;
  RevenueScore? get revenueScore => _revenueScore;

  // Business State
  double _salesToday = 0;
  double _targetSales = 10000;

  // Customer State
  CustomerProfile _customer = const CustomerProfile(
    id: 'guest',
  );

  /// Update today's business information
  void updateBusiness({
    required double salesToday,
    required double targetSales,
  }) {
    _salesToday = salesToday;
    _targetSales = targetSales;
  }

  /// Update the current customer
  void updateCustomer(CustomerProfile customer) {
    _customer = customer;
  }

  /// Evaluate the AI whenever the cart changes
  void evaluateCart(CartAnalysis cart) {
    final salesScore = const SalesScore().calculate(
      salesToday: _salesToday,
      targetSales: _targetSales,
    );

    final customerScore =
        const CustomerScore().calculate(
      _customer,
    );

    final cartScore =
        const CartScore().calculate(
      cart,
    );

    final timeScore =
        const TimeScore().calculate(
      DateTime.now(),
    );

    const loyaltyScore = 50.0;

    _revenueScore = RevenueScore(
      salesScore: salesScore,
      customerScore: customerScore,
      cartScore: cartScore,
      timeScore: timeScore,
      loyaltyScore: loyaltyScore,
    );

    _score = _revenueScore!.total;

    _offer = _engine.calculateOffer(
      _revenueScore!,
    );

    notifyListeners();
  }

  /// Temporary helper while we are developing
  void initialize({
    required double salesToday,
    required double targetSales,
    required CustomerProfile customer,
    required CartAnalysis cart,
  }) {
    updateBusiness(
      salesToday: salesToday,
      targetSales: targetSales,
    );

    updateCustomer(customer);

    evaluateCart(cart);
  }

  void clearOffer() {
    _offer = null;
    _revenueScore = null;
    _score = 0;

    notifyListeners();
  }
}