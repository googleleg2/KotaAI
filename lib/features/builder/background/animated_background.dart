import 'dart:math';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() =>
      _AnimatedBackgroundState();
}

class _AnimatedBackgroundState
    extends State<AnimatedBackground>
    with TickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
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

        final t = _controller.value * 2 * pi;

        return Container(

          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),

          child: Stack(

            children: [

              Positioned(
                left: 60 + sin(t) * 40,
                top: 100,
                child: _blob(
                  240,
                  Colors.deepOrange.withOpacity(.16),
                ),
              ),

              Positioned(
                right: 40,
                bottom: 140 + cos(t) * 45,
                child: _blob(
                  180,
                  Colors.orange.withOpacity(.12),
                ),
              ),

              Positioned(
                left: -70,
                bottom: -50,
                child: _blob(
                  320,
                  Colors.amber.withOpacity(.08),
                ),
              ),

              widget.child,
            ],
          ),
        );
      },
    );
  }

  Widget _blob(
    double size,
    Color color,
  ) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 90,
              spreadRadius: 35,
            ),
          ],
        ),
      ),
    );
  }
}