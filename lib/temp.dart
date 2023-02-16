// // refernce : https://youtu.be/A8ko93TyOns


// import 'dart:collection';

// import 'package:game_of_trees/Model/Node.dart';

// class Solution {
//     // Function to detect cycle in an undirected graph.
//     static bool isCycle(int length, List<List<Node>>? adj) {
//         // Code here
//         // using BFS
//         if (adj == null || adj.length == 0) {
//             return false;
//         }
//         List<bool> visited = List.filled(length, false);
        
//         for (int i=0; i<length; i++) {
//             if (!visited[i]) {
//                 if (checkCycleUsingBFS(i, adj, visited)) {
//                     return true;
//                 }
//             }
//         }
//         return false;
//     }
    
//     static bool checkCycleUsingBFS(int node, List<List<Node>> adj, List<bool> visited) {
//         // we will be storing the currentNode + the parent of currentNode inside the queue
//         Queue<List<int>> queue = new Queue<List<int>>();
//         visited[node] = true;
//         queue.add(new int[]{node, -1}); // this is the very first node for a particualr component
//         while (queue.isNotEmpty) {
//             int size = queue.length;
//             for (int i=0; i<size; i++) {
//                 int [] currentItems = queue.poll();
//                 int currentNode = currentItems[0];
//                 int parent = currentItems[1];
//                 ArrayList<Integer> children = adj.get(currentNode);
//                 for (Integer child : children) {
//                     if (visited[child] && child != parent) {
//                         // this means somehow we have reached the child node through some other path
//                         // so this will lead toa cycle
//                         return true;
//                     }
//                     if (visited[child] && child == parent) {
//                         continue;
//                     }
//                     if (!visited[child]) {
//                         visited[child] = true;
//                         queue.offer(new int []{child, currentNode});
//                     }
//                 }
//             }
//         }
//         return false;
//     }
// }