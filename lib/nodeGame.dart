import 'package:flame/components.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Model/Node.dart';
import 'package:game_of_trees/Providers.dart';
import 'package:game_of_trees/Model/colorPoint.dart';

import 'gameState.dart';
import 'gridLayer.dart';
import 'Model/unitSystem.dart';

class ExampleGame extends BaseGame
    with HasDraggableComponents, HasTappableComponents {
  ///Considers app bar height into the calculation when calculation the corrected position of the nodes on the grid
  final double appBarHeight;
  final BuildContext context;
  final WidgetRef ref;
  final Map<String, int> characteristicVectorAnswer;

  late GameState state;
  Rect? bgRect;

  //Number of nodes this game has
  int numberOfNodes;

  ///Actual object that draws the GridLayer on the Screen
  GridLayer? gridLayer;

  ///Contains all the paths (Edges or Lines)
  List<Path> listOfPaths = [];

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

  ///Variable that contains the data to create the Graph Object
  Map<Node, Set<Node>> directedGraphTree = {};
  Map<Node, Set<Node>> unDirectedGraphTree = {};

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
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
  ];

  //Graph Objects
  /// Graph Object that stores the directed graph drawn on the screen
  DirectedGraph<Node> directedGraph = DirectedGraph({});

  /// Graph Object that stores the undirected graph drawn on the screen
  DirectedGraph<Node> unDirectedGraph = DirectedGraph({});

  ///Painter used for painting the lines
  Paint linesPainter = Paint()
    ..color = Colors.pink
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

  ExampleGame({
    required this.numberOfNodes,
    required this.appBarHeight,
    required this.context,
    required this.ref,
    required this.characteristicVectorAnswer,
  });

  @override
  void onResize(Vector2 canvasSize) {
    bgRect = Rect.fromLTWH(0.0, 0.0, canvasSize.x, canvasSize.y);
    super.onResize(canvasSize);
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

  void resetBoard() {
    listOfPaths.clear();
    listOfNodes.clear();
    components.clear();
    unDirectedGraph.clear();
    directedGraph.clear();
    ref.read(remainingNodeProvider.notifier).state = numberOfNodes;
    ref.read(cvCheckProvider.notifier).state = false;
    tempPath = null;
  }

  void removeNodeConnections(Vector2 position) {
    // get the node

    Node nodeToBeReset = listOfNodes
        .where((element) => element.positionOnGrid == position)
        .first; // Getting the node

    //need to remove from undirected graph tree as well

    unDirectedGraph.removeEdges(
        nodeToBeReset, unDirectedGraph.edges(nodeToBeReset).toSet());

    //updateGraphStructures();

    //remove the path where all the paths beginning is this node

    // //update graph structures
    // print("hello");
    // print(unDirectedGraph.edges());
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    final position = state.unitSystem.pixelToGrid(info.eventPosition.global);

    // isAtNode(position)
    //     ? removeNodeConnections(position)
    //     : print("idk why this not work");

    if (listOfNodes.length < numberOfNodes) {
      if (!insideGrid(position)) return;
      ref.read(remainingNodeProvider.notifier).state =
          ((numberOfNodes - 1) - listOfNodes.length);

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
    final Paint paint = Paint();
    paint.color = Colors.grey[900]!;
    canvas.drawRect(bgRect!, paint);

    gridLayer?.render(canvas);
    super.render(canvas);

    listOfPaths.forEach((element) {
      canvas.drawPath(element, linesPainter);
    });

    //   listOfNodes.forEach(
    //     (startNode) {
    //       unDirectedGraph.edges(startNode).forEach(
    //         (endNode) {
    //           canvas.drawPath(
    //               getLineBetween(
    //                   startNode.positionOnGrid, endNode.positionOnGrid),
    //               linesPainter);
    //         },
    //       );
    //     },
    //   );
  }

  Map<String, int> calculateCharacteristicVector() {
    try {
      List<Node> newList = [];

      newList.addAll(listOfNodes);

      List<Node> shortestPath = [];

      Map<String, int> templateCharVector = {};

      for (var i = 0; i <= numberOfNodes; i++) {
        i == 0
            ? templateCharVector["L${i.toString()}"] = numberOfNodes
            : templateCharVector["L${i.toString()}"] = 0;
      } //creates the template characteristic vector that is filled in with the below loop

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
                directedGraph.crawler.path(listOfNodes[i], newList[j]);
            print(
              "Path From Node " +
                  listOfNodes[i].label +
                  " To Node " +
                  newList[j].label +
                  " is " +
                  shortestPath.toString(),
            );
            templateCharVector["L" + (shortestPath.length - 1).toString()] =
                templateCharVector[
                        "L" + (shortestPath.length - 1).toString()]! +
                    1;
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
    if (characteristicVectorAnswer.toString() ==
        calculateCharacteristicVector().toString()) {
      ref.read(cvCheckProvider.notifier).state = true;
    } else {
      ref.read(cvCheckProvider.notifier).state = false;
    }
  }

  // void loadGameDataFromEnv() {
  //   DEMO_CHAR_VECTORS['nodes'].forEach((element) {
  //     CharacteristicVectorAnswers.fromJson(element);
  //   });
  // }
}
