import 'package:flutter/material.dart';

import '../ai/models/discount_display.dart';
import '../core/responsive/responsive.dart';

class SmartDiscountBar extends StatelessWidget {
  final DiscountDisplay display;

  const SmartDiscountBar({
    super.key,
    required this.display,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return _desktop(context);
    }

    if (Responsive.isTablet(context)) {
      return _tablet(context);
    }

    return _mobile(context);
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _mobile(BuildContext context) {
    /*
     * Mobile is intentionally a HEADER rather than a card.
     *
     * We only show:
     *
     *   ✨ Offer title
     *   SAVE Rxx
     *   xx%
     *
     * plus a very thin progress indicator.
     *
     * This keeps the Kota builder as the main visual focus.
     */

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff202020),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white10,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ======================================================
          // OFFER HEADER
          // ======================================================

          Row(
            children: [
              // Small icon
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.withOpacity(.12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.orange,
                  size: 14,
                ),
              ),

              const SizedBox(width: 7),

              // Offer title
              Expanded(
                child: Text(
                  display.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Savings
              if (display.savings > 0)
                Text(
                  "SAVE R${display.savings.toStringAsFixed(0)}",
                  maxLines: 1,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),

              const SizedBox(width: 8),

              // Discount percentage
              Text(
                "${display.percentage.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // ======================================================
          // THIN PROGRESS BAR
          // ======================================================

          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: display.progress.clamp(0.0, 1.0),
              minHeight: 3,
              backgroundColor: Colors.white10,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TABLET
  // ============================================================

  Widget _tablet(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 700,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xff202020),
            border: Border.all(
              color: Colors.white10,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Colors.orange,
                    size: 19,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      display.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  if (display.savings > 0) ...[
                    Text(
                      "Save R${display.savings.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],

                  Text(
                    "${display.percentage.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: display.progress.clamp(0.0, 1.0),
                  minHeight: 5,
                  backgroundColor: Colors.white12,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      display.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    display.remaining <= 0
                        ? "🎉 Unlocked!"
                        : "R${display.remaining.toStringAsFixed(0)} to reward",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _desktop(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 850,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0xff202020),
            border: Border.all(
              color: Colors.white10,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Colors.orange,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      display.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),

                  Text(
                    "${display.percentage.toStringAsFixed(0)}%",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                display.subtitle,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 18),

              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: display.progress.clamp(0.0, 1.0),
                  minHeight: 14,
                  backgroundColor: Colors.white12,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(
                    Colors.orange,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _valueCard(
                    "You Save",
                    "R${display.savings.toStringAsFixed(2)}",
                    Colors.orange,
                    28,
                    CrossAxisAlignment.start,
                  ),
                  _valueCard(
                    "Discount",
                    "${display.percentage.toStringAsFixed(0)}%",
                    Colors.white,
                    28,
                    CrossAxisAlignment.end,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      color: Colors.orange,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        display.reward,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Text(
                display.remaining <= 0
                    ? "🎉 Reward unlocked!"
                    : "Spend R${display.remaining.toStringAsFixed(2)} more to unlock your reward",
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DESKTOP VALUE CARD
  // ============================================================

  Widget _valueCard(
    String label,
    String value,
    Color color,
    double valueSize,
    CrossAxisAlignment alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}