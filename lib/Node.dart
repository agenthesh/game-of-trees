import 'package:flame/components.dart';

class Graph {
  final Map<Node, List<Node>> nodes;

  Graph(this.nodes);
}

class Node implements Comparable<dynamic> {
  final String label;
  final Vector2 positionOnGrid;

  Node({required this.label, required this.positionOnGrid});

  @override
  bool operator ==(Object other) =>
      (other is Node) && (other.positionOnGrid == positionOnGrid);

  @override
  int get hashCode => positionOnGrid.hashCode;

  @override
  String toString() => '$label';

  @override
  int compareTo(other) {
    if (other is Node) {
      if (this.positionOnGrid.x > other.positionOnGrid.x &&
          this.positionOnGrid.y > other.positionOnGrid.y) {
        return 1;
      }
      return 0;
    }
    return 0;
  }
}
