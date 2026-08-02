import 'package:flutter/material.dart';

import '../models/customer_order.dart';
import '../widgets/receipt_summary.dart';
import '../widgets/save_receipt_button.dart';

class ReceiptScreen extends StatelessWidget {
  final CustomerOrder order;

  const ReceiptScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Receipt"),
      ),

      body: SafeArea(

        child: Column(

          children: [

            Expanded(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(20),

                child: ReceiptSummary(
                  order: order,
                ),
              ),
            ),

            SaveReceiptButton(
              order: order,
            ),
          ],
        ),
      ),
    );
  }
}