import 'package:flutter/material.dart';

class NodeCard extends StatelessWidget {
  const NodeCard({required this.numberOfNodes});

  final int numberOfNodes;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 25.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.yellow,
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              numberOfNodes.toString(),
              style: TextStyle(
                fontSize: 70,
                color: Colors.grey[900],
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              "Nodes",
              style: TextStyle(
                fontSize: 30,
                color: Colors.grey[900],
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }
}
