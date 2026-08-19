import 'package:dk_docs/shared/resources/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget appIndicator(
  BuildContext context, {
  double? size,
  Color? color,
  double? strokeWidth,
}) {
  return SizedBox(
    width: size ?? 25,
    height: size ?? 25,
    child: CircularProgressIndicator(
      color: color,
      strokeWidth: strokeWidth ?? 3.5,
      strokeCap: .round,
    ),
  );
}

Widget leadingToHome(BuildContext context) {
  return InkWell(
    onTap: () async {
      await context.push('/');
    },
    child: Center(
      child: Image.asset(Constants.dkDocsLogo, width: 25, height: 25),
    ),
  );
}
