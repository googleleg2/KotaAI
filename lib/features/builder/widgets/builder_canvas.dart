import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/kota_scene_controller.dart';
import 'drop_bread.dart';
import 'ingredient_stack.dart';

class BuilderCanvas extends StatelessWidget {
  const BuilderCanvas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scene = context.watch<KotaSceneController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        /*
         * Use the actual constraints supplied by the parent.
         *
         * No screen-width assumptions.
         * No mobile/tablet/desktop pixel dimensions.
         */
        if (!constraints.hasBoundedWidth ||
            !constraints.hasBoundedHeight) {
          return const SizedBox.shrink();
        }

        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        if (availableWidth <= 0 ||
            availableHeight <= 0) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          width: availableWidth,
          height: availableHeight,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              /*
               * The Kota base fills the responsive builder area
               * available to it.
               *
               * BreadLayer then calculates the actual bread size
               * from these constraints.
               */
              const Positioned.fill(
                child: DropBread(),
              ),

              /*
               * Ingredients occupy the exact same coordinate
               * system as the Kota.
               *
               * IngredientStack calculates their positions from
               * the actual canvas dimensions.
               */
              Positioned.fill(
                child: IngredientStack(
                  ingredients: scene.stack,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}