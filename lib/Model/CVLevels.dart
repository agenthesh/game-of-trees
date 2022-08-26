import 'package:game_of_trees/Model/CVAnswer.dart';

class CVLevels {
  int numberOfNodes;
  List<CVAnswer> listOfVectors;

  CVLevels({required this.numberOfNodes, required this.listOfVectors});

  factory CVLevels.fromJson(Map<String, dynamic> json) {
    List<CVAnswer> temp = [];
    json['characteristicVectors'].forEach((element) {
      temp.add(CVAnswer.fromJson(element));
    });

    return CVLevels(
      numberOfNodes: json['numberOfNodes'],
      listOfVectors: temp,
    );
  }

  Map<String, dynamic> toJson() {
    return {"numberOfNodes": this.numberOfNodes, "characteristicVectors": this.listOfVectors};
  }
}
