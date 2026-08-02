import 'dart:convert';

import 'package:http/http.dart' as http;

class PaypalService {
  static const String _baseUrl =
      'http://127.0.0.1:5001/kota-discount/us-central1';

  Future<Map<String, dynamic>> createOrder() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/createPaypalOrder'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    return jsonDecode(response.body);
  }
}