import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/GameUIOverlays/answerScreen.dart';
import 'package:game_of_trees/GameUIOverlays/helpScreen.dart';
import 'package:game_of_trees/GameUIOverlays/screenLevelInfo.dart';
import 'package:game_of_trees/Providers.dart';
import 'package:game_of_trees/nodeGame.dart';
import 'package:game_of_trees/node_icons_icons.dart';
import 'package:game_of_trees/services.dart';

class NodeGameUI extends ConsumerStatefulWidget {
  final NodeGame nodeGame;

  const NodeGameUI({Key? key, required this.nodeGame}) : super(key: key);

  @override
  _NodeGameUIState createState() => _NodeGameUIState();
}

class _NodeGameUIState extends ConsumerState<NodeGameUI> with WidgetsBindingObserver {
  UIScreen currentScreen = UIScreen.gameUI;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
        icon: Icon(Icons.help_outline),
        onPressed: () {
          currentScreen = currentScreen == UIScreen.help ? UIScreen.gameUI : UIScreen.help;
          update();
        },
      ),
    );
  }

  Widget leaveButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(Icons.logout),
        onPressed: () {
          Navigator.pop(context);
          firebaseService.closeGameEvent();
        },
      ),
    );
  }

  Widget viewLevelInfoButton() {
    return Ink(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(NodeIcons.graph),
        onPressed: () {
          currentScreen = currentScreen == UIScreen.levelInfo ? UIScreen.gameUI : UIScreen.levelInfo;
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
            color: Colors.yellow,
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
          leaveButton(),
          helpButton(),
          viewLevelInfoButton(),
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
              padding: EdgeInsets.only(bottom: 20, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Ink(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.yellow, Colors.yellow[700]!],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () => widget.nodeGame.undoEvent(),
                        customBorder: CircleBorder(),
                        child: Center(
                          child: Icon(
                            Icons.undo,
                            size: 22,
                            color: Colors.grey[900],
                          ),
                        ),
                        splashColor: Colors.yellow[300],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Ink(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.yellow, Colors.yellow[700]!],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          currentScreen = UIScreen.cvScreen;
                          widget.nodeGame.checkCharVector();
                          update();
                        },
                        customBorder: CircleBorder(),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            size: 50,
                            color: Colors.grey[900],
                          ),
                        ),
                        splashColor: Colors.pink[300],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Ink(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.yellow, Colors.yellow[700]!],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () => widget.nodeGame.resetBoard(),
                        customBorder: CircleBorder(),
                        child: Center(
                          child: Icon(
                            Icons.refresh,
                            size: 22,
                            color: Colors.grey[900],
                          ),
                        ),
                        splashColor: Colors.pink[300],
                      ),
                    ),
                  ),
                ],
              ))
        ],
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
              HelpScreen(onDonePress: () {
                currentScreen = UIScreen.gameUI;
                update();
              }),
              ScreenLevelInfo(
                  characteristicVectorAnswer: widget.nodeGame.cvAnswer.characteristicVector,
                  onDonePress: () {
                    currentScreen = UIScreen.gameUI;
                    update();
                  }),
              AnswerScreen(
                characteristicVectorAnswer: widget.nodeGame.cvAnswer.characteristicVector,
                onDonePress: () {
                  currentScreen = UIScreen.gameUI;
                  update();
                },
              )
            ],
            index: currentScreen.index,
          ),
        ),
      ],
    );
  }
}

enum UIScreen {
  gameUI,
  help,
  levelInfo,
  cvScreen,
}
