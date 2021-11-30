import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Providers.dart';
import 'package:game_of_trees/nodeGame.dart';

class NodeGameUI extends ConsumerStatefulWidget {
  final ExampleGame nodeGame;

  const NodeGameUI({Key? key, required this.nodeGame}) : super(key: key);

  @override
  _NodeGameUIState createState() => _NodeGameUIState();
}

class _NodeGameUIState extends ConsumerState<NodeGameUI>
    with WidgetsBindingObserver {
  UIScreen currentScreen = UIScreen.gameUI;

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  Widget spacer({int? size}) {
    return Expanded(
      flex: size ?? 100,
      child: Center(),
    );
  }

  Widget helpButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          Icons.help_outline,
        ),
        onPressed: () {
          currentScreen =
              currentScreen == UIScreen.help ? UIScreen.gameUI : UIScreen.help;
          update();
        },
      ),
    );
  }

  Widget nodesLeftDisplay() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 6, top: 2),
          child: Icon(
            Icons.circle,
            color: Colors.pink,
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final nodes = ref.watch(remainingNodeProvider);
            return Text(
              nodes.toString(),
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            );
          },
        )
      ],
    );
  }

  Widget topControls() {
    return Padding(
      padding: EdgeInsets.only(top: 35, left: 5, right: 15, bottom: 25),
      child: Row(
        children: <Widget>[
          helpButton(),
          spacer(),
          nodesLeftDisplay(),
        ],
      ),
    );
  }

  Widget buildGameUI() {
    return Positioned.fill(
      child: Column(
        children: <Widget>[
          spacer(),
          Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                      textStyle: TextStyle(
                        fontSize: 18.0,
                      ),
                      side: BorderSide(
                        color: Colors.pink,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    child: Text(
                      "Check Graph",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      currentScreen = UIScreen.cvScreen;
                      widget.nodeGame.checkCharVector();
                      update();
                    },
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.pink,
                      backgroundColor: Colors.white,
                      textStyle: TextStyle(
                        fontSize: 18.0,
                      ),
                      side: BorderSide(
                        color: Colors.white,
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    ),
                    child: Text(
                      "Reset Board",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      currentScreen = UIScreen.gameUI;
                      widget.nodeGame.resetBoard();
                      update();
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget buildCVScreen() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          child: Card(
            color: Colors.white,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
                child: Consumer(builder: (_, ref, __) {
                  final CVString = ref.watch(cvProvider);
                  final CVCheck = ref.watch(cvCheckProvider);
                  return Column(
                    children: [
                      Text(
                        CVCheck ? "You Solved It" : "Please Try Again",
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Calculated Characteristic Vector is \n\n" +
                            CVString +
                            "\n\n Click on Check Graph to check your answer",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                      MaterialButton(
                        child: Text(
                          "Got It!",
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          currentScreen = UIScreen.gameUI;
                          update();
                        },
                      ),
                    ],
                  );
                })),
          ),
        ),
      ),
    );
  }

  Widget buildScreenHelp() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          child: Card(
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
              child: Column(
                children: [
                  Text(
                    "NodeGame Basics",
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Tap the screen to add a node to the screen.\n\n"
                    "Connect the nodes to create a graph that satisfies the characteristic vector.\n\n"
                    "Click on Check Graph to check your answer",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  MaterialButton(
                    child: Text(
                      "Got It!",
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      currentScreen = UIScreen.gameUI;
                      update();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        topControls(),
        Expanded(
          child: IndexedStack(
            children: <Widget>[
              buildGameUI(),
              buildScreenHelp(),
              buildCVScreen(),
            ],
            index: currentScreen.index,
          ),
        ),
      ],
    );
  }

  void didChangeMetrics() {
    //game.onResize(WidgetsBinding.instance!.window.physicalSize);
  }
}

enum UIScreen {
  gameUI,
  help,
  cvScreen,
}
