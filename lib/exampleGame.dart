import 'dart:math';
import 'dart:ui';

//import 'package:extended_math/extended_math.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:mazeball2021/Node.dart';
import 'package:mazeball2021/colorPoint.dart';
import 'package:flame/game.dart';
import 'package:directed_graph/directed_graph.dart';

import 'gameState.dart';
import 'gridLayer.dart';
import 'unitSystem.dart';

class ExampleGame extends FlameGame
    with HasDraggableComponents, HasTappableComponents {
  late GameState state;
  GridLayer? gridLayer;
  List<Path> listOfPaths = [];
  Path? tempPath;
  List<Vector2> nodePositions = [];
  List<ColorPoint> componentList = [];
  bool isMovable = false;
  List<Node> listOfNodes = [];
  Vector2? lastDragPosition;
  Vector2? lastDragStart;
  Map<Node, List<Node>> graphTree = {};
  int counter = 0;
  List<String> nodeNames = ['A', 'B', 'C', 'D', 'E'];
  Map<Node, Set<Node>> newDirectedGraph = {};
  DirectedGraph<Node>? graph;
  //Matrix incidenceMatrix = Matrix.generate(5, 5);

  final Paint debugPaint = Paint()
    ..color = Colors.pink
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //renderNodes(5);
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    state = GameState(
        UnitSystem(canvasSize.y, canvasSize.x, playingFieldToScreenRatio: 0.9));
    gridLayer = GridLayer(state);
  }

  Path getLineBetween(Vector2 startPoint, Vector2 endPoint) {
    // final gridPath = AStar(
    //   rows: GRID_HEIGHT + 1,
    //   columns: GRID_WIDTH + 1,
    //   start: startPoint.toOffset(),
    //   end: endPoint.toOffset(),
    //   barriers: [], //Add points here to prevent the path passing
    // ).findThePath().reversed.toList();

    final start = state.unitSystem.gridToPixelFrom(vector: startPoint);

    final newPath = Path();
    newPath.moveTo(start.x, start.y);

    // gridPath
    //     .map((pathFindingOffset) =>
    //         state.unitSystem.gridToPixelFrom(offset: pathFindingOffset))
    //     .forEach((gridPosition) {
    //   newPath.lineTo(gridPosition.x, gridPosition.y);
    // });

    var end = state.unitSystem.gridToPixelFrom(vector: endPoint);
    newPath.lineTo(end.x, end.y);
    return newPath;
  }

  void resetElements() {
    tempPath = null;
    lastDragPosition = null;
    lastDragStart = null;
  }

  void addPointOnGrid(Vector2 point) => add(ColorPoint(point, state));

  bool insideGrid(Vector2 point) {
    if (point.x >= 0 &&
        point.y >= 0 &&
        point.x <= GRID_WIDTH &&
        point.y <= GRID_HEIGHT) {
      return true;
    }
    return false;
  }

  bool isAtNode(Vector2 point) {
    return listOfNodes.any((element) => element.positionOnGrid == point);
  }

  Vector2 getRandomGridPoint() {
    double randomX = Random().nextDouble() * GRID_WIDTH;
    double randomY = Random().nextDouble() * GRID_HEIGHT;
    return Vector2(randomX.truncateToDouble(), randomY.truncateToDouble());
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    if (componentList.length == 5) {
      listOfPaths.clear();
      tempPath = null;
    } else {
      if (!insideGrid(state.unitSystem.pixelToGrid(info.eventPosition.global)))
        return;
      add(ColorPoint(
          state.unitSystem.pixelToGrid(info.eventPosition.global), state));
      componentList.add(ColorPoint(info.eventPosition.global, state));

      Node tempNode = new Node(nodeNames[counter], 5,
          state.unitSystem.pixelToGrid(info.eventPosition.global));

      listOfNodes.add(tempNode);

      graphTree[tempNode] = [];
      counter++;
    }
    super.onTapUp(pointerId, info);
  }

  void onDragStart(int pointerId, DragStartInfo info) {
    super.onDragStart(pointerId, info);
    final startPointOnGrid =
        state.unitSystem.pixelToGrid(info.eventPosition.global);
    //resetElements();
    if (!insideGrid(startPointOnGrid)) return;
    if (!isAtNode(startPointOnGrid)) return;
    lastDragPosition = startPointOnGrid;
    lastDragStart = startPointOnGrid;
  }

  void onDragUpdate(int pointerId, DragUpdateInfo event) {
    super.onDragUpdate(pointerId, event);
    final nextPoint = state.unitSystem.pixelToGrid(event.eventPosition.global);
    if (!insideGrid(nextPoint) || lastDragStart == null) return;

    if (isMovable) {
      remove(componentList
          .firstWhere((element) => element.gridPosition == lastDragStart));
    } else {
      tempPath = getLineBetween(lastDragStart!, nextPoint);
      lastDragPosition = nextPoint;
    }
  }

  void onDragEnd(int pointerId, DragEndInfo event) {
    super.onDragEnd(pointerId, event);

    if (lastDragPosition != null && lastDragStart != null) {
      if (!insideGrid(lastDragPosition!)) return;

      if (isMovable) {
        add(ColorPoint(lastDragPosition!, state));
      } else {
        if (!isAtNode(lastDragPosition!)) resetElements();
        //addPointOnGrid(lastDragPosition!);
        var finalPath = getLineBetween(lastDragStart!, lastDragPosition!);
        listOfPaths.add(finalPath);

        int indexOfStartingNode = listOfNodes
            .indexWhere((element) => element.positionOnGrid == lastDragStart!);
        int indexOfEndingNode = listOfNodes.indexWhere(
            (element) => element.positionOnGrid == lastDragPosition!);

        List<Node> newValue = graphTree[listOfNodes[indexOfStartingNode]]!;

        newValue.add(listOfNodes[indexOfEndingNode]);

        graphTree.update(
          listOfNodes[indexOfStartingNode],
          (value) => newValue,
        ); //Add to the correct

        newValue = graphTree[listOfNodes[indexOfEndingNode]]!;

        newValue.add(listOfNodes[indexOfStartingNode]);

        //Add to the opposite
        graphTree.update(listOfNodes[indexOfEndingNode], (value) => newValue);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    gridLayer?.render(canvas);
    super.render(canvas);
    // if (tempPath != null) {
    //   canvas.drawPath(tempPath!, debugPaint);
    // }

    listOfPaths.forEach((element) {
      canvas.drawPath(element, debugPaint);
    });

    //canvas.drawPath(tempPath!, debugPaint);

    graphTree.forEach((key, value) {
      newDirectedGraph[key] = value.toSet();
    });

    graph = DirectedGraph(newDirectedGraph);

    print("Shortest PATH");
    print(graph!.crawler.path(listOfNodes[0], listOfNodes[1]));
    //print(graph!.topologicalOrdering);
    //print(graph!.cycle);

    // var componentsTest = stronglyConnectedComponents<Node>(
    //     graph.nodes.keys, (node) => graph.nodes[node] ?? []);

    // print(componentsTest);
  }

  // void renderNodes(int numberOfNodes) {
  //   Vector2 randomPoint;
  //   ColorPoint newPoint;

  //   for (var i = 0; i < 1; i++) {
  //     randomPoint = getRandomGridPoint();
  //     if (nodePositions.contains(randomPoint)) i--; //run loop again ;)

  //     nodePositions.add(randomPoint);
  //     newPoint = ColorPoint(randomPoint, state);

  //     componentList.add(newPoint);

  //     add(newPoint);
  //   }
  // }
}
