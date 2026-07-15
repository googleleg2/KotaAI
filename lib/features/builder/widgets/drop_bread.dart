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
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final scene = context.watch<KotaSceneController>();

    return DragTarget<Ingredient>(
      onWillAcceptWithDetails: (_) {
        setState(() {
          _hovering = true;
        });
        return true;
      },
      onLeave: (_) {
        setState(() {
          _hovering = false;
        });
      },
      onAcceptWithDetails: (details) {
        setState(() {
          _hovering = false;
        });

        scene.addIngredient(details.data);
      },
      builder: (_, candidate, rejected) {
        return SizedBox(
          width: 380,
          height: 420,
          child: Stack(
            alignment: Alignment.center,
            children: [
              BreadLayer(
                hovering: _hovering,
              ),

              if (scene.isEmpty)
                const Positioned(
                  top: 15,
                  child: Text(
                    "Drag ingredients here",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}