import 'package:flutter/material.dart';

import '../models/customer_order.dart';

class ReceiptSummary extends StatelessWidget {

  final CustomerOrder order;

  const ReceiptSummary({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      elevation: 8,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Center(
              child: Icon(
                Icons.restaurant,
                size: 60,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 10),

            const Center(
              child: Text(
                "KOTA APP",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const Divider(height: 35),

            Text(
              "Order #: ${order.orderNumber}",
            ),

            Text(
              "Customer: ${order.customerName}",
            ),

            Text(
              "Phone: ${order.phone}",
            ),

            Text(
              order.delivery
                  ? "Delivery"
                  : "Collection",
            ),

            if (order.delivery)

              Text(
                order.address,
              ),

            const Divider(height: 35),

            const Text(
              "Items",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 10),

            ...order.items.map(

              (item) => ListTile(

                dense: true,

                title: Text(
                  item.ingredient.name,
                ),

                trailing: Text(
                  "R${item.subtotal.toStringAsFixed(2)}",
                ),
              ),
            ),

            const Divider(),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [

                const Text("Subtotal"),

                Text(
                  "R${order.subtotal.toStringAsFixed(2)}",
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [

                const Text("Discount"),

                Text(
                  "-R${order.discount.toStringAsFixed(2)}",
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [

                const Text("Delivery"),

                Text(
                  "R${order.deliveryFee.toStringAsFixed(2)}",
                ),
              ],
            ),

            const Divider(),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "TOTAL",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Text(
                  "R${order.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Center(
              child: Icon(
                Icons.qr_code_2,
                size: 90,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                "Thank you for your order!",
              ),
            ),
          ],
        ),
      ),
    );
  }
}