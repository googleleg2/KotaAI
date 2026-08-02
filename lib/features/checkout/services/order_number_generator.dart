import 'package:intl/intl.dart';

class OrderNumberGenerator {
  const OrderNumberGenerator();

  String generate() {
    final now = DateTime.now();

    final date =
        DateFormat("yyyyMMddHHmmss")
            .format(now);

    return "KD-$date";
  }
}