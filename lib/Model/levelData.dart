import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_of_trees/Model/characteristicVectorAnswers.dart';

class LevelData with ChangeNotifier {
  List<CharacteristicVectorAnswers> _levelData = [];
  bool _error = false;
  String _errorMessage = "";

  List<CharacteristicVectorAnswers> get levelData => _levelData;
  bool get error => _error;
  String get errorMessage => _errorMessage;

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/gameData/vectorData.txt');
    final data = await json.decode(response);

    try {
      data['nodes'].forEach(
        (element) {
          levelData.add(
            CharacteristicVectorAnswers.fromJson(element),
          );
        },
      );
      _error = false;
    } catch (e) {
      _error = true;
      _errorMessage = e.toString();
      print(e.toString());
    }
    notifyListeners();
  }
}
