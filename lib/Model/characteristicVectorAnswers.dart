class CharacteristicVectorAnswers {
  int numberOfNodes;
  List<Map<String, int>> listOfVectors;

  CharacteristicVectorAnswers(
      {required this.numberOfNodes, required this.listOfVectors});

  factory CharacteristicVectorAnswers.fromJson(Map<String, dynamic> json) {
    return CharacteristicVectorAnswers(
      numberOfNodes: json['numberOfNodes'],
      listOfVectors: json['characteristicVectors'],
    );
  }
}
