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
    final desktop = Responsive.isDesktop(context);
    final tablet = Responsive.isTablet(context);

    final maxWidth = desktop
        ? 850.0
        : tablet
            ? 700.0
            : double.infinity;

    final titleSize = desktop
        ? 22.0
        : tablet
            ? 20.0
            : 18.0;

    final valueSize = desktop
        ? 28.0
        : tablet
            ? 26.0
            : 24.0;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
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
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: titleSize,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                display.subtitle,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: desktop ? 16 : 14,
                ),
              ),

              const SizedBox(height: 20),

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: display.progress,
                  minHeight: desktop ? 14 : 12,
                  backgroundColor: Colors.white12,
                  valueColor:
                      const AlwaysStoppedAnimation(
                    Colors.orange,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  final compact =
                      constraints.maxWidth < 450;

                  if (compact) {
                    return Column(
                      children: [
                        _valueCard(
                          "You Save",
                          "R${display.savings.toStringAsFixed(2)}",
                          Colors.orange,
                          valueSize,
                          CrossAxisAlignment.start,
                        ),

                        const SizedBox(height: 18),

                        _valueCard(
                          "Discount",
                          "${display.percentage.toStringAsFixed(0)}%",
                          Colors.white,
                          valueSize,
                          CrossAxisAlignment.start,
                        ),
                      ],
                    );
                  }

                  return Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      _valueCard(
                        "You Save",
                        "R${display.savings.toStringAsFixed(2)}",
                        Colors.orange,
                        valueSize,
                        CrossAxisAlignment.start,
                      ),

                      _valueCard(
                        "Discount",
                        "${display.percentage.toStringAsFixed(0)}%",
                        Colors.white,
                        valueSize,
                        CrossAxisAlignment.end,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      Colors.orange.withOpacity(.12),
                  borderRadius:
                      BorderRadius.circular(14),
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
                          fontWeight:
                              FontWeight.bold,
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