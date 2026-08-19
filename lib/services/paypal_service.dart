import 'dart:convert';
// import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:web/web.dart' as web;

class PayPalService {
  const PayPalService();

  static const String baseUrl =
      "https://us-central1-kota-discount.cloudfunctions.net";

  /// Creates a PayPal order and redirects
  /// the browser to the PayPal approval page.
  Future<String> startCheckout({
    required String orderNumber,
    required double total,
    required List<Map<String, dynamic>> items,
  }) async {
    final response = await http.post(
      Uri.parse(
        "$baseUrl/createPaypalOrder",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "orderNumber": orderNumber,
        "total": total,
        "currency": "USD",
        "items": items,
      }),
    );

    final data =
        jsonDecode(response.body)
            as Map<String, dynamic>;

    if (response.statusCode != 200 ||
        data["success"] != true) {
      throw Exception(
        data["error"] ??
            "Unable to create PayPal order.",
      );
    }

    final approvalUrl =
        data["approvalUrl"] as String?;

    final orderId =
        data["orderId"] as String?;

    if (approvalUrl == null ||
        approvalUrl.isEmpty) {
      throw Exception(
        "Missing PayPal approval URL.",
      );
    }

    if (orderId == null ||
        orderId.isEmpty) {
      throw Exception(
        "Missing PayPal order ID.",
      );
    }

    // final uri = Uri.parse(approvalUrl);

    // final opened = await launchUrl(
    //   uri,
    //   mode: LaunchMode.platformDefault,
    // );

    // if (!opened) {
    //   throw Exception(
    //     "Could not open PayPal.",
    //   );
    // }

    web.window.location.href = approvalUrl;

    return orderId;
  }

  /// Captures PayPal payment after redirect
  Future<Map<String, dynamic>> captureOrder({
    required String orderNumber,
    required String paypalOrderId,
  }) async {
    final response = await http.post(
      Uri.parse(
        "$baseUrl/capturePaypalOrder",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "orderNumber": orderNumber,
        "orderId": paypalOrderId,
      }),
    );

    final data =
        jsonDecode(response.body)
            as Map<String, dynamic>;

    if (response.statusCode != 200 ||
        data["success"] != true) {
      throw Exception(
        data["error"] ??
            "Unable to capture payment.",
      );
    }

    return data;
  }
}