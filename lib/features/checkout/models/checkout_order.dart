class CheckoutOrder {
  final List<dynamic> items;

  final double subtotal;

  final double discount;

  final double savings;

  final double deliveryFee;

  final double total;

  const CheckoutOrder({
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.savings,
    required this.deliveryFee,
    required this.total,
  });
}