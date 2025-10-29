// this file is used to generate the color for the circle avatar of the user

import 'package:flutter/material.dart';

Color generateColorFromString(String? text) {
  if (text == null) {
    return Colors.white;
  }
  final hash = text.hashCode;
  final r = 100 + (hash & 0xFF) % 156;
  final g = 100 + ((hash >> 8) & 0xFF) % 156;
  final b = 100 + ((hash >> 16) & 0xFF) % 156;
  return Color.fromARGB(255, r, g, b);
}
