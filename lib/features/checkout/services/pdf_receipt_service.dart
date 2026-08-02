import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/customer_order.dart';

class PdfReceiptService {
  const PdfReceiptService();

  Future<File> generate(
    CustomerOrder order,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (_) => [

          pw.Center(
            child: pw.Text(
              "KOTA APP",
              style: pw.TextStyle(
                fontSize: 26,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),

          pw.SizedBox(height: 15),

          pw.Text("Order Number: ${order.orderNumber}"),
          pw.Text("Date: ${order.createdAt}"),
          pw.Text("Customer: ${order.customerName}"),
          pw.Text("Phone: ${order.phone}"),

          pw.Divider(),

          pw.Text(
            "Items",
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 18,
            ),
          ),

          ...order.items.map(
            (item) => pw.Row(
              mainAxisAlignment:
                  pw.MainAxisAlignment.spaceBetween,
              children: [

                pw.Text(item.ingredient.name),

                pw.Text(
                  "R${item.subtotal.toStringAsFixed(2)}",
                ),
              ],
            ),
          ),

          pw.Divider(),

          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Subtotal"),
              pw.Text(
                "R${order.subtotal.toStringAsFixed(2)}",
              ),
            ],
          ),

          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Discount"),
              pw.Text(
                "-R${order.discount.toStringAsFixed(2)}",
              ),
            ],
          ),

          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text("Delivery"),
              pw.Text(
                "R${order.deliveryFee.toStringAsFixed(2)}",
              ),
            ],
          ),

          pw.Divider(),

          pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,
            children: [

              pw.Text(
                "TOTAL",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.Text(
                "R${order.total.toStringAsFixed(2)}",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 30),

          pw.Center(
            child: pw.Text(
              "Thank you for supporting Kota App!",
            ),
          ),
        ],
      ),
    );

    final directory =
        await getApplicationDocumentsDirectory();

    final file = File(
      "${directory.path}/${order.orderNumber}.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    return file;
  }
}