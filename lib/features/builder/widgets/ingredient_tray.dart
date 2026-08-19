import 'package:flutter/material.dart';

import '../../../core/responsive/responsive.dart';
import '../../../models/ingredient.dart';
import 'drag_ingredient.dart';

class IngredientTray extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientTray({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return _desktopTray(context);
    }

    if (Responsive.isTablet(context)) {
      return _tabletTray(context);
    }

    return _mobileTray(context);
  }

  Widget _mobileTray(BuildContext context) {
  return SizedBox.expand(
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: ingredients.length,
      separatorBuilder: (_, __) {
        return const SizedBox(width: 10);
      },
      itemBuilder: (_, index) {
        return Center(
          child: DragIngredient(
            ingredient: ingredients[index],
          ),
        );
      },
    ),
  );
}

  Widget _tabletTray(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: ingredients.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 24),
        itemBuilder: (_, index) {
          return DragIngredient(
            ingredient: ingredients[index],
          );
        },
      ),
    );
  }

  Widget _desktopTray(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: ingredients.length,
        gridDelegate:
            const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 170,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
          childAspectRatio: .82,
        ),
        itemBuilder: (_, index) {
          return DragIngredient(
            ingredient: ingredients[index],
          );
        },
      ),
    );
  }
}