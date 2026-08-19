import 'package:dk_docs/shared/resources/extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DocumentEditor extends StatefulWidget {
  final QuillController _quillController;
  const DocumentEditor({super.key, required this._quillController});

  @override
  State<DocumentEditor> createState() => _DocumentEditorState();
}

class _DocumentEditorState extends State<DocumentEditor> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: MaxWidthContainer(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: .circular(10),
            border: kIsWeb
                ? Border.all(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  )
                : null,
          ),
          margin: kIsWeb
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0)
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: QuillEditor.basic(
            controller: widget._quillController,
            config: QuillEditorConfig(
              showCursor: !widget._quillController.readOnly,
            ),
          ),
        ),
      ),
    );
  }
}
