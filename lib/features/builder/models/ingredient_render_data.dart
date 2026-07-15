import 'render_layer.dart';

class IngredientRenderData {
  final double width;
  final double height;

  final double stackHeight;

  final double overhang;

  final double shadowBlur;

  final double rotationLimit;

  final RenderLayer renderLayer;

  const IngredientRenderData({
    required this.width,
    required this.height,
    required this.stackHeight,
    required this.overhang,
    required this.shadowBlur,
    required this.rotationLimit,
    required this.renderLayer,
  });
}