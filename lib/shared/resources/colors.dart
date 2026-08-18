import 'package:flutter/material.dart';

class CustomColors {
  static Color getUserColor(String uid) {
    return customColors[uid.hashCode.abs() % customColors.length];
  }

  static const customColors = [
    Color(0xFFE63946), // Crimson
    Color(0xFFD62828), // Red
    Color(0xFFF77F00), // Orange
    Color(0xFFF4A261), // Coral
    Color(0xFFE9C46A), // Golden
    Color(0xFF2A9D8F), // Teal
    Color(0xFF00897B), // Deep Teal
    Color(0xFF43A047), // Green
    Color(0xFF2E7D32), // Forest Green
    Color(0xFF00A8E8), // Cyan Blue
    Color(0xFF1976D2), // Blue
    Color(0xFF3949AB), // Indigo
    Color(0xFF5E35B1), // Deep Purple
    Color(0xFF7B2CBF), // Purple
    Color(0xFFC2185B), // Magenta
    Color(0xFFE91E63), // Pink
    Color(0xFFAD1457), // Deep Pink
    Color(0xFF6D4C41), // Brown
    Color(0xFF546E7A), // Blue Grey
    Color(0xFF455A64), // Slate
  ];
}

Color getTextColor(Color backgroundColor) {
  final brightness = backgroundColor.computeLuminance();

  return brightness > 0.5 ? Colors.black : Colors.white;
}
