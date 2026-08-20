import 'package:dk_docs/features/documents/widgets/editor_toolbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:dk_docs/app/repositories/socket_repo.dart';
import 'package:dk_docs/features/documents/widgets/document_editor.dart';

class CollaborativeView extends StatefulWidget {
  final CollaborationState collaborationState;
  static const route = "/collaboration";
  const CollaborativeView({super.key, required this.collaborationState});

  @override
  State<CollaborativeView> createState() => _CollaborativeViewState();
}

class _CollaborativeViewState extends State<CollaborativeView> {
  late final QuillController _quillController;
  final SocketRepo _socketRepo = SocketRepo();

  @override
  void initState() {
    super.initState();

    final doc = widget.collaborationState.initialContent.isNotEmpty
        ? Document.fromJson(widget.collaborationState.initialContent)
        : Document();
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );

    _socketRepo.joinRoom(widget.collaborationState.documentId);

    _socketRepo.changeListener((data) {
      if (data['delta'] != null && mounted) {
        _quillController.compose(
          Delta.fromJson(data['delta']),
          _quillController.selection,
          ChangeSource.remote,
        );
      }
    });

    _quillController.document.changes.listen((event) {
      if (event.source == ChangeSource.local) {
        _socketRepo.typing({
          'room': widget.collaborationState.documentId,
          'delta': event.change.toJson(),
        });
      }
    });
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Collaborative Editor")),
      body: Column(
        children: [
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

class CollaborationState {
  final String documentId;
  final List<dynamic> initialContent;

  CollaborationState({required this.documentId, required this.initialContent});
}
