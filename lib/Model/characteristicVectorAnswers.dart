class CharacteristicVectorAnswers {
  int numberOfNodes;
  List<Map<String, int>> listOfVectors;

  CharacteristicVectorAnswers(
      {required this.numberOfNodes, required this.listOfVectors});

  factory CharacteristicVectorAnswers.fromJson(Map<String, dynamic> json) {
    List<Map<String, int>> temp = [];
    json['characteristicVectors'].forEach((element) {
      temp.add(Map.castFrom<String, dynamic, String, int>(element));
    });

    return CharacteristicVectorAnswers(
      numberOfNodes: json['numberOfNodes'],
      listOfVectors: temp,
    );
  }
}
