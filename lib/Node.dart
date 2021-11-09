import 'package:flame/components.dart';

class Graph {
  final Map<Node, List<Node>> nodes;

  Graph(this.nodes);
}

class Node {
  final String id;
  final int data;
  final Vector2 positionOnGrid;

  Node(this.id, this.data, this.positionOnGrid);

  @override
  bool operator ==(Object other) =>
      other is Node && other.positionOnGrid == positionOnGrid;

  @override
  int get hashCode => positionOnGrid.hashCode;

  @override
  String toString() => '$id';
}
