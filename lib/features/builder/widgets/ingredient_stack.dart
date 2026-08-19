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
        final canvasWidth = constraints.maxWidth;
        final canvasHeight = constraints.maxHeight;

        if (canvasWidth <= 0 || canvasHeight <= 0) {
          return const SizedBox.shrink();
        }

        /*
         * ============================================================
         * 1. CALCULATE THE KOTA SIZE
         * ============================================================
         *
         * This MUST match BreadLayer.
         *
         * BreadLayer uses the smaller available dimension so that
         * the Kota always fits inside its builder area.
         */
        final shortestSide = canvasWidth < canvasHeight
            ? canvasWidth
            : canvasHeight;

        final kotaWidth = shortestSide * 0.88;

        if (kotaWidth <= 0) {
          return const SizedBox.shrink();
        }

        /*
         * ============================================================
         * 2. KOTA IMAGE HEIGHT
         * ============================================================
         *
         * The kota.png asset is rendered using:
         *
         *     width: kotaWidth
         *     fit: BoxFit.contain
         *
         * Therefore we use the asset's natural aspect ratio to
         * establish the same coordinate system.
         *
         * This is the aspect ratio of the supplied Kota asset.
         */
        const kotaAspectRatio = 680 / 435;

        final kotaHeight =
            kotaWidth / kotaAspectRatio;

        /*
         * ============================================================
         * 3. KOTA POSITION
         * ============================================================
         *
         * BreadLayer centers the Kota in its available area.
         *
         * Therefore the top of the actual Kota image is:
         */
        final kotaTop =
            (canvasHeight - kotaHeight) / 2;

        /*
         * ============================================================
         * 4. CHIP SURFACE
         * ============================================================
         *
         * The chips are already part of kota.png.
         *
         * We need the first ingredient to sit on the TOP of those
         * chips, not underneath the Kota and not below the bread.
         *
         * The chip surface is represented as a proportion of the
         * Kota image height.
         *
         * This is deliberately tied to the asset rather than the
         * screen size.
         */
        final chipSurfaceY =
            kotaTop + (kotaHeight * 0.57);

        /*
         * Convert the chip surface from a screen Y coordinate into
         * the Stack's `bottom:` coordinate system.
         */
        final stackBase =
            canvasHeight - chipSurfaceY;

        /*
         * ============================================================
         * 5. RESPONSIVE INGREDIENT WIDTH
         * ============================================================
         *
         * Ingredients are sized relative to the Kota.
         *
         * This means:
         *
         * small phone  -> smaller ingredients
         * large phone  -> larger ingredients
         * tablet       -> larger ingredients
         * desktop      -> larger ingredients
         */
        final ingredientWidth =
            kotaWidth * 0.50;

        /*
         * ============================================================
         * 6. RESPONSIVE LAYER HEIGHT
         * ============================================================
         *
         * Ingredients overlap each other naturally.
         *
         * We don't use ingredient.stackHeight anymore because that
         * was a fixed design value rather than a screen-relative
         * rendering value.
         */
        final layerHeight =
            ingredientWidth * 0.20;

        /*
         * Keep the ingredients inside the builder's usable region.
         *
         * The stack itself can extend upward because Stack uses
         * Clip.none.
         */
        return IgnorePointer(
          child: SizedBox.expand(
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                for (
                  var index = 0;
                  index < ingredients.length;
                  index++
                )
                  _buildIngredient(
                    item: ingredients[index],
                    index: index,
                    ingredientWidth: ingredientWidth,
                    layerHeight: layerHeight,
                    stackBase: stackBase,
                    canvasWidth: canvasWidth,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIngredient({
    required StackedIngredient item,
    required int index,
    required double ingredientWidth,
    required double layerHeight,
    required double stackBase,
    required double canvasWidth,
  }) {
    /*
     * ============================================================
     * STACK POSITION
     * ============================================================
     *
     * index 0:
     *
     *     ingredient sits directly on the chips.
     *
     * index 1:
     *
     *     ingredient sits above ingredient 0.
     *
     * index 2:
     *
     *     ingredient sits above ingredient 1.
     *
     * etc.
     */
    final bottomPosition =
        stackBase + (index * layerHeight);

    /*
     * The animation distance scales with the actual builder.
     */
    final animationDistance =
        canvasWidth * 0.08;

    return Positioned(
      bottom: bottomPosition,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(
          milliseconds: 350,
        ),
        curve: Curves.easeOutBack,
        tween: Tween<double>(
          begin: item.animationOffset,
          end: 0,
        ),
        builder: (
          context,
          animationValue,
          child,
        ) {
          final verticalAnimation =
              animationValue *
              (animationDistance / 40);

          return Transform.translate(
            offset: Offset(
              0,
              -verticalAnimation,
            ),
            child: Transform.scale(
              scale: item.scale,
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
          width: ingredientWidth,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}