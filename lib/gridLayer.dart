import 'package:flame/layers.dart';
import 'package:flutter/material.dart';

import 'gameState.dart';

class GridLayer extends PreRenderedLayer {
  final GameState state;
  final paint = Paint()
    ..color = Colors.grey[850]!
    ..style = PaintingStyle.stroke;

  GridLayer(this.state);

  @override
  void drawLayer() {
    //renderPlayAreaGrid();
  }

  void renderPlayAreaGrid() {
    // Draw a rectangle
    for (var y = 0; y < state.unitSystem.gridHeight; ++y) {
      for (var x = 0; x < state.unitSystem.gridWidth; ++x) {
        canvas.drawRect(
            Rect.fromLTWH(
                x * state.unitSystem.gridCellGap + state.unitSystem.playingFieldOffset.x,
                y * state.unitSystem.gridCellGap + state.unitSystem.playingFieldOffset.y,
                state.unitSystem.gridCellGap,
                state.unitSystem.gridCellGap),
            paint);
      }
    }
  }
}
