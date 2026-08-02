import 'package:flutter/material.dart';

import '../models/stacked_ingredient.dart';

class IngredientStack extends StatelessWidget {
  final List<StackedIngredient> ingredients;

  const IngredientStack({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 420 is our original design width
        final scale =
            (constraints.maxWidth / 420).clamp(0.75, 1.35);

        return IgnorePointer(
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: List.generate(
              ingredients.length,
              (index) {
                final item = ingredients[index];

                return Positioned(
                  bottom: item.yOffset * scale,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(
                      milliseconds: 350,
                    ),
                    curve: Curves.easeOutBack,
                    tween: Tween(
                      begin: item.animationOffset,
                      end: 0,
                    ),
                    builder: (
                      context,
                      value,
                      child,
                    ) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          -value * scale,
                        ),
                        child: Transform.scale(
                          scale: item.scale * scale,
                          child: child,
                        ),
                      );
                    },
                    onEnd: () {
                      item.animationOffset = 0;
                      item.scale = 1;
                    },
                    child: Image.asset(
                      item.ingredient.imagePath,
                      width:
                          item.ingredient.width * scale,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}