import 'package:directed_graph/directed_graph.dart';
import 'package:game_of_trees/Model/Node.dart';

abstract class Queue<E> {
  bool enqueue(E element);
  E? dequeue();
  bool get isEmpty;
  E? get peek;
  int get size;
}

class QueueStack<E> implements Queue<E> {
  final _leftStack = <E>[];
  final _rightStack = <E>[];

  @override
  bool enqueue(E element) {
    _rightStack.add(element);
    return true;
  }

  @override
  E? dequeue() {
    if (_leftStack.isEmpty) {
      // 1
      _leftStack.addAll(_rightStack.reversed);
      // 2
      _rightStack.clear();
    }
    if (_leftStack.isEmpty) return null;
    // 3
    return _leftStack.removeLast();
  }

  @override
  bool get isEmpty => _leftStack.isEmpty && _rightStack.isEmpty;

  @override
  E? get peek => _leftStack.isNotEmpty ? _leftStack.last : _rightStack.first;

  @override
  int get size => _rightStack.length;
}

class QueueList<E> implements Queue<E> {
  final _list = <E>[];

  @override
  bool enqueue(E element) {
    _list.add(element);
    return true;
  }

  @override
  E? dequeue() => (isEmpty) ? null : _list.removeAt(0);

  @override
  bool get isEmpty => _list.isEmpty;

  @override
  E? get peek => (isEmpty) ? null : _list.first;

  @override
  int get size => _list.length;
}

extension helpers on DirectedGraph<Node> {
  List<Node> breadthFirstSearch(Node source) {
    final queue = QueueStack<Node>();
    Set<Node> enqueued = {};
    List<Node> visited = [];

    queue.enqueue(source);
    enqueued.add(source);

    while (true) {
      // 2
      final vertex = queue.dequeue();
      if (vertex == null) break;
      // 3
      visited.add(vertex);
      // 4
      final neighborEdges = edges(vertex);
      for (final edge in neighborEdges) {
        // 5
        if (!enqueued.contains(edge)) {
          queue.enqueue(edge);
          enqueued.add(edge);
        }
      }
    }

    return visited;
  }

  bool isCycle() {
    //declare a visited array, marked as zero for all vertices in the graph
    Map<Node, bool> visited = Map.fromIterable(
      this.vertices,
      value: (element) => false,
    );

    for (final Node node in this.vertices) {
      //for every node
      if (visited.containsKey(node) && !visited[node]!) {
        //if it is unvisited
        if (checkCycleUsingBFS(node, this.data, visited)) {
          //check if it contains a cycle
          return true;
        }
      }
    }
    return false;
  }

  bool checkCycleUsingBFS(
    Node node,
    Map<Node, Set<Node>> adj,
    Map<Node, bool> visited,
  ) {
    // we will be storing the currentNode + the parent of currentNode inside the queue
    Queue<List<Node?>> queue = new QueueList();
    visited[node] = true;
    queue.enqueue([node, null]);
    // this is the very first node for a particular component
    while (!queue.isEmpty) {
      int size = queue.size;
      for (int i = 0; i < size; i++) {
        List<Node?> currentItems = queue.dequeue() ?? [];
        Node? currentNode = currentItems[0];
        Node? parentNode = currentItems[1];
        List<Node> children = adj[currentNode]!.toList();
        for (final Node child in children) {
          if (visited[child]! && child != parentNode) {
            // this means somehow we have reached the child node through some other path
            // so this will lead toa cycle
            return true;
          }
          if (visited[child]! && child == parentNode) {
            continue;
          }
          if (!visited[child]!) {
            visited[child] = true;
            queue.enqueue([child, currentNode]);
          }
        }
      }
    }
    return false;
  }

  bool isConnected() {
    // 1
    if (vertices.isEmpty) return true;
    // 2
    final visited = breadthFirstSearch(vertices.first);
    // 3
    for (final vertex in vertices) {
      if (!visited.contains(vertex)) {
        return false;
      }
    }
    return true;
  }
}
