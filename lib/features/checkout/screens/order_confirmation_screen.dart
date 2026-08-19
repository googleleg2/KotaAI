import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/customer_order.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final CustomerOrder order;

  const OrderConfirmationScreen({
    super.key,
    required this.order,
  });

  // ============================================================
  // PAYMENT
  // ============================================================

  String get paymentStatus {
    return order.paymentStatus.isEmpty
        ? "Paid"
        : order.paymentStatus;
  }

  String get paymentMethod {
    return order.paymentMethod.isEmpty
        ? "PayPal"
        : order.paymentMethod;
  }

  // ============================================================
  // DATE
  // ============================================================

  String get formattedDate {
    return DateFormat(
      "dd MMM yyyy • HH:mm",
    ).format(order.createdAt);
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // INFO TILE
  // ============================================================

  Widget infoTile(
    String label,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TOTAL ROW
  // ============================================================

  Widget totalRow(
    String label,
    double value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: bold
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize:
                    bold ? 18 : 16,
              ),
            ),
          ),
          Text(
            "R${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: color,
              fontWeight: bold
                  ? FontWeight.bold
                  : FontWeight.normal,
              fontSize:
                  bold ? 18 : 16,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PDF
  // ============================================================

  Future<Uint8List> _buildReceiptPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin:
            const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'KOTA AI',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'Order Receipt',
                    style:
                        const pw.TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 25),

            pw.Divider(),

            pw.SizedBox(height: 15),

            pw.Text(
              'ORDER DETAILS',
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),

            _pdfInfoRow(
              'Order Number',
              order.orderNumber,
            ),

            _pdfInfoRow(
              'Date',
              formattedDate,
            ),

            _pdfInfoRow(
              'Payment',
              paymentMethod,
            ),

            _pdfInfoRow(
              'Status',
              paymentStatus,
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              'CUSTOMER',
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),

            _pdfInfoRow(
              'Name',
              order.customerName,
            ),

            _pdfInfoRow(
              'Phone',
              order.phone,
            ),

            _pdfInfoRow(
              'Delivery',
              order.delivery
                  ? 'Yes'
                  : 'Collection',
            ),

            if (order.delivery)
              _pdfInfoRow(
                'Address',
                order.address,
              ),

            if (order.notes.isNotEmpty)
              _pdfInfoRow(
                'Notes',
                order.notes,
              ),

            pw.SizedBox(height: 20),

            pw.Text(
              'ITEMS',
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),

            pw.Table(
              border:
                  pw.TableBorder.all(
                color:
                    PdfColors.grey300,
              ),
              columnWidths: const {
                0: pw.FlexColumnWidth(4),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  children: [
                    _pdfTableHeader(
                      'Item',
                    ),
                    _pdfTableHeader(
                      'Qty',
                    ),
                    _pdfTableHeader(
                      'Amount',
                    ),
                  ],
                ),
                ...order.items.map(
                  (item) {
                    return pw.TableRow(
                      children: [
                        _pdfTableCell(
                          item.ingredient.name,
                        ),
                        _pdfTableCell(
                          '${item.quantity}',
                        ),
                        _pdfTableCell(
                          'R${item.subtotal.toStringAsFixed(2)}',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            pw.Text(
              'TOTALS',
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 10),

            _pdfMoneyRow(
              'Subtotal',
              order.subtotal,
            ),

            _pdfMoneyRow(
              'Discount',
              order.discount,
            ),

            _pdfMoneyRow(
              'Delivery',
              order.deliveryFee,
            ),

            pw.Divider(),

            _pdfMoneyRow(
              'TOTAL PAID',
              order.total,
              bold: true,
            ),

            pw.SizedBox(height: 25),

            pw.Divider(),

            pw.SizedBox(height: 10),

            pw.Center(
              child: pw.Text(
                'Thank you for choosing Kota AI!',
                style:
                    const pw.TextStyle(
                  fontSize: 12,
                ),
              ),
            ),

            if (order.paypalOrderId.isNotEmpty) ...[
              pw.SizedBox(height: 15),
              _pdfInfoRow(
                'PayPal Order ID',
                order.paypalOrderId,
              ),
            ],

            if (order.paypalCaptureId.isNotEmpty)
              _pdfInfoRow(
                'PayPal Capture ID',
                order.paypalCaptureId,
              ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // PDF HELPERS
  // ============================================================

  pw.Widget _pdfInfoRow(
    String label,
    String value,
  ) {
    return pw.Padding(
      padding:
          const pw.EdgeInsets.symmetric(
        vertical: 3,
      ),
      child: pw.Row(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfMoneyRow(
    String label,
    double value, {
    bool bold = false,
  }) {
    return pw.Padding(
      padding:
          const pw.EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontWeight: bold
                    ? pw.FontWeight.bold
                    : pw.FontWeight.normal,
              ),
            ),
          ),
          pw.Text(
            'R${value.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontWeight: bold
                  ? pw.FontWeight.bold
                  : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfTableHeader(
    String text,
  ) {
    return pw.Padding(
      padding:
          const pw.EdgeInsets.all(7),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight:
              pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _pdfTableCell(
    String text,
  ) {
    return pw.Padding(
      padding:
          const pw.EdgeInsets.all(7),
      child: pw.Text(text),
    );
  }

  // ============================================================
  // DOWNLOAD RECEIPT
  // ============================================================

  Future<void> _downloadReceipt(
    BuildContext context,
  ) async {
    try {
      final bytes =
          await _buildReceiptPdf();

      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name:
            'Kota_AI_Receipt_${order.orderNumber}.pdf',
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Unable to create receipt: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // SHARE RECEIPT
  // ============================================================

  Future<void> _shareReceipt(
    BuildContext context,
  ) async {
    try {
      final bytes =
          await _buildReceiptPdf();

      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'Kota_AI_Receipt_${order.orderNumber}.pdf',
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Unable to share receipt: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Order Receipt"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ==================================================
              // SUCCESS HEADER
              // ==================================================

              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons
                          .check_circle_rounded,
                      color: Colors.green,
                      size: 90,
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    const Text(
                      "Payment Successful",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      "Thank you for your order!",
                      style: TextStyle(
                        color: Colors
                            .grey
                            .shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              // ==================================================
              // ORDER DETAILS
              // ==================================================

              buildSectionTitle(
                "Order Details",
              ),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    children: [
                      infoTile(
                        "Order Number",
                        order.orderNumber,
                      ),
                      infoTile(
                        "Date",
                        formattedDate,
                      ),
                      infoTile(
                        "Payment",
                        paymentMethod,
                      ),
                      infoTile(
                        "Status",
                        paymentStatus,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // ==================================================
              // CUSTOMER
              // ==================================================

              buildSectionTitle(
                "Customer",
              ),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    children: [
                      infoTile(
                        "Name",
                        order.customerName,
                      ),
                      infoTile(
                        "Phone",
                        order.phone,
                      ),
                      infoTile(
                        "Delivery",
                        order.delivery
                            ? "Yes"
                            : "Collection",
                      ),
                      if (order.delivery)
                        infoTile(
                          "Address",
                          order.address,
                        ),
                      if (order.notes
                          .isNotEmpty)
                        infoTile(
                          "Notes",
                          order.notes,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // ==================================================
              // ITEMS
              // ==================================================

              buildSectionTitle(
                "Items",
              ),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    12,
                  ),
                  child: Column(
                    children: order.items
                        .map(
                          (item) =>
                              ListTile(
                            contentPadding:
                                EdgeInsets
                                    .zero,
                            leading:
                                const Icon(
                              Icons.fastfood,
                            ),
                            title: Text(
                              item.ingredient
                                  .name,
                            ),
                            subtitle:
                                Text(
                              "Qty ${item.quantity}",
                            ),
                            trailing:
                                Text(
                              "R${item.subtotal.toStringAsFixed(2)}",
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // ==================================================
              // TOTALS
              // ==================================================

              buildSectionTitle(
                "Totals",
              ),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    18,
                  ),
                  child: Column(
                    children: [
                      totalRow(
                        "Subtotal",
                        order.subtotal,
                      ),
                      totalRow(
                        "Discount",
                        order.discount,
                        color:
                            Colors.green,
                      ),
                      totalRow(
                        "Delivery",
                        order.deliveryFee,
                      ),
                      const Divider(
                        height: 30,
                      ),
                      totalRow(
                        "TOTAL PAID",
                        order.total,
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // ==================================================
              // PAYMENT INFORMATION
              // ==================================================

              buildSectionTitle(
                "Payment Information",
              ),

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  child: Column(
                    children: [
                      infoTile(
                        "Payment Method",
                        paymentMethod,
                      ),
                      infoTile(
                        "Payment Status",
                        paymentStatus,
                      ),
                      if (order.paypalOrderId
                          .isNotEmpty)
                        infoTile(
                          "PayPal Order ID",
                          order.paypalOrderId,
                        ),
                      if (order.paypalCaptureId
                          .isNotEmpty)
                        infoTile(
                          "Capture ID",
                          order.paypalCaptureId,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 35,
              ),

              // ==================================================
              // CONFIRMED
              // ==================================================

              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const Icon(
                        Icons.verified,
                        color:
                            Colors.green,
                        size: 32,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: const [
                            Text(
                              "Order Confirmed",
                              style:
                                  TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "We've received your payment successfully. Your order is now being prepared.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              // ==================================================
              // CONTINUE HOME
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 55,
                child: FilledButton.icon(
                  icon: const Icon(
                    Icons.home,
                  ),
                  label: const Text(
                    "Continue Shopping",
                  ),
                  onPressed: () {
                    context.go('/home');
                  },
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // ==================================================
              // DOWNLOAD RECEIPT
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 55,
                child:
                    OutlinedButton.icon(
                  icon: const Icon(
                    Icons.picture_as_pdf,
                  ),
                  label: const Text(
                    "Download Receipt",
                  ),
                  onPressed: () {
                    _downloadReceipt(
                      context,
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // ==================================================
              // SHARE RECEIPT
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 55,
                child:
                    OutlinedButton.icon(
                  icon: const Icon(
                    Icons.share,
                  ),
                  label: const Text(
                    "Share Receipt",
                  ),
                  onPressed: () {
                    _shareReceipt(
                      context,
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              Center(
                child: Text(
                  "Thank you for choosing Kota AI!",
                  style: TextStyle(
                    color:
                        Colors.grey.shade600,
                    fontStyle:
                        FontStyle.italic,
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}