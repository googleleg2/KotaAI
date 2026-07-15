import '../models/render_layer.dart';
import '../models/ingredient_render_data.dart';

class RenderPresets {

  static const cheese = IngredientRenderData(
    width: 240,
    height: 28,
    stackHeight: 8,
    overhang: 26,
    shadowBlur: 10,
    rotationLimit: 3,
    renderLayer: RenderLayer.ingredientFront,
  );

  static const egg = IngredientRenderData(
    width: 250,
    height: 42,
    stackHeight: 12,
    overhang: 18,
    shadowBlur: 12,
    rotationLimit: 2,
    renderLayer: RenderLayer.ingredientCenter,
  );

}