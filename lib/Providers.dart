import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remainingNodeProvider = StateProvider<int>((ref) {
  return 5;
});

final cvProvider = StateProvider<String>((ref) {
  return "";
});

final cvCheckProvider = StateProvider<bool>((ref) {
  return false;
});
