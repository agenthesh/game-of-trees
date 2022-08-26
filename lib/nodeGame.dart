import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Model/CVAnswer.dart';
import 'package:game_of_trees/Model/Node.dart';
import 'package:game_of_trees/Model/linePath.dart';
import 'package:game_of_trees/Providers.dart';
import 'package:game_of_trees/Model/colorPoint.dart';
import 'package:game_of_trees/services.dart';
import 'package:game_of_trees/util.dart';

import 'gameState.dart';
import 'gridLayer.dart';
import 'Model/unitSystem.dart';

class NodeGame extends FlameGame with HasDraggables, HasTappables {
  ///Considers app bar height into the calculation when calculation the corrected position of the nodes on the grid
  final double appBarHeight;
  final BuildContext context;
  final WidgetRef ref;
  final CVAnswer cvAnswer;
  int _resetCounter = 0;
  int _checkCount = 0;

  late GameState state;
  Rect? bgRect;

  //Number of nodes this game has
  int numberOfNodes;

  List<Component> listOfComponents = [];

  ///Actual object that draws the GridLayer on the Screen
  GridLayer? gridLayer;

  ///Contains all the paths (Edges or Lines)

  ///Temporary variable used to calculate the path before it is final
  Path? tempPath;

  /// Stores the Node Positions on the grid
  List<Vector2> nodePositions = [];

  // List<ColorPoint> componentList =
  //     []; //Stores the number of Components on the Grid Currently

  ///Stores the Nodes (Objects)
  List<Node> listOfNodes = [];

  //Used for calculating tempPath
  ///Last Known Drag Position
  Vector2? lastDragPosition;

  ///Last Known Drag Start Position
  Vector2? lastDragStart;

