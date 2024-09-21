import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:game_of_trees/Model/CVAnswer.dart';
import 'package:game_of_trees/Model/CVLevels.dart';
import 'package:game_of_trees/state/levels/level_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'level_data_notifier.g.dart';

@Riverpod(keepAlive: true)
class LevelDataNotifier extends _$LevelDataNotifier {
  @override
  LevelState build() {
    return LevelState.empty();
  }

  ///Reads initial level data from the level info file provided into the app
  Future<void> readFromRootBundle() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    print(path);
    final levelInfoFile = File('$path/vectorData.txt');
    final List<CVLevels> levelData = [];

    final String response =
        await rootBundle.loadString('assets/gameData/vectorData.txt');

    // Write the file
    levelInfoFile.writeAsString('$response', mode: FileMode.writeOnly);
    final contents = await levelInfoFile.readAsString();
    final data = await json.decode(contents);
    try {
      data['nodes'].forEach(
        (element) {
          levelData.add(
            CVLevels.fromJson(element),
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
    state = state.copyWith(
      levelData: levelData,
      currentNumberOfNodes: levelData.first.numberOfNodes,
    );
  }

  ///On future launches, this method reads from application documents to get
  ///the data that was stored for the user.
  Future<void> readFromAppDirectory() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    final levelInfoFile = File('$path/vectorData.txt');
    final List<CVLevels> levelData = [];

    if (await levelInfoFile.exists()) {
      final contents = await levelInfoFile.readAsString();
      final data = await json.decode(contents);
      try {
        data.forEach(
          (element) {
            levelData.add(
              CVLevels.fromJson(element),
            );
          },
        );
      } catch (e) {
        print(e.toString());
        data['nodes'].forEach(
          (element) {
            levelData.add(
              CVLevels.fromJson(element),
            );
          },
        );
      }
      state = state.copyWith(
        levelData: levelData,
        currentNumberOfNodes: levelData.first.numberOfNodes,
      );
    } else {
      readFromRootBundle();
    }
  }

  void setCurrentLevel({required CVAnswer level}) {
    state = state.copyWith(currentLevel: level);
    setNextLevel();
  }

  void setNextLevel() {
    final currentLevel = state.currentLevel;

    if (state.currentLevel == null) {
      return;
    } else {
      final currentNodes = state.currentNumberOfNodes;
      final currentNodeLevelData = state.levelData
          .where((element) => element.numberOfNodes == currentNodes)
          .first;
      final nextLevel = currentNodeLevelData.listOfVectors.where((element) {
        return (element.isSolved == false && element != currentLevel);
      }).firstOrNull;

      if (nextLevel == null) {
        return;
      } else {
        state = state.copyWith(nextLevel: nextLevel);
      }
    }
  }

  Future<void> writeIsSolvedToJson({
    required CVAnswer cvAnswer,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    final levelInfoFile = File('$path/vectorData.txt');
    if (await levelInfoFile.exists()) {
      try {
        final List<CVLevels> levelData = List.from(state.levelData);

        CVLevels cvLevels = levelData
            .where((element) =>
                element.numberOfNodes == state.currentNumberOfNodes)
            .first;
        //get the specific level vectors, for example all of the vectors for 4 nodes

        levelData.removeWhere(
          (element) => element.numberOfNodes == state.currentNumberOfNodes,
        );
        //remove from the json data the entire object for that level, entire object for 4 nodes is removed

        int indexToInsert =
            cvLevels.listOfVectors.indexWhere((element) => element == cvAnswer);
        //get the index of the level which is to be removed.

        cvLevels.listOfVectors.removeWhere((element) => element == cvAnswer);
        // remove the specific level for 4 nodes, for example level 1, hashcode is overwritten so it only compares CV.

        cvLevels.listOfVectors.insert(indexToInsert, cvAnswer);
        //re-add it again at specific index, this time with the isSolved set to true.

        levelData.insert(state.currentNumberOfNodes - 4, cvLevels);
        //subtracting 4 because the nodes start from 4, so for inserting 5 node levels, it will be inserted at index 1

        levelInfoFile
            .writeAsString(json.encode(levelData), mode: FileMode.write)
            .then((value) => print("done writing"));

        state = state.copyWith(levelData: levelData);
      } catch (e) {}
    } else {
      return;
    }
  }

  void setCurrentNumberOfNodes({required int numberOfNodes}) {
    state = state.copyWith(currentNumberOfNodes: numberOfNodes);
  }

  void setRect({required Rect? rect}) {
    state = state.copyWith(rect: rect);
  }
}
