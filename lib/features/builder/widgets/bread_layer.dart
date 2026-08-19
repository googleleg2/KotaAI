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
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        if (width <= 0 || height <= 0) {
          return const SizedBox.shrink();
        }

        /*
         * ============================================================
         * RESPONSIVE KOTA SIZE
         * ============================================================
         *
         * IMPORTANT:
         *
         * On a phone the builder is normally much narrower than it
         * is tall. Therefore the Kota should primarily be controlled
         * by WIDTH.
         *
         * Using min(width, height) here caused the Kota to shrink
         * whenever the vertical builder area became constrained.
         */

        final widthBasedSize = width * 0.88;

        /*
         * The Kota should never be wider than the actual area
         * available to it.
         */
        final breadWidth = min(
          widthBasedSize,
          width,
        );

        if (breadWidth <= 0) {
          return const SizedBox.shrink();
        }

        /*
         * ============================================================
         * RESPONSIVE DIMENSIONS
         * ============================================================
         */

        final shadowWidth = breadWidth * 0.55;
        final shadowHeight = breadWidth * 0.11;

        final floatingDistance = breadWidth * 0.012;

        final shadowBottom = breadWidth * 0.025;

        final blur = breadWidth * 0.055;

        final spread = breadWidth * 0.008;

        /*
         * Hover animation.
         */
        final hoverScale = widget.hovering ? 1.025 : 1.0;

        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            final wave = sin(
              controller.value * pi * 2,
            );

            final floating =
                wave * floatingDistance;

            return Center(
              child: Transform.translate(
                offset: Offset(
                  0,
                  floating,
                ),
                child: Transform.scale(
                  scale: hoverScale,
                  child: SizedBox(
                    width: breadWidth,
                    height: height,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        /*
                         * ==================================================
                         * SHADOW
                         * ==================================================
                         */

                        Positioned(
                          bottom: shadowBottom,
                          child: SizedBox(
                            width: shadowWidth,
                            height: shadowHeight,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(
                                  breadWidth,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(.35),
                                    blurRadius: blur,
                                    spreadRadius: spread,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /*
                         * ==================================================
                         * KOTA BASE
                         * ==================================================
                         *
                         * Width is responsive to the actual canvas.
                         *
                         * We DO NOT use a fixed width.
                         */

                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/kota.png',
                            width: breadWidth,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}