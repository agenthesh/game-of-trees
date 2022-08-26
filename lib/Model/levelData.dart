import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_of_trees/Model/CVAnswer.dart';
import 'package:game_of_trees/Model/CVLevels.dart';
import 'package:path_provider/path_provider.dart';

class LevelData with ChangeNotifier {
  List<CVLevels> _levelData = [];
  bool _error = false;
  String _errorMessage = "";

  List<CVLevels> get levelData => _levelData;
  bool get error => _error;
  String get errorMessage => _errorMessage;

  Future<void> readFromRootBundle() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    print(path);
    final levelInfoFile = File('$path/vectorData.txt');

    final String response = await rootBundle.loadString('assets/gameData/vectorData.txt');

    // Write the file
    levelInfoFile.writeAsString('$response', mode: FileMode.writeOnly);
  }

  Future<void> readFromAppDirectory() async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    final levelInfoFile = File('$path/vectorData.txt');

    if (await levelInfoFile.exists()) {
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
        _error = false;
      } catch (e) {
        _error = true;
        _errorMessage = e.toString();
        print(e.toString());
      }
    } else {
      await readFromRootBundle();
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
        _error = false;
      } catch (e) {
        _error = true;
        _errorMessage = e.toString();
        print(e.toString());
      }
    }
    notifyListeners();
  }

  Future<void> writeIsSolvedToJson({required int numberOfNodes, required CVAnswer cvAnswer}) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = directory.path;
    final levelInfoFile = File('$path/vectorData.txt');
    if (await levelInfoFile.exists()) {
      final contents = await levelInfoFile.readAsString();
      final data = await json.decode(contents);

      try {
        CVLevels cvLevels = CVLevels.fromJson(data['nodes']
            .where(
              (element) => element['numberOfNodes'] == numberOfNodes,
            )
            .first);

        data['nodes'].removeWhere(
          (element) => element['numberOfNodes'] == numberOfNodes,
        );
        cvLevels.listOfVectors.removeWhere((element) => element == cvAnswer);

        cvLevels.listOfVectors.add(cvAnswer);

        data['nodes'].insert(numberOfNodes - 4, cvLevels);

        levelInfoFile.writeAsString(json.encode(data), mode: FileMode.write).then((value) => print("done writing"));

        _levelData.removeWhere((element) => element.numberOfNodes == numberOfNodes);

        _levelData.insert(numberOfNodes - 4, cvLevels);
        notifyListeners();
      } catch (e) {}
    } else {
      return;
    }
  }
}
