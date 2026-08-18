import 'package:flutter/material.dart';

Future<dynamic> showCustomSnackBar(BuildContext context, String content) async {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        showCloseIcon: true,
        behavior: .floating,
        content: Text(content),
      ),
    );
}
