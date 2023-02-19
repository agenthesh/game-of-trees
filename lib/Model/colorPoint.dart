import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_of_trees/gameState.dart';

class ColorPoint extends PositionComponent {
  final Vector2 gridPosition;
  late final Vector2 pixelPosition;
  late final Paint mainPaint;
  final String label;
  final GameState state;

  ColorPoint(
      {required this.gridPosition, required this.state, required this.label});

  @override
  FutureOr<void>? onLoad() {
    mainPaint = Paint();
    mainPaint.color = Colors.yellow;
    pixelPosition = state.unitSystem.gridToPixelFrom(vector: gridPosition);
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawCircle(
      pixelPosition.toOffset(),
      state.unitSystem.gridCellGap / 4,
      mainPaint,
    );
  }
}
