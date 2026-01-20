import 'package:flutter/material.dart';

List< Color> quizColors = [red, blue, orange, green];

var red = const Color(0xFFD60D34),
    blue = const Color(0xFF1166CC),
    orange = const Color(0xFFD89E00),
    green = const Color(0xFF26890C),
    grey = const Color(0xFFD0CED9);

int paddingMedium = 16;

Color getRankColor(int rank) {
  switch (rank) {
    case 1:
      return Colors.amber.shade700;
    case 2:
      return Colors.grey.shade400;
    case 3:
      return Colors.orange.shade600;
    default:
      return Colors.blue.shade400;
  }
}
