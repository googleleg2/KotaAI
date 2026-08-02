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
        final size = constraints.biggest;

        return Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 420,
              height: 480,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const DropBread(),

                  IngredientStack(
                    ingredients: scene.stack,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}