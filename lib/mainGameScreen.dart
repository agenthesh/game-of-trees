import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/nodeGame.dart';
import 'package:game_of_trees/userControls.dart';

class MainGameScreen extends ConsumerStatefulWidget {
  final Map<String, int> characteristicVector;
  MainGameScreen({Key? key, required this.characteristicVector})
      : super(key: key);

  @override
  _MainGameScreenState createState() => _MainGameScreenState();
}

class _MainGameScreenState extends ConsumerState<MainGameScreen> {
  late ExampleGame nodeGame;
  late NodeGameUI gameUI;

  @override
  void initState() {
    nodeGame = ExampleGame(
      appBarHeight: 0,
      context: context,
      ref: ref,
      characteristicVectorAnswer: widget.characteristicVector,
    );
    gameUI = NodeGameUI(nodeGame: nodeGame);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
      onWillPop: () async => false, //Prevent leaving by back press
    );
  }
}

// PreferredSizeWidget myAppBar(BuildContext context) {
//   return AppBar(
//     backgroundColor: Colors.black,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         bottomLeft: Radius.circular(10),
//         bottomRight: Radius.circular(10),
//       ),
//     ),
//     actions: [
//       IconButton(
//         onPressed: () => {},
//         icon: Icon(Icons.ac_unit_sharp),
//       )
//     ],
//   );
// }
