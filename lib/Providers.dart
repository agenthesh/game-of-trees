import 'package:flutter_riverpod/flutter_riverpod.dart';

final remainingNodeProvider = StateProvider<int>((ref) {
  return 0;
});

final cvProvider = StateProvider<Map<String, int>>((ref) {
  return {};
});

final cvCheckProvider = StateProvider<bool>((ref) {
  return false;
});

final isAcyclicProvider = StateProvider<bool>(((ref) {
  return true;
}));

final isConnectedProvider = StateProvider<bool>(((ref) {
  return true;
}));
