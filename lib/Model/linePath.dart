import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:game_of_trees/Model/Node.dart';
import 'package:game_of_trees/gameState.dart';
import 'package:game_of_trees/nodeGame.dart';
import 'package:game_of_trees/util.dart';

class LinePath extends PositionComponent
    with TapCallbacks, HasGameRef<NodeGame> {
  final Offset startPosition;
  final Offset endPosition;
  late Vector2 startPositionGrid;
  late Vector2 endPositionGrid;
  final Rect finalRect;
  final double angle;
  late final Paint mainPaint;
  final GameState state;
  int lastTapDown = 0;

  LinePath({
    required this.startPosition,
    required this.endPosition,
    required this.finalRect,
    required this.state,
    required this.angle,
  }) : super(
          position: getStartPosition(angle, startPosition),
          size: Vector2(finalRect.size.width, finalRect.size.height),
          angle: angle,
        ) {
    startPositionGrid = state.unitSystem.pixelToGrid(startPosition.toVector2());
    endPositionGrid = state.unitSystem.pixelToGrid(endPosition.toVector2());
  }

  @override
  FutureOr<void>? onLoad() {
    mainPaint = Paint();
    mainPaint.color = getRandomColor().withOpacity(0.8);
    mainPaint.strokeWidth = 5.0;

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawRect(size.toRect(), mainPaint);
  }

  @override
  bool onTapDown(_) {
    var now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastTapDown < 400) {
      gameRef.listOfComponents.remove(this);
      gameRef.eventList.remove(this);
      Node startNode = gameRef.listOfNodes
          .where((element) => element.positionOnGrid == this.startPositionGrid)
          .first;
      Node endNode = gameRef.listOfNodes
          .where((element) => element.positionOnGrid == this.endPositionGrid)
          .first;
      gameRef.removeEdgeBetween(startNode.label, endNode.label);
      gameRef.removeEdgeBetween(endNode.label, startNode.label);
      removeFromParent();
    }
    lastTapDown = now;

    return true;
  }
}

// if its a horizontal line, you need to move the start position (Y axis) up by half the width of the line.
// if it is a vertical line, you need to move the start position (X axis) to the right by half the width of the line.
// if it a diagonal line, there are two scenarios ->
// if its going from top to bottom then you need to add quarter of the width to the X position, and remove quarter from the Y position.
// if its going from bottom to top then you need to subtract 3/4 of the width to the X position, and remove quarter from the Y position.

// bottom to top:
// Vector2(startPosition.dx + (startPosition.dx * angle / 100), startPosition.dy + (startPosition.dy * angle / 100))