  ///List of Labels for the node
  List<String> nodeLabels = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
  ];

  //Graph Objects
  /// Graph Object that stores the directed graph (edge between start and end, end and start) drawn on the screen
  DirectedGraph<Node> directedGraph = DirectedGraph({});

  /// Graph Object that stores the undirected graph drawn on the screen
  DirectedGraph<Node> unDirectedGraph = DirectedGraph({});

  List<dynamic> eventList = [];

  ///Painter used for painting the lines
  Paint linesPainter = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;

  NodeGame({
    required this.numberOfNodes,
    required this.appBarHeight,
    required this.context,
    required this.ref,
    required this.cvAnswer,
  });

  @override
  void onGameResize(Vector2 canvasSize) {
    bgRect = Rect.fromLTWH(0.0, 0.0, canvasSize.x, canvasSize.y);
    super.onGameResize(canvasSize);
    state = GameState(
        unitSystem: UnitSystem(
      screenHeightInPixels: canvasSize.y,
      screenWidthInPixels: canvasSize.x,
      playingFieldToScreenRatio: 0.8,
      appBarHeight: appBarHeight,
    ));

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
    _resetCounter++;
  }

  bool insideGrid(Vector2 point) {
    return (point.x >= 0 &&
        point.y >= 0 &&
        point.x <= state.unitSystem.gridWidth &&
        point.y <= state.unitSystem.gridHeight);
  }

  bool isAtNode(Vector2 point) {
    return listOfNodes.any((element) => element.positionOnGrid == point);
  }

  void undoEvent() {
    if (eventList.isEmpty) return;
    if (eventList.last is ColorPoint) {
      ColorPoint tempNode = eventList.last as ColorPoint;

      listOfNodes.removeWhere((element) => element.label == tempNode.label);

      ref.read(remainingNodeProvider.notifier).state = ((numberOfNodes) - listOfNodes.length);
      listOfComponents.removeWhere((element) => element is ColorPoint && element == tempNode);
      remove(eventList.last);
      firebaseService.removeNodeEvent(nodeLabel: tempNode.label, gridPosition: tempNode.gridPosition.toString());
    }
    if (eventList.last is LinePath) {
      LinePath tempLinePath = eventList.last as LinePath;

      Node startNode = listOfNodes.where((element) => element.positionOnGrid == tempLinePath.startPositionGrid).first;
      Node endNode = listOfNodes.where((element) => element.positionOnGrid == tempLinePath.endPositionGrid).first;
      removeEdgeBetween(startNode.label, endNode.label);
      listOfComponents.removeWhere((element) => element is LinePath && element == tempLinePath);
      remove(eventList.last);
    }

    eventList.removeLast();
  }

  void resetBoard() {
    listOfNodes.clear();
    removeAll(listOfComponents);
    listOfComponents.clear();
    this.unDirectedGraph.clear();
    directedGraph.clear();
    ref.read(remainingNodeProvider.notifier).state = numberOfNodes;
    ref.read(cvCheckProvider.notifier).state = false;
    tempPath = null;
    FirebaseAnalytics.instance.logEvent(name: "reset_level", parameters: {
      "level": cvAnswer.characteristicVector,
      "resetCount": _resetCounter,
    });

    firebaseService.resetLevelEvent(resetCount: _resetCounter);
  }

  void removeEdgeBetween(String startNodeLabel, String endNodeLabel) {
    Node startNode = listOfNodes.where((element) => element.label == startNodeLabel).first;
    Node endNode = listOfNodes.where((element) => element.label == endNodeLabel).first;

    unDirectedGraph.removeEdges(startNode, {endNode});
    directedGraph.removeEdges(startNode, {endNode});
    unDirectedGraph.removeEdges(endNode, {startNode});

    listOfComponents.removeWhere((element) =>
        element is LinePath &&
        element.startPositionGrid == startNode.positionOnGrid &&
        element.endPositionGrid == endNode.positionOnGrid);

    firebaseService.removeEdgeBetweenEvent(startNodeLabel: startNodeLabel, endNodeLabel: endNodeLabel);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    final position = state.unitSystem.pixelToGrid(info.eventPosition.global);
    if (listOfNodes.length < numberOfNodes) {
      if (!insideGrid(position)) return;
      if (isAtNode(position)) return;
      ref.read(remainingNodeProvider.notifier).state = ((numberOfNodes - 1) - listOfNodes.length);

      final ColorPoint pointComponent =
          ColorPoint(gridPosition: position, state: state, label: nodeLabels[listOfNodes.length]);

      add(pointComponent);

      this.children.changePriority(pointComponent, 10);

      listOfComponents.add(pointComponent);

      eventList.add(pointComponent);

      Node nodeToBeAdded = Node(
        label: nodeLabels[listOfNodes.length],
        positionOnGrid: position,
      );

      listOfNodes.add(nodeToBeAdded);

      FirebaseAnalytics.instance.logEvent(name: "added_node", parameters: {
        "level": cvAnswer.characteristicVector,
        "position_of_node": position.toString(),
      });

      firebaseService.addNodeEvent(nodeLabel: nodeToBeAdded.label, gridPosition: position.toString());

      super.onTapUp(pointerId, info);
    }
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

    if (!insideGrid(lastDragPosition!)) return;
    if (!isAtNode(lastDragPosition!)) {
      resetElements();
      return;
    }

    if (lastDragPosition != null && lastDragStart != null) {
      Rect originalRect = Rect.fromPoints(
          state.unitSystem.vectorToOffset(lastDragStart!), state.unitSystem.vectorToOffset(lastDragPosition!));

      Offset startPosition = state.unitSystem.vectorToOffset(lastDragStart!);
      Offset endPosition = state.unitSystem.vectorToOffset(lastDragPosition!);

      LinePath finalLineComponent = LinePath(
        startPosition: startPosition,
        endPosition: endPosition,
        finalRect: getFinalRect(originalRect),
        angle: atan2(
          endPosition.dy - startPosition.dy,
          endPosition.dx - startPosition.dx,
        ),
        state: state,
      );
      add(finalLineComponent);

      listOfComponents.add(finalLineComponent);

      eventList.add(finalLineComponent);

      addNewEdgeBetween();
      checkGraphIsCyclic();
      tempPath = null;
    }
  }

  void checkGraphIsCyclic() {
    if (unDirectedGraph.isAcyclic) return;
    Flushbar(
      duration: Duration(seconds: 10),
      boxShadows: [
        BoxShadow(
          offset: Offset(0.5, 0.5),
          blurRadius: 5,
        ),
      ],
      messageText: Text(
        "Cycles are not allowed",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.grey.shade900,
      borderColor: Colors.yellow,
      margin: EdgeInsets.only(
        top: 25,
        right: 25,
        left: 25,
        bottom: 25,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
    )..show(context);
  }

  void addNewEdgeBetween() {
    Node startNode = listOfNodes.where((element) => element.positionOnGrid == lastDragStart!).first;
    Node endNode = listOfNodes.where((element) => element.positionOnGrid == lastDragPosition!).first;

    directedGraph.addEdges(startNode, {endNode});
    directedGraph.addEdges(endNode, {startNode});
    unDirectedGraph.addEdges(startNode, {endNode});

    firebaseService.addEdgeEvent(startNodeLabel: startNode.label, endNodeLabel: endNode.label);
  }

  @override
  void render(Canvas canvas) {
    final Paint paint = Paint();
    paint.color = Colors.grey[900]!;
    canvas.drawRect(bgRect!, paint);

    gridLayer?.render(canvas);

    if (tempPath != null) {
      canvas.drawPath(tempPath!, linesPainter);
    }

    super.render(canvas);
  }

  Map<String, int> calculateCharacteristicVector() {
    try {
      print("UnDirectedGraph: $unDirectedGraph");
      print("DirectedGraph: $directedGraph");

      List<Node> newList = [];

      newList.addAll(listOfNodes);

      List<Node> shortestPath = [];

      Map<String, int> templateCharVector = {};

      for (var i = 0; i <= numberOfNodes; i++) {
        i == 0 ? templateCharVector["L${i.toString()}"] = numberOfNodes : templateCharVector["L${i.toString()}"] = 0;
      } //creates the template characteristic vector that is filled in with the below loop

      for (var i = 0; i < listOfNodes.length; i++) {
        if (i > 0) newList.removeAt(0);
        for (var j = 0; j < newList.length; j++) {
          if (listOfNodes[i] == newList[j]) {
            print(
              "Path From Node " + listOfNodes[i].label + " To Node " + newList[j].label,
            );
          } else {
            shortestPath = directedGraph.crawler.path(listOfNodes[i], newList[j]);
            print(
              "Path From Node " +
                  listOfNodes[i].label +
                  " To Node " +
                  newList[j].label +
                  " is " +
                  shortestPath.toString(),
            );
            templateCharVector["L" + (shortestPath.length - 1).toString()] =
                templateCharVector["L" + (shortestPath.length - 1).toString()]! + 1;
          }
        }
      }
      ref.read(cvProvider.notifier).state = templateCharVector;
      print(templateCharVector);
      return templateCharVector;
    } catch (e) {
      print(e);
      return {};
    }
  }

  void checkCharVector() {
    _checkCount++;
    ref.read(isAcyclicProvider.notifier).state = unDirectedGraph.isAcyclic;
    if (cvAnswer.characteristicVector.toString() == calculateCharacteristicVector().toString()) {
      ref.read(cvCheckProvider.notifier).state = true;
      //ref.read(levelDataProvider).levelData[numberOfNodes-4]. =

      FirebaseAnalytics.instance.logEvent(name: "checked_answer", parameters: {
        "level": cvAnswer.characteristicVector,
        "passedLevel": true,
        "checkCount": _checkCount,
      });
      firebaseService.checkAnswerEvent(passLevel: true, checkCount: _checkCount);

      ref.read(levelDataProvider).writeIsSolvedToJson(
          numberOfNodes: numberOfNodes,
          cvAnswer: CVAnswer(isSolved: true, characteristicVector: cvAnswer.characteristicVector));
    } else {
      ref.read(cvCheckProvider.notifier).state = false;
      FirebaseAnalytics.instance.logEvent(name: "checked_answer", parameters: {
        "level": cvAnswer.characteristicVector,
        "passedLevel": false,
        "checkCount": _checkCount,
      });
      firebaseService.checkAnswerEvent(passLevel: false, checkCount: _checkCount);
    }
  }
}
