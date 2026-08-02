class Savings {
  final double subtotal;

  final double discount;

  final double total;

  const Savings({
    required this.subtotal,
    required this.discount,
    required this.total,
  });

  double get percentage {
    if (subtotal == 0) {
      return 0;
    }

    return (discount / subtotal) * 100;
  }
}