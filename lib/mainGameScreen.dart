import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Model/CVAnswer.dart';
import 'package:game_of_trees/nodeGame.dart';
import 'package:game_of_trees/nodeGameUI.dart';

class MainGameScreen extends ConsumerStatefulWidget {
  final CVAnswer cvAnswer;
  MainGameScreen({Key? key, required this.cvAnswer}) : super(key: key);

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends ConsumerState<MainGameScreen> {
  late NodeGame nodeGame;
  late NodeGameUI gameUI;

  @override
  void initState() {
    nodeGame = NodeGame(
      numberOfNodes: widget.cvAnswer.characteristicVector.length - 1,
      appBarHeight: 0,
      context: context,
      ref: ref,
      cvAnswer: widget.cvAnswer,
    );
    gameUI = NodeGameUI(nodeGame: nodeGame);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GameWidget(
          game: nodeGame,
          overlayBuilderMap: {
            'gameUI': (context, nodeGame) {
              return gameUI;
            },
          },
          initialActiveOverlays: ["gameUI"],
        ),
      ),
      onPopInvoked: (flag) async => false, //Prevent leaving by back press
    );
  }
}
