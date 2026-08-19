import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../checkout/models/customer_order.dart';
import '../../checkout/services/order_service.dart';

class BusinessOrdersScreen extends StatelessWidget {
  const BusinessOrdersScreen({
    super.key,
  });

  static const OrderService _service = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: StreamBuilder<List<CustomerOrder>>(
        stream: _service.streamOrders(),
        builder: (
          context,
          snapshot,
        ) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _buildError(
              snapshot.error.toString(),
            );
          }

          final orders =
              snapshot.data ??
                  <CustomerOrder>[];

          if (orders.isEmpty) {
            return _buildEmpty();
          }

          return LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final maxWidth =
                  constraints.maxWidth > 1250
                      ? 1250.0
                      : constraints.maxWidth;

              return Center(
                child: SizedBox(
                  width: maxWidth,
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      40,
                    ),
                    itemCount: orders.length,
                    separatorBuilder: (
                      context,
                      index,
                    ) {
                      return const SizedBox(
                        height: 12,
                      );
                    },
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      return _OrderCard(
                        order: orders[index],
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(.05),
              borderRadius:
                  BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Colors.white38,
              size: 36,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'No orders yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Orders placed by customers will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(
    String error,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 50,
            ),

            const SizedBox(height: 15),

            const Text(
              'Unable to load orders',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// ORDER CARD
// ============================================================

class _OrderCard extends StatelessWidget {
  final CustomerOrder order;

  const _OrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(22),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  BusinessOrderDetailsScreen(
                order: order,
              ),
            ),
          );
        },
        child: Container(
          padding:
              const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color:
                Colors.white.withOpacity(.045),
            borderRadius:
                BorderRadius.circular(22),
            border: Border.all(
              color:
                  Colors.white.withOpacity(.07),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color:
                          AppColors.primary
                              .withOpacity(.12),
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      color:
                          AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 13),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          '#${order.orderNumber}',
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          order.customerName
                                  .trim()
                                  .isEmpty
                              ? 'Customer'
                              : order.customerName,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _StatusBadge(
                    status:
                        order.paymentStatus,
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Divider(
                color:
                    Colors.white.withOpacity(.06),
                height: 1,
              ),

              const SizedBox(height: 13),

              Row(
                children: [
                  const Icon(
                    Icons.fastfood_rounded,
                    color: Colors.white38,
                    size: 17,
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Text(
                      _itemsSummary(),
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  Text(
                    'R${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Icon(
                    order.delivery
                        ? Icons.delivery_dining_rounded
                        : Icons.storefront_rounded,
                    color:
                        AppColors.primary,
                    size: 17,
                  ),

                  const SizedBox(width: 7),

                  Text(
                    order.delivery
                        ? 'Delivery'
                        : 'Collection',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    _formatDate(order.createdAt),
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(width: 5),

                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.white30,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _itemsSummary() {
    if (order.items.isEmpty) {
      return 'No items';
    }

    return order.items
        .map(
          (item) =>
              '${item.quantity} × ${item.ingredient.name}',
        )
        .join(', ');
  }

  String _formatDate(DateTime date) {
    final hour = date.hour % 12 == 0
        ? 12
        : date.hour % 12;

    final minute =
        date.minute.toString().padLeft(2, '0');

    final period =
        date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day}/${date.month}/${date.year} '
        '$hour:$minute $period';
  }
}


// ============================================================
// STATUS BADGE
// ============================================================

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final normalized =
        status.toLowerCase().trim();

    Color color;

    if (normalized == 'paid') {
      color = Colors.greenAccent;
    } else if (normalized == 'pending') {
      color = Colors.orangeAccent;
    } else if (normalized == 'failed') {
      color = Colors.redAccent;
    } else {
      color = Colors.white54;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius:
            BorderRadius.circular(30),
        border: Border.all(
          color: color.withOpacity(.18),
        ),
      ),
      child: Text(
        status.isEmpty ? 'Unknown' : status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}


// ============================================================
// FULL ORDER DETAILS
// ============================================================

class BusinessOrderDetailsScreen
    extends StatelessWidget {
  final CustomerOrder order;

  const BusinessOrderDetailsScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          '#${order.orderNumber}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final maxWidth =
              constraints.maxWidth > 1000
                  ? 1000.0
                  : constraints.maxWidth;

          return Center(
            child: SizedBox(
              width: maxWidth,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  40,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 18),

                    _buildCustomerSection(),

                    const SizedBox(height: 14),

                    _buildDeliverySection(),

                    const SizedBox(height: 14),

                    _buildItemsSection(),

                    const SizedBox(height: 14),

                    _buildPaymentSection(),

                    const SizedBox(height: 14),

                    _buildTotalsSection(),

                    if (order.notes
                        .trim()
                        .isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _buildNotesSection(),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(.20),
            Colors.white.withOpacity(.035),
          ],
        ),
        borderRadius:
            BorderRadius.circular(25),
        border: Border.all(
          color:
              AppColors.primary.withOpacity(.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color:
                  AppColors.primary.withOpacity(.12),
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.receipt_long_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'ORDER',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '#${order.orderNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  _formatDateTime(
                    order.createdAt,
                  ),
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          _StatusBadge(
            status: order.paymentStatus,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CUSTOMER
  // ============================================================

  Widget _buildCustomerSection() {
    return _SectionCard(
      title: 'Customer',
      icon: Icons.person_rounded,
      child: Column(
        children: [
          _DetailRow(
            label: 'Name',
            value:
                order.customerName.isEmpty
                    ? 'Not provided'
                    : order.customerName,
          ),

          _DetailRow(
            label: 'Email',
            value:
                order.customerEmail.isEmpty
                    ? 'Not provided'
                    : order.customerEmail,
          ),

          _DetailRow(
            label: 'Phone',
            value:
                order.phone.isEmpty
                    ? 'Not provided'
                    : order.phone,
          ),

          _DetailRow(
            label: 'User ID',
            value:
                order.userId.isEmpty
                    ? 'Not available'
                    : order.userId,
            last: true,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERY
  // ============================================================

  Widget _buildDeliverySection() {
    return _SectionCard(
      title: order.delivery
          ? 'Delivery'
          : 'Collection',
      icon: order.delivery
          ? Icons.delivery_dining_rounded
          : Icons.storefront_rounded,
      child: Column(
        children: [
          _DetailRow(
            label: 'Order type',
            value: order.delivery
                ? 'Delivery'
                : 'Collection',
          ),

          if (order.delivery)
            _DetailRow(
              label: 'Address',
              value:
                  order.address.isEmpty
                      ? 'No address provided'
                      : order.address,
            ),

          _DetailRow(
            label: 'Notes',
            value:
                order.notes.isEmpty
                    ? 'No delivery notes'
                    : order.notes,
            last: true,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ITEMS
  // ============================================================

  Widget _buildItemsSection() {
    return _SectionCard(
      title: 'Order Items',
      icon: Icons.fastfood_rounded,
      child: Column(
        children: [
          if (order.items.isEmpty)
            const Padding(
              padding:
                  EdgeInsets.all(10),
              child: Text(
                'No items recorded.',
                style: TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),

          for (
            var index = 0;
            index < order.items.length;
            index++
          ) ...[
            _buildItemRow(
              order.items[index],
            ),

            if (index <
                order.items.length - 1)
              Divider(
                color:
                    Colors.white.withOpacity(.06),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemRow(
    dynamic item,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 9,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  AppColors.primary.withOpacity(.09),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.fastfood_rounded,
              color: Colors.orange,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.ingredient.name,
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'R${item.ingredient.price.toStringAsFixed(2)} each',
                  style:
                      const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '× ${item.quantity}',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(width: 15),

          Text(
            'R${item.subtotal.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT
  // ============================================================

  Widget _buildPaymentSection() {
    return _SectionCard(
      title: 'Payment',
      icon: Icons.payments_rounded,
      child: Column(
        children: [
          _DetailRow(
            label: 'Payment status',
            value:
                order.paymentStatus,
          ),

          _DetailRow(
            label: 'Payment method',
            value:
                order.paymentMethod,
          ),

          _DetailRow(
            label: 'PayPal Order ID',
            value:
                order.paypalOrderId.isEmpty
                    ? 'Not available'
                    : order.paypalOrderId,
          ),

          _DetailRow(
            label: 'PayPal Capture ID',
            value:
                order.paypalCaptureId.isEmpty
                    ? 'Not available'
                    : order.paypalCaptureId,
            last: true,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TOTALS
  // ============================================================

  Widget _buildTotalsSection() {
    return _SectionCard(
      title: 'Order Summary',
      icon: Icons.receipt_rounded,
      child: Column(
        children: [
          _DetailRow(
            label: 'Subtotal',
            value:
                'R${order.subtotal.toStringAsFixed(2)}',
          ),

          _DetailRow(
            label: 'Discount',
            value:
                '- R${order.discount.toStringAsFixed(2)}',
          ),

          _DetailRow(
            label: 'Delivery fee',
            value:
                'R${order.deliveryFee.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          Divider(
            color:
                Colors.white.withOpacity(.08),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'TOTAL',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
              ),

              Text(
                'R${order.total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NOTES
  // ============================================================

  Widget _buildNotesSection() {
    return _SectionCard(
      title: 'Customer Notes',
      icon: Icons.notes_rounded,
      child: Text(
        order.notes,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          height: 1.5,
        ),
      ),
    );
  }

  String _formatDateTime(
    DateTime date,
  ) {
    final hour =
        date.hour % 12 == 0
            ? 12
            : date.hour % 12;

    final minute =
        date.minute
            .toString()
            .padLeft(2, '0');

    final period =
        date.hour >= 12
            ? 'PM'
            : 'AM';

    return '${date.day}/${date.month}/${date.year} '
        '$hour:$minute $period';
  }
}


// ============================================================
// SECTION CARD
// ============================================================

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(.04),
        borderRadius:
            BorderRadius.circular(21),
        border: Border.all(
          color:
              Colors.white.withOpacity(.06),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color:
                      AppColors.primary
                          .withOpacity(.10),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color:
                      AppColors.primary,
                  size: 20,
                ),
              ),

              const SizedBox(width: 11),

              Text(
                title,
                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }
}


// ============================================================
// DETAIL ROW
// ============================================================

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool last;

  const _DetailRow({
    required this.label,
    required this.value,
    this.last = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}