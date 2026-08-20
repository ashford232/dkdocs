import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class WebEditorToolbar extends StatelessWidget {
  const WebEditorToolbar({
    super.key,
    required this._quillController,
  });

  final QuillController _quillController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      clipBehavior: .hardEdge,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: .circular(50),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(5),
      child: QuillSimpleToolbar(
        controller: _quillController,
        config: QuillSimpleToolbarConfig(
          axis: .horizontal,
          multiRowsDisplay: false,
        ),
      ),
    );
  }
}

class MobileEditorToolbar extends StatelessWidget {
  const MobileEditorToolbar({
    super.key,
    required this._quillController,
  });

  final QuillController _quillController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(8.0),
      child: QuillSimpleToolbar(
        controller: _quillController,
    
        config: QuillSimpleToolbarConfig(
          axis: .horizontal,
          multiRowsDisplay: false,
        ),
      ),
    );
  }
}
