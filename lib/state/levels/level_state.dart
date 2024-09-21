import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_of_trees/Model/CVAnswer.dart';
import 'package:game_of_trees/Model/CVLevels.dart';

part 'level_state.freezed.dart';
part 'level_state.g.dart';

@freezed
class LevelState with _$LevelState {
  const factory LevelState({
    @Default([]) List<CVLevels> levelData,
    @Default(4) int currentNumberOfNodes,
    CVAnswer? currentLevel,
    CVAnswer? nextLevel,
    @Default(null)
    @JsonKey(includeFromJson: false, includeToJson: false)
    Rect? rect,
  }) = _LevelState;

  factory LevelState.fromJson(Map<String, dynamic> json) =>
      _$LevelStateFromJson(json);

  factory LevelState.empty() => LevelState(
        levelData: [],
        currentNumberOfNodes: 4,
        currentLevel: null,
        nextLevel: null,
        rect: null,
      );
}
