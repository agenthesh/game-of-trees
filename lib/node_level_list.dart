import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Model/CVAnswer.dart';
import 'package:game_of_trees/Providers.dart';
import 'package:game_of_trees/fadeRouteBuilder.dart';
import 'package:game_of_trees/mainGameScreen.dart';
import 'package:game_of_trees/nodeSelectorScreen.dart';
import 'package:game_of_trees/services.dart';
import 'package:game_of_trees/state/levels/level_data_notifier.dart';
import 'package:game_of_trees/util.dart';
import 'package:rect_getter/rect_getter.dart';

class NodeLevelList extends ConsumerWidget {
  const NodeLevelList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelState = ref.watch(levelDataNotifierProvider);
    final numberOfNodes = levelState.currentNumberOfNodes;
    final nodeLevelData = levelState.levelData
        .where((element) => element.numberOfNodes == numberOfNodes)
        .first;

    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
      children: List.generate(
        nodeLevelData.listOfVectors.length,
        (index) => LevelCard(
          cvAnswer: nodeLevelData.listOfVectors[index],
          numberOfNodes: numberOfNodes,
          index: index,
        ),
      ),
    );
  }
}

class LevelCard extends ConsumerWidget {
  const LevelCard({
    required this.cvAnswer,
    required this.numberOfNodes,
    required this.index,
  });

  final CVAnswer cvAnswer;
  final int numberOfNodes;
  final int index;

  void _onLevelTap(
      {required CVAnswer cvAnswer,
      required WidgetRef ref,
      required BuildContext context}) async {
    firebaseService.startNewLevelEvent(
      numberOfNodes: numberOfNodes,
      characteristicVector: cvAnswer.characteristicVector,
    );

    ref
        .read(levelDataNotifierProvider.notifier)
        .setCurrentLevel(level: cvAnswer);

    // Navigator.of(context).push(
    //   FadeRouteBuilder(page: MainGameScreen(cvAnswer: cvAnswer)),
    // );

    Rect? rect = RectGetter.getRectFromKey(rectGetterKey);

    ref.read(levelDataNotifierProvider.notifier).setRect(rect: rect!);

    //<-- set rect to be size of fab

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        //<-- on the next frame... //<-- set rect to be big
        ref.read(levelDataNotifierProvider.notifier).setRect(
            rect: rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
        //<-- after delay, go to next page
        Future.delayed(
          Duration(seconds: 1),
          () => _goToNextPage(cvAnswer: cvAnswer, ref: ref, context: context),
        );
      },
    );
  }

  void _goToNextPage({
    required CVAnswer cvAnswer,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    Rect? rect = RectGetter.getRectFromKey(rectGetterKey);
    //this is added here because you cannot change the state of an object during the lifecycle methods of the widget.
    ref.read(remainingNodeProvider.notifier).state =
        cvAnswer.characteristicVector.length - 1;
    Navigator.of(context)
        .push(FadeRouteBuilder(page: MainGameScreen(cvAnswer: cvAnswer)))
        .then((_) {
      ref.read(levelDataNotifierProvider.notifier).setRect(rect: null);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _onLevelTap(cvAnswer: cvAnswer, ref: ref, context: context),
      child: Card(
        elevation: 10.0,
        shadowColor: cvAnswer.isSolved ? Colors.green[100] : Colors.yellow[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: cvAnswer.isSolved ? Colors.green : Colors.yellow,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Level ${(index + 1).toString()}",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w900,
                ),
              ),
              AutoSizeText(
                formatCharacteristicVector(cvAnswer.characteristicVector),
                textAlign: TextAlign.center,
                maxLines: 4,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
