import 'package:flutter/material.dart';

import '../models/checkout_order.dart';

class OrderSummary extends StatelessWidget {
  final CheckoutOrder order;

  const OrderSummary({
    super.key,
    required this.order,
  });

  Widget _line(
    String title,
    String value, {
    bool bold = false,
    Color color = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight:
                  bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _line(
            "Subtotal",
            "R${order.subtotal.toStringAsFixed(2)}",
          ),

          _line(
            "Discount",
            "-R${order.discount.toStringAsFixed(2)}",
            color: Colors.orange,
          ),

          _line(
            "Delivery",
            "R${order.deliveryFee.toStringAsFixed(2)}",
          ),

          const Divider(),

          _line(
            "TOTAL",
            "R${order.total.toStringAsFixed(2)}",
            bold: true,
          ),
        ],
      ),
    );
  }
}