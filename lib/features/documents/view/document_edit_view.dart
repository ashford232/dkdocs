import 'dart:async';
import 'dart:convert';

import 'package:dk_docs/app/models/document_model.dart';
import 'package:dk_docs/app/providers/document_provider.dart';
import 'package:dk_docs/features/documents/widgets/document_editor.dart';
import 'package:dk_docs/features/documents/widgets/editor_toolbars.dart';
import 'package:dk_docs/shared/ui/snackbar.dart';
import 'package:dk_docs/shared/ui/text_field.dart';
import 'package:dk_docs/shared/ui/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DocumentEditView extends ConsumerStatefulWidget {
  final DocumentModel document;
  const DocumentEditView({super.key, required this.document});
  static const route = "/edit";

  @override
  ConsumerState<DocumentEditView> createState() => _DocumentEditViewState();
}

class _DocumentEditViewState extends ConsumerState<DocumentEditView> {
  final TextEditingController _titleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  void initializeDocument(String value) {
    _titleController.text = value;
  }

  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();

    if (widget.document.content.isNotEmpty) {
      _quillController.document = Document.fromJson(widget.document.content);
    }

    if (widget.document.title.isNotEmpty) {
      _titleController.text = widget.document.title;
    }
    _quillController.addListener(_onQuillChanged);
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    _quillController.dispose();
    _titleController.dispose();
    _isUpdating.dispose();

    super.dispose();
  }

  Future<void> updateDocument(String title) async {
    try {
      _isUpdating.value = true;
      final content = _quillController.document.toDelta().toJson();
      await ref
          .read(documentRepoProvider)
          .updateDocument(
            DocumentModel(
              id: widget.document.id,
              uid: "",
              title: title,
              content: content,
              createdAt: null,
              updatedAt: null,
            ),
          );

      _lastContent = jsonEncode(content);

      await refreshAllDocumentsProvider(ref);
      ref.invalidate(getDocumentProvider(widget.document.id));
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        showCustomSnackBar(context, e.toString());
      }
    } finally {
      if (mounted) {
        _isUpdating.value = false;
      }
    }
  }

  Future<void> _onQuillChanged() async {
    _updateTimer?.cancel();

    _updateTimer = Timer(const Duration(milliseconds: 800), () async {
      final content = jsonEncode(_quillController.document.toDelta().toJson());

      if (content == _lastContent) return;

      await updateDocument(_titleController.text);
    });
  }

  String _lastContent = '';
  final ValueNotifier<bool> _isUpdating = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kIsWeb ? 80 : null,
        titleSpacing: kIsWeb ? 5 : 0,
        leading: kIsWeb ? leadingToHome(context) : null,
        title: Column(
          crossAxisAlignment: .start,
          children: [
            IntrinsicWidth(
              child: customTextField(
                radius: 4,
                padding: .all(kIsWeb ? 8 : 6),
                context: context,
                hintText: 'Untitled Document',
                controller: _titleController,
                onFieldSubmitted: (val) => updateDocument(val),
              ),
            ),
            if (kIsWeb) const SizedBox(height: 5),
            ValueListenableBuilder<bool>(
              valueListenable: _isUpdating,
              builder: (context, isUpdating, _) {
                if (isUpdating) {
                  return Row(
                    children: [
                      appIndicator(context, size: 5, strokeWidth: 1),
                      const SizedBox(width: 5),
                      const Text("Syncing", style: TextStyle(fontSize: 10)),
                    ],
                  );
                }

                return const Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 10),
                    SizedBox(width: 5),
                    Text("Saved", style: TextStyle(fontSize: 10)),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {},
            icon: Icon(Icons.more_horiz),
            style: IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Divider(height: 1),
          const SizedBox(height: 10),
          if (kIsWeb) WebEditorToolbar(quillController: _quillController),
          DocumentEditor(quillController: _quillController),
          if (!kIsWeb) ...[
            Divider(height: 1),
            MobileEditorToolbar(quillController: _quillController),
          ],
        ],
      ),
    );
  }
}
