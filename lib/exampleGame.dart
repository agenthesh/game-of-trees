import 'dart:html';
import 'dart:math';
import 'dart:ui';

//import 'package:extended_math/extended_math.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:game_of_trees/Node.dart';
import 'package:game_of_trees/colorPoint.dart';

import 'gameState.dart';
import 'gridLayer.dart';
import 'unitSystem.dart';

class ExampleGame extends FlameGame
    with HasDraggableComponents, HasTappableComponents {
  late GameState state;
  GridLayer? gridLayer; //Draws the Grid

  List<Path> listOfPaths = []; //Contains all the paths (Edges or Lines)

  Path?
      tempPath; //temporary variable used to calculate the path before it is final

  List<Vector2> nodePositions = []; //Stores the Node Positions on the grid

  // List<ColorPoint> componentList =
  //     []; //Stores the number of Components on the Grid Currently

  bool isMovable = false; //Check if the nodes are movable or not

  List<Node> listOfNodes = []; //Stores the Nodes (Objects)

  //Used for calculating tempPath
  Vector2? lastDragPosition; //Last Known Drag Position
  Vector2? lastDragStart; //Last Known Drag Start Position

  //Variable that contains the data to create the Graph Object
  Map<Node, Set<Node>> directedGraphTree = {};
  Map<Node, Set<Node>> unDirectedGraphTree = {};

  //List of Labels for the node
  List<String> nodeLabels = ['A', 'B', 'C', 'D', 'E'];

  Map<String, int> characteristicVector = {
    "L0": 0,
    "L1": 0,
    "L2": 0,
    "L3": 0,
    "L4": 0,
    "L5": 0,
  };

  //Graph Objects
  DirectedGraph<Node>? directedGraph;
  DirectedGraph<Node>? unDirectedGraph;

  //Painter used for painting the lines
  Paint linesPainter = Paint()
    ..color = Colors.pink
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    state = GameState(
        UnitSystem(canvasSize.y, canvasSize.x, playingFieldToScreenRatio: 0.9));
    gridLayer = GridLayer(state);
  }

  Path getLineBetween(Vector2 startPoint, Vector2 endPoint) {
    final start = state.unitSystem.gridToPixelFrom(vector: startPoint);
    var end = state.unitSystem.gridToPixelFrom(vector: endPoint);

    return Path()
      ..moveTo(start.x, start.y)
      ..lineTo(end.x, end.y);
  }

  void resetElements() {
    tempPath = null;
    lastDragPosition = null;
    lastDragStart = null;
  }

  void addPointOnGrid(Vector2 point) => add(ColorPoint(point, state));

  bool insideGrid(Vector2 point) {
    return (point.x >= 0 &&
        point.y >= 0 &&
        point.x <= GRID_WIDTH &&
        point.y <= GRID_HEIGHT);
  }

  bool isAtNode(Vector2 point) {
    return listOfNodes.any((element) => element.positionOnGrid == point);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    final position = state.unitSystem.pixelToGrid(info.eventPosition.global);

    if (listOfNodes.length == 5) {
      //If 5 Nodes are added then, tapping again clears the board.
      // listOfPaths.clear();
      // tempPath = null;
      _calculateCharacteristicVector();
    } else {
      if (!insideGrid(position)) return;

      add(
        ColorPoint(position, state),
      ); //Adding to the Game Component List

      listOfNodes.add(
        Node(
          label: nodeLabels[listOfNodes.length],
          positionOnGrid: position,
        ),
      );
      //Assign an Empty Set to the Node Key in the GraphTree object (Not Linked to anything since it was just created)
      directedGraphTree[listOfNodes[listOfNodes.length - 1]] = {};
      unDirectedGraphTree[listOfNodes[listOfNodes.length - 1]] = {};
    }
    super.onTapUp(pointerId, info);
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    super.onDragStart(pointerId, info);
    final position = state.unitSystem.pixelToGrid(info.eventPosition.global);
    if (!insideGrid(position)) return;
    if (!isAtNode(position)) return;
    lastDragPosition = position;
    lastDragStart = position;
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo event) {
    super.onDragUpdate(pointerId, event);
    final position = state.unitSystem.pixelToGrid(event.eventPosition.global);
    if (!insideGrid(position) || lastDragStart == null) return;
    tempPath = getLineBetween(lastDragStart!, position);
    lastDragPosition = position;
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo event) {
    super.onDragEnd(pointerId, event);

    if (lastDragPosition != null && lastDragStart != null) {
      if (!insideGrid(lastDragPosition!)) return;
      if (!isAtNode(lastDragPosition!)) resetElements();

      var finalPath = getLineBetween(lastDragStart!, lastDragPosition!);
      listOfPaths.add(finalPath);
      updateGraphStructures();
    }
  }

  void updateGraphStructures() {
    //Get the index of the node where the starting position and the ending position is that node.
    int indexOfStartingNode = listOfNodes
        .indexWhere((element) => element.positionOnGrid == lastDragStart!);
    int indexOfEndingNode = listOfNodes
        .indexWhere((element) => element.positionOnGrid == lastDragPosition!);

    //Get the set of nodes for the starting node
    Set<Node> currentSetOfNodesDirected =
        directedGraphTree[listOfNodes[indexOfStartingNode]]!;

    Set<Node> currentSetOfNodesUnDirected =
        unDirectedGraphTree[listOfNodes[indexOfStartingNode]]!;

    //Add the Ending node to the current set
    currentSetOfNodesDirected.add(listOfNodes[indexOfEndingNode]);
    currentSetOfNodesUnDirected.add(listOfNodes[indexOfEndingNode]);

    directedGraphTree.update(
      listOfNodes[indexOfStartingNode],
      (value) => currentSetOfNodesDirected,
    ); //Add to the correct

    unDirectedGraphTree.update(
      listOfNodes[indexOfStartingNode],
      (value) => currentSetOfNodesUnDirected,
    ); //Add correct to the undirected tree to check for cycles

    //Get the set of nodes for the ending node
    currentSetOfNodesDirected =
        directedGraphTree[listOfNodes[indexOfEndingNode]]!;

    //Add the Starting node to the current set
    currentSetOfNodesDirected.add(listOfNodes[indexOfStartingNode]);

    //Add reverse direction to make it into a directed Graph
    directedGraphTree.update(
        listOfNodes[indexOfEndingNode], (value) => currentSetOfNodesDirected);

    directedGraph = new DirectedGraph(directedGraphTree);
    unDirectedGraph = new DirectedGraph(unDirectedGraphTree);
  }

  @override
  void render(Canvas canvas) {
    gridLayer?.render(canvas);
    super.render(canvas);

    listOfPaths.forEach((element) {
      canvas.drawPath(element, linesPainter);
    });

    // if (unDirectedGraph!.cycle.isNotEmpty) {
    //   print("Graph contains cycles!! Cycle: " +
    //       unDirectedGraph!.cycle.toString());
    //   listOfPaths.clear();
    // }

    //canvas.drawPath(tempPath!, linesPainter);

    // print("Shortest Path");
    // print(directedGraph!.crawler.path(listOfNodes[0], listOfNodes[1]));
    // List<Node> shortestPath = [];
    // Map<String, int> characteristicVector = {
    //   "L0": 0,
    //   "L1": 0,
    //   "L2": 0,
    //   "L3": 0,
    //   "L4": 0,
    //   "L5": 0,
    // };

    // listOfNodes.forEach((startNode) {
    //   print("Shortest Path For Node " + startNode.label);
    //   listOfNodes.forEach((targetNode) {
    //     if (startNode == targetNode) return;
    //     shortestPath = directedGraph!.crawler.path(startNode, targetNode);
    //     print(
    //       "Path From Node " +
    //           startNode.label +
    //           " To Node " +
    //           targetNode.label +
    //           " is " +
    //           shortestPath.toString(),
    //     );
    //     characteristicVector["L" + (shortestPath.length - 1).toString()] =
    //         characteristicVector["L" + (shortestPath.length - 1).toString()]! +
    //             1;
    //   });
    // });

    // var newList = listOfNodes;

    // listOfNodes.forEach((startNode) {
    //   if (listOfNodes.indexOf(startNode) > 0)
    //     newList.removeAt(newList.indexOf(startNode));
    //   newList.forEach((targetNode) {
    //     if (startNode == targetNode) return;
    //     shortestPath = directedGraph!.crawler.path(startNode, targetNode);
    //     print(
    //       "Path From Node " +
    //           startNode.label +
    //           " To Node " +
    //           targetNode.label +
    //           " is " +
    //           shortestPath.toString(),
    //     );
    //     characteristicVector["L" + (shortestPath.length - 1).toString()] =
    //         characteristicVector["L" + (shortestPath.length - 1).toString()]! +
    //             1;
    //   });
    // });

    // print(characteristicVector);
  }

  void _calculateCharacteristicVector() {
    List<Node> newList = [];

    newList.addAll(listOfNodes);

    List<Node> shortestPath = [];
    Map<String, int> characteristicVector = {
      "L0": 0,
      "L1": 0,
      "L2": 0,
      "L3": 0,
      "L4": 0,
      "L5": 0,
    };

    // listOfNodes.forEach((startNode) {
    //   if (listOfNodes.indexOf(startNode) > 0)
    //     newList.removeAt(newList.indexOf(startNode));
    //   newList.forEach((targetNode) {
    //     if (startNode == targetNode) return;
    //     shortestPath = directedGraph!.crawler.path(startNode, targetNode);
    //     print(
    //       "Path From Node " +
    //           startNode.label +
    //           " To Node " +
    //           targetNode.label +
    //           " is " +
    //           shortestPath.toString(),
    //     );
    //     characteristicVector["L" + (shortestPath.length - 1).toString()] =
    //         characteristicVector["L" + (shortestPath.length - 1).toString()]! +
    //             1;
    //   });
    // });

    for (var i = 0; i < listOfNodes.length; i++) {
      if (i > 0) newList.removeAt(0);
      for (var j = 0; j < newList.length; j++) {
        if (listOfNodes[i] == newList[j]) {
          print(
            "Path From Node " +
                listOfNodes[i].label +
                " To Node " +
                newList[j].label,
          );
        } else {
          shortestPath =
              directedGraph!.crawler.path(listOfNodes[i], newList[j]);
          print(
            "Path From Node " +
                listOfNodes[i].label +
                " To Node " +
                newList[j].label +
                " is " +
                shortestPath.toString(),
          );
          characteristicVector["L" + (shortestPath.length - 1).toString()] =
              characteristicVector[
                      "L" + (shortestPath.length - 1).toString()]! +
                  1;
        }
      }
    }

    print(characteristicVector);
  }
}
