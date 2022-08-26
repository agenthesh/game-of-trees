import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {
  final SharedPreferences prefs;
  late FirebaseDatabase database;
  late String userID;
  late DatabaseReference nodeRef;
  late DatabaseReference currentLevelRef;

  FirebaseService(this.prefs) {
    database = FirebaseDatabase.instance;
    userID = prefs.getString("userID")!;
    nodeRef = database.ref(userID).child("nodes");
  }

  void startNewLevelEvent({required int numberOfNodes, required Map characteristicVector}) {
    currentLevelRef = nodeRef.child("node$numberOfNodes").child("levels").push();

    currentLevelRef.child("characteristicVector").set(characteristicVector);
  }

  void addNodeEvent({required String nodeLabel, required String gridPosition}) {
    currentLevelRef.child("activities").push().set(
      {
        "eventName": "nodeAdded",
        "timeStamp": DateTime.now().toIso8601String(),
        "data": {"nodeLabel": nodeLabel, "gridPosition": gridPosition}
      },
    );
  }

  void removeNodeEvent({required String nodeLabel, required String gridPosition}) {
    currentLevelRef.child("activities").push().set(
      {
        "eventName": "nodeRemoved",
        "timeStamp": DateTime.now().toIso8601String(),
        "data": {"nodeLabel": nodeLabel, "gridPosition": gridPosition}
      },
    );
  }

  void addEdgeEvent({required String startNodeLabel, required String endNodeLabel}) {
    currentLevelRef.child("activities").push().set(
      {
        "eventName": "edgeAdded",
        "timeStamp": DateTime.now().toIso8601String(),
        "data": {"startNode": startNodeLabel, "endNode": endNodeLabel}
      },
    );
  }

  void removeEdgeBetweenEvent({required String startNodeLabel, required String endNodeLabel}) {
    currentLevelRef.child("activities").push().set(
      {
        "eventName": "edgeRemoved",
        "timeStamp": DateTime.now().toIso8601String(),
        "data": {"startNode": startNodeLabel, "endNode": endNodeLabel}
      },
    );
  }

  void resetLevelEvent({required int resetCount}) {
    currentLevelRef.child("activities").push().set(
      {
        "eventName": "resetLevel",
        "timeStamp": DateTime.now().toIso8601String(),
        "data": {"resetCount": resetCount}
      },
    );
  }

  void checkAnswerEvent({required bool passLevel, required int checkCount}) {
    currentLevelRef.child("activities").push().set(
      {
        "eventName": "checkAnswer",
        "timeStamp": DateTime.now().toIso8601String(),
        "data": {"checkCount": checkCount, "passLevel": passLevel}
      },
    );
  }

  void closeGameEvent() {
    currentLevelRef.child("activities").push().set(
      {
        "eventName": "closeGame",
        "timeStamp": DateTime.now().toIso8601String(),
      },
    );
  }
}
