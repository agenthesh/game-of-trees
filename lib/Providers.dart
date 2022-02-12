import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_of_trees/Model/levelData.dart';

final remainingNodeProvider = StateProvider<int>((ref) {
  return 0;
});

final cvProvider = StateProvider<Map<String, int>>((ref) {
  return {};
});

final cvCheckProvider = StateProvider<bool>((ref) {
  return false;
});

final levelDataProvider = ChangeNotifierProvider((ref) => LevelData());
