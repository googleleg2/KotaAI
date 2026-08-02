import 'dart:math';

import 'package:flutter/material.dart';

class BreadLayer extends StatefulWidget {
  final bool hovering;

  const BreadLayer({
    super.key,
    required this.hovering,
  });

  @override
  State<BreadLayer> createState() => _BreadLayerState();
}

class _BreadLayerState extends State<BreadLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Responsive bread width
        final breadWidth = (availableWidth * 0.82).clamp(260.0, 420.0);

        final shadowWidth = breadWidth * 0.55;
        final shadowHeight = breadWidth * 0.12;

        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final wave =
                sin(controller.value * pi * 2);

            final floating = wave * 6;

            final scale =
                widget.hovering ? 1.03 : 1.0;

            final blur =
                26 + (wave * 6);

            return Transform.translate(
              offset: Offset(0, floating),
              child: Transform.scale(
                scale: scale,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: 12,
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 150,
                        ),
                        width: shadowWidth,
                        height: shadowHeight,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.35),
                              blurRadius: blur,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Image.asset(
                      "assets/images/kota.png",
                      width: breadWidth,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}