import 'package:flutter/material.dart';

Widget appIndicator(
  BuildContext context, {
  double? size,
  Color? color,
  double? strokeWidth,
}) {
  return SizedBox(
    width: size ?? 18,
    height: size ?? 18,
    child: CircularProgressIndicator(
      color: color,
      strokeWidth: strokeWidth ?? 3.5,
      strokeCap: .round,
    ),
  );
}
