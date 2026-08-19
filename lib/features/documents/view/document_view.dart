import 'dart:convert';

import 'package:dk_docs/app/providers/document_provider.dart';
import 'package:dk_docs/features/documents/widgets/document_editor.dart';
import 'package:dk_docs/shared/ui/buttons.dart';
import 'package:dk_docs/shared/ui/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DocumentView extends ConsumerStatefulWidget {
  final String documentId;
  const DocumentView({super.key, required this.documentId});
  static const String route = "/document/:id";

  @override
  ConsumerState<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  final QuillController _quillController = QuillController.basic();

  String _lastContent = "";
  String content = "";
  int count = 1;
  @override
  Widget build(BuildContext context) {
    final documentAsync = ref.watch(getDocumentProvider(widget.documentId));
    return documentAsync.when(
      data: (document) {
        if (document == null) {
          return Scaffold(
            body: Center(
              child: Text("No Document found with the id ${widget.documentId}"),
            ),
          );
        }
        if (document.content.isEmpty && count == 1) {
          count = 2;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.push('/document/edit/${document.id}');
            }
          });
        }
        content = jsonEncode(document.content);

        if (_lastContent != content && document.content.isNotEmpty) {
          _quillController.document = Document.fromJson(document.content);
          _quillController.readOnly = true;
          _lastContent = content;
        } else {
          _quillController.readOnly = true;
        }

        return Scaffold(
          floatingActionButton: kIsWeb
              ? null
              : FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                  onPressed: () async {
                    await context.push('/document/edit/${document.id}');
                  },
                  child: Icon(Icons.edit_outlined),
                ),
          appBar: AppBar(
            titleSpacing: kIsWeb ? 5 : 0,
            leading: kIsWeb
                ? leadingToHome(context)
                : null,
            title: Text(document.title),
            actions: [
              if (kIsWeb)
                customAppButton(
                  radius: 26,
                  size: Size(100, 50),
                  context: context,
                  icon: Icons.edit_square,
                  text: "Edit",
                  onPressed: () async {
                    await context.push('/document/edit/${document.id}');
                  },
                ),
              const SizedBox(width: 12),
              const SizedBox(width: 12),
            ],
          ),

          body: Column(
            children: [DocumentEditor(quillController: _quillController)],
          ),
        );
      },
      error: (err, st) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(err.toString())),
      ),
      loading: () => Scaffold(
        appBar: AppBar(),
        body: Center(child: appIndicator(context)),
      ),
    );
  }
}
