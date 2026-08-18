import 'package:flutter/material.dart';

Widget customTextField({
  required BuildContext context,
  required TextEditingController controller,
  String? labelText,
  String? hintText,
  EdgeInsets? padding,
  Set<String>? autofillHints,
  bool? obscureText,
}) {
  final theme = Theme.of(context);
  InputBorder border = OutlineInputBorder(
    borderRadius: .circular(30),
    borderSide: BorderSide(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
    ),
  );
  return Column(
    crossAxisAlignment: .start,
    children: [
      if (labelText != null) ...[
        Text(labelText, style: TextStyle(fontSize: 13)),
        const SizedBox(height: 4),
      ],
      TextFormField(
        obscureText: obscureText ?? false,
        enableSuggestions: true,
        autofillHints: autofillHints,
        style: TextStyle(fontSize: 15, fontWeight: .w500),
        controller: controller,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontWeight: .w300),
          contentPadding:
              padding ?? EdgeInsets.symmetric(horizontal: 12, vertical: 17),
          isCollapsed: true,
          hintText: hintText,
          border: border,
          enabledBorder: border,
        ),
      ),
    ],
  );
}
