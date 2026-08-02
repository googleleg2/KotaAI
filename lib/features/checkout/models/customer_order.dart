class CustomerOrder {
  final String orderNumber;

  final String customerName;

  final String phone;

  final bool delivery;

  final String address;

  final String notes;

  final List<dynamic> items;

  final double subtotal;

  final double discount;

  final double deliveryFee;

  final double total;

  final DateTime createdAt;

  const CustomerOrder({
    required this.orderNumber,
    required this.customerName,
    required this.phone,
    required this.delivery,
    required this.address,
    required this.notes,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
  });
}