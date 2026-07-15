import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/ingredient.dart';
import '../controllers/kota_scene_controller.dart';
import 'bread_layer.dart';

class DropBread extends StatefulWidget {
  const DropBread({super.key});

  @override
  State<DropBread> createState() => _DropBreadState();
}

class _DropBreadState extends State<DropBread> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final scene = context.read<KotaSceneController>();

    return DragTarget<Ingredient>(
      onWillAcceptWithDetails: (_) {
        setState(() => hovering = true);
        return true;
      },
      onLeave: (_) {
        setState(() => hovering = false);
      },
      onAcceptWithDetails: (details) {
        setState(() => hovering = false);

        scene.addIngredient(details.data);
      },
      builder: (_, __, ___) {
        return BreadLayer(
          hovering: hovering,
        );
      },
    );
  }
}