import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../models/ingredient.dart';

class DragIngredient extends StatefulWidget {
  final Ingredient ingredient;

  const DragIngredient({
    super.key,
    required this.ingredient,
  });

  @override
  State<DragIngredient> createState() =>
      _DragIngredientState();
}

class _DragIngredientState
    extends State<DragIngredient> {

  bool _dragging = false;

  @override
  Widget build(BuildContext context) {

    return LongPressDraggable<Ingredient>(

      data: widget.ingredient,

      onDragStarted: () {
        setState(() {
          _dragging = true;
        });
      },

      onDragEnd: (_) {
        setState(() {
          _dragging = false;
        });
      },

      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.15,
          child: _ingredientCard(
            dragging: true,
          ),
        ),
      ),

      childWhenDragging: Opacity(
        opacity: .30,
        child: _ingredientCard(),
      ),

      child: AnimatedScale(
        duration:
            const Duration(milliseconds: 180),
        scale: _dragging ? 0.95 : 1,
        child: _ingredientCard(),
      ),
    );
  }

  Widget _ingredientCard({
    bool dragging = false,
  }) {
    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 180),
      width: 90,
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff2B2B2B),
            Color(0xff1A1A1A),
          ],
        ),
        border: Border.all(
          color: dragging
              ? AppColors.primary
              : Colors.white12,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: dragging
                ? AppColors.primary.withOpacity(.45)
                : Colors.black45,
            blurRadius: dragging ? 35 : 12,
            spreadRadius: dragging ? 6 : 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,
        children: [

          /// Temporary Placeholder
          Hero(
            tag: widget.ingredient.id,
            child: Image.asset(
              widget.ingredient.imagePath,
              width: 64,
              height: 64,
              fit: BoxFit.contain,
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: Text(
              widget.ingredient.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),

          Text(
            "R${widget.ingredient.price.toStringAsFixed(0)}",
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}