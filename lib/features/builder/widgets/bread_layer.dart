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

    return AnimatedBuilder(

      animation: controller,

      builder: (_, __) {

        final float =
            sin(controller.value * pi * 2) * 6;

        final scale =
            widget.hovering ? 1.03 : 1.0;

        final shadow =
            26 + (sin(controller.value * pi * 2) * 6);

        return Transform.translate(

          offset: Offset(0, float),

          child: Transform.scale(

            scale: scale,

            child: Stack(

              alignment: Alignment.center,

              children: [

                Positioned(

                  bottom: 12,

                  child: AnimatedContainer(

                    duration: const Duration(
                        milliseconds: 150),

                    width: 180,

                    height: 40,

                    decoration: BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(100),

                      boxShadow: [

                        BoxShadow(

                          color:
                              Colors.black.withOpacity(.35),

                          blurRadius: shadow,

                          spreadRadius: 4,
                        )
                      ],
                    ),
                  ),
                ),

                Image.asset(
                  "assets/images/kota.png",
                  width: 340,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}