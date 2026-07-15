import 'dart:math';

import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../models/ingredient.dart';

class DragIngredient extends StatefulWidget {
  final Ingredient ingredient;

  const DragIngredient({
    super.key,
    required this.ingredient,
  });

  @override
  State<DragIngredient> createState() =>
      _DragIngredientState();
}

class _DragIngredientState
    extends State<DragIngredient>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  bool dragging = false;

  bool hovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(

      animation: _controller,

      builder: (_, __) {

        final float =
            sin(_controller.value * 2 * pi) * 6;

        return Transform.translate(

          offset: Offset(0, float),

          child: MouseRegion(

            onEnter: (_) {
              setState(() {
                hovering = true;
              });
            },

            onExit: (_) {
              setState(() {
                hovering = false;
              });
            },

            child: LongPressDraggable<Ingredient>(

              data: widget.ingredient,

              onDragStarted: () {
                setState(() {
                  dragging = true;
                });
              },

              onDragEnd: (_) {
                setState(() {
                  dragging = false;
                });
              },

              feedback: Material(
                color: Colors.transparent,
                child: Transform.scale(
                  scale: 1.2,
                  child: _card(),
                ),
              ),

              childWhenDragging: Opacity(
                opacity: .25,
                child: _card(),
              ),

              child: AnimatedScale(

                duration: const Duration(
                  milliseconds: 180,
                ),

                scale: hovering
                    ? 1.08
                    : dragging
                        ? .95
                        : 1,

                child: _card(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _card() {

    return AnimatedContainer(

      duration: const Duration(
        milliseconds: 220,
      ),

      width: 95,

      height: 115,

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(24),

        gradient: const LinearGradient(

          colors: [

            Color(0xff2A2A2A),

            Color(0xff1A1A1A),

          ],
        ),

        border: Border.all(

          color: hovering
              ? AppColors.primary
              : Colors.white12,

          width: 1.4,
        ),

        boxShadow: [

          BoxShadow(

            color: hovering

                ? AppColors.primary
                    .withOpacity(.45)

                : Colors.black54,

            blurRadius:
                hovering ? 35 : 14,

            spreadRadius:
                hovering ? 6 : 0,

            offset: const Offset(0, 10),
          )
        ],
      ),

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,

        children: [

          Hero(

            tag: widget.ingredient.id,

            child: Image.asset(

              widget.ingredient.imagePath,

              width: 64,

              fit: BoxFit.contain,
            ),
          ),

          Text(

            widget.ingredient.name,

            style: const TextStyle(

              color: Colors.white,

              fontWeight: FontWeight.w700,

              fontSize: 12,
            ),

            textAlign: TextAlign.center,
          ),

          Text(

            "R${widget.ingredient.price.toStringAsFixed(0)}",

            style: const TextStyle(

              color: AppColors.primary,

              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}