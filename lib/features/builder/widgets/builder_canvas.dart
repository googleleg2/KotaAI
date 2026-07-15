import 'package:flutter/material.dart';
import 'package:kota_ai/features/builder/widgets/drop_bread.dart';
import 'package:provider/provider.dart';

// import '../../../controllers/kota_scene_controller.dart';
// import '../../../widgets/drop_bread.dart';
import '../controllers/kota_scene_controller.dart';
import 'ingredient_stack.dart';

class BuilderCanvas extends StatelessWidget {
  const BuilderCanvas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scene = context.watch<KotaSceneController>();

    return SizedBox(
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
    );
  }
}