import 'package:dk_docs/shared/themes/app_fonts.dart';
import 'package:dk_docs/shared/ui/utils.dart';
import 'package:flutter/material.dart';

Widget customAppButton({
  required BuildContext context,
  required String text,
  IconData? icon,
  Widget? image,
  required VoidCallback onPressed,
  Size? size,
  bool? outlined,
  bool? filled,
  double? radius,
  bool? autoImplementTrailing = false,
  bool? isLoading,
  bool? isPrimary,
  String? loadingText,
  TextAlign? textAlign,
}) {
  final theme = Theme.of(context);
  return ElevatedButton.icon(
    iconAlignment: .start,

    style: ElevatedButton.styleFrom(
      minimumSize: size ?? Size(300, 50),

      shadowColor: Colors.transparent,
      elevation: 0,

      backgroundColor: filled == true
          ? theme.colorScheme.surfaceContainerHighest
          : outlined == true
          ? theme.colorScheme.surface
          : isPrimary == true
          ? theme.colorScheme.primary
          : theme.colorScheme.onSurface,
      foregroundColor: filled == true
          ? theme.colorScheme.onSurfaceVariant
          : outlined == true
          ? theme.colorScheme.onSurface
          : isPrimary == true
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(radius ?? 14),
        side: filled == true
            ? BorderSide.none
            : outlined != true
            ? BorderSide.none
            : BorderSide(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
              ),
      ),
    ),
    onPressed: isLoading == true ? null : onPressed,
    icon: icon != null ? Icon(icon) : image,
    label: IntrinsicWidth(
      child: Row(
        children: [
          Text(
            isLoading == true ? loadingText ?? text : text,
            textAlign: textAlign ?? TextAlign.center,
            style: .new(
              fontSize: 15,
              fontFamily: AppFonts.robotoCondensed,
              fontWeight: .w600,
            ),
          ),

          if (isLoading == true) ...[
            const SizedBox(width: 10),

            appIndicator(context),
          ] else
            const SizedBox(width: 10),

          if (autoImplementTrailing == true) ...[Icon(Icons.arrow_forward)],
        ],
      ),
    ),
  );
}
