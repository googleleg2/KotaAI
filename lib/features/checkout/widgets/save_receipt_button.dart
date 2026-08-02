import 'package:flutter/material.dart';

import '../models/customer_order.dart';
import '../services/pdf_receipt_service.dart';

class SaveReceiptButton extends StatelessWidget {
  final CustomerOrder order;

  const SaveReceiptButton({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("SAVE RECEIPT"),
            onPressed: () async {
              final file =
                  await const PdfReceiptService()
                      .generate(order);

              if (!context.mounted) return;

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    "Receipt saved to:\n${file.path}",
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}