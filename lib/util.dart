import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _listOfColors = [
  Colors.red,
  Colors.green,
  Colors.yellow,
  Colors.blue,
  Colors.purple,
  Colors.orange,
];

const _listOfColors2 = [
  Color(0xFF441151),
  Color(0xFF883677),
  Color(0xFFca61c3),
  Color(0xFFee85b5),
  Color(0xFFff958c), //Color(0xFF),
];

const _listOfColors3 = [
  Color(0xFF007f5f),
  Color(0xFF2b9348),
  Color(0xFF55a630),
  Color(0xFF80b918),
  Color(0xFFaacc00),
  Color(0xFFd4d700),
  Color(0xFFdddf00),
  Color(0xFFeeef20),
];

const _listOfColors4 = [
  Color(0xFFf9a620),
  Color(0xFFffd449),
  Color(0xFFaab03c),
  Color(0xFF548c2f),
  Color(0xFF104911),
];

const _listOfColors5 = [
  Color(0xFF16747e),
  Color(0xFF307f70),
  Color(0xFF4a8a62),
  Color(0xFF649554),
  Color(0xFF7ea046),
  Color(0xFF97ab38),
  Color(0xFFb1b62a),
  Color(0xFFcbc11c),
  Color(0xFFe5cc0e),
  Color(0xFFffd700),
];

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

Color getRandomColor() {
  return _listOfColors5[Random().nextInt(_listOfColors5.length)];
}

double getAngle(Offset startPoint, Offset endPoint) {
  return degrees(atan2(
    endPoint.dy - startPoint.dy,
    endPoint.dx - startPoint.dx,
  ));
}

Rect getFinalRect(Rect originalRect) {
  Rect finalRect;

  double angle = getAngle(originalRect.topLeft, originalRect.bottomRight);

  if ([0.0, 180.0].contains(angle)) {
    //if horizontal line -> height = 5, width = width.

    finalRect = Rect.fromLTWH(originalRect.left, originalRect.top, originalRect.size.width, 10);
  } else if ([90.0, 270.0].contains(angle)) {
    //if vertical line -> width = height, and height = 5.

    finalRect = Rect.fromLTWH(originalRect.left, originalRect.top, originalRect.size.height, 10);
  } else {
    //if diagonal line -> width is sqrt(width^2 + height^2), and height is 5.

    finalRect = Rect.fromLTWH(
      originalRect.left,
      originalRect.top,
      sqrt((originalRect.size.width * originalRect.size.width) + (originalRect.size.height * originalRect.size.height)),
      10,
    );
  }

  return finalRect;
}

Vector2 getStartPosition(double angle, Offset startPosition) {
  angle = degrees(angle);

  print(angle);

  if (angle == 0.0) {
    return Vector2(startPosition.dx, startPosition.dy - 5);
  } else if (angle == 180.0) {
    return Vector2(startPosition.dx, startPosition.dy + 5);
  } else if (angle == -90.0) {
    return Vector2(startPosition.dx - 5, startPosition.dy);
  } else if (angle == 90.0) {
    return Vector2(startPosition.dx + 5, startPosition.dy);
  } else if (angle < 0.0 && angle > -90.0) {
    return Vector2(startPosition.dx - 2.5, startPosition.dy - 2.5);
  } else if (angle > 0.0 && angle < 90.0) {
    return Vector2(startPosition.dx + 5, startPosition.dy);
  } else if (angle > 90.0 && angle < 180.0) {
    return Vector2(startPosition.dx + 5, startPosition.dy);
  } else if (angle > -180.0 && angle < -90.0) {
    return Vector2(startPosition.dx - 2.5, startPosition.dy + 5);
  } else {
    return Vector2(startPosition.dx, startPosition.dy);
  }
}

String formatCharacteristicVector(Map<String, int> charVector) {
  Map<String, int> temp = Map.from(charVector);
  temp.removeWhere((key, value) => value == 0);

  return temp.toString().replaceAll("{", "").replaceAll("}", "");
}
