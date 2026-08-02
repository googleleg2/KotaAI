import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/ingredient.dart';
import '../controllers/kota_scene_controller.dart';
import 'bread_layer.dart';

class DropBread extends StatefulWidget {
  const DropBread({
    super.key,
  });

  @override
  State<DropBread> createState() =>
      _DropBreadState();
}

class _DropBreadState extends State<DropBread> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final scene =
        context.read<KotaSceneController>();

    return DragTarget<Ingredient>(
      onWillAcceptWithDetails: (_) {
        setState(() {
          hovering = true;
        });

        return true;
      },

      onLeave: (_) {
        setState(() {
          hovering = false;
        });
      },

      onAcceptWithDetails: (details) {
        setState(() {
          hovering = false;
        });

        scene.addIngredient(details.data);
      },

      builder: (context, candidateData, rejectedData) {
        return AnimatedScale(
          duration: const Duration(
            milliseconds: 180,
          ),
          scale: hovering ? 1.03 : 1.0,
          child: AnimatedOpacity(
            duration: const Duration(
              milliseconds: 180,
            ),
            opacity: hovering ? 0.95 : 1,
            child: BreadLayer(
              hovering: hovering,
            ),
          ),
        );
      },
    );
  }
}