import 'package:flutter/material.dart';

class BreadLayer extends StatelessWidget {
  final bool hovering;

  const BreadLayer({
    super.key,
    required this.hovering,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutBack,
      scale: hovering ? 1.03 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: hovering
                  ? Colors.orange.withOpacity(.4)
                  : Colors.transparent,
              blurRadius: 35,
              spreadRadius: 8,
            ),
          ],
        ),
        child: Image.asset(
          "assets/images/kota_base.png",
          width: 340,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}