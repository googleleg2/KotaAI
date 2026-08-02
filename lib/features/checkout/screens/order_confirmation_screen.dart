import 'package:flutter/material.dart';

import '../models/customer_order.dart';
import 'receipt_screen.dart';

class OrderConfirmationScreen
    extends StatelessWidget {

  final CustomerOrder order;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: Center(

          child: Padding(

            padding: const EdgeInsets.all(30),

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 110,
                ),

                const SizedBox(height: 30),

                const Text(
                  "Order Confirmed!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Total: R${order.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 40),

                ElevatedButton.icon(

                  onPressed: () {

                    // Receipt Viewer
                    // Milestone 6.5

                  },

                  icon: const Icon(Icons.receipt),

                  label: const Text(
                    "VIEW RECEIPT",
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReceiptScreen(
                          order: order,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.receipt),
                  label: const Text("VIEW RECEIPT"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}