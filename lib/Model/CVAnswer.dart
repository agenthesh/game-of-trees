import 'package:flutter/foundation.dart';

class CVAnswer {
  bool isSolved;
  Map<String, int> characteristicVector;

  CVAnswer({required this.isSolved, required this.characteristicVector});

  factory CVAnswer.fromJson(Map<String, dynamic> json) {
    return CVAnswer(
      isSolved: json['isSolved'],
      characteristicVector: Map.from(json['vector']),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CVAnswer && mapEquals(this.characteristicVector, other.characteristicVector);
  }

  @override
  int get hashCode => characteristicVector.hashCode;

  Map<String, dynamic> toJson() {
    return {"isSolved": this.isSolved, "vector": this.characteristicVector};
  }
}
