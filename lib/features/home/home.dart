import 'package:dk_docs/app/models/document_model.dart';
import 'package:dk_docs/app/providers/document_provider.dart';
import 'package:dk_docs/app/repositories/document_repo.dart';
import 'package:dk_docs/auth/models/user_model.dart';
import 'package:dk_docs/auth/providers/auth_provider.dart';
import 'package:dk_docs/auth/views/login.dart';
import 'package:dk_docs/features/home/widgets/user_profile_photo.dart';
import 'package:dk_docs/shared/resources/colors.dart';
import 'package:dk_docs/shared/resources/constants.dart';
import 'package:dk_docs/shared/resources/extension.dart';
import 'package:dk_docs/shared/themes/app_fonts.dart';
import 'package:dk_docs/shared/ui/snackbar.dart';
import 'package:dk_docs/shared/ui/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});
  static const route = "/home";

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  DocumentRepo get docRepo => ref.read(documentRepoProvider);

  Future<void> createDocument() async {
    try {
      setState(() {
        documentCreating = true;
      });
      final result = await docRepo.createDocument();

      if (result != null) {
        if (mounted) {
          context.push('/document/edit/${result.id}');

          showCustomSnackBar(context, "New Document Created.");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        showCustomSnackBar(context, e.toString());
      }
    } finally {
      setState(() {
        documentCreating = false;
      });
    }
  }

  bool documentCreating = false;
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final myDocumensAsync = ref.watch(getMyDocumentsProvider);
    final theme = Theme.of(context);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return Login();
        }

        return Scaffold(
          drawer: Drawer(),

          floatingActionButton: kIsWeb
              ? null
              : FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                  onPressed: createDocument,
                  child: documentCreating
                      ? appIndicator(
                          context,
                          color: getTextColor(theme.colorScheme.primary),
                        )
                      : Icon(Icons.add),
                ),
          appBar: AppBar(
            title: Text(
              Constants.appName,
              style: TextStyle(
                fontFamily: AppFonts.alegreya,
                fontWeight: .bold,
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              const SizedBox(width: 10),
              if (kIsWeb) ...[
                IconButton(
                  onPressed: createDocument,
                  icon: documentCreating
                      ? appIndicator(
                          context,
                          color: getTextColor(theme.colorScheme.primary),
                        )
                      : Icon(Icons.add),
                ),
                const SizedBox(width: 10),
              ],
              InkWell(
                onTap: () {},
                child: customUserProfile(context: context, user: user),
              ),
              const SizedBox(width: 12),
            ],
          ),

          body: RefreshIndicator(
            onRefresh: () => refreshAllDocumentsProvider(ref),
            child: MaxWidthContainer(
              child: myDocumensAsync.when(
                data: (documents) {
                  if (documents.isEmpty) {
                    return Center(child: Text("No Documenst yet"));
                  }

                  return UserDocumentsView(documents: documents, user: user);
                },
                error: (err, st) => Center(child: Text(err.toString())),
                loading: () => Center(child: appIndicator(context)),
              ),
            ),
          ),
        );
      },
      error: (err, st) => Scaffold(body: Center(child: Text(err.toString()))),
      loading: () => Scaffold(body: Center(child: appIndicator(context))),
    );
  }
}

class UserDocumentsView extends StatelessWidget {
  final List<DocumentModel> documents;
  final UserModel user;

  const UserDocumentsView({
    super.key,
    required this.documents,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveContext(context).responsivePadding,
      child: GridView.builder(
        itemCount: documents.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: ResponsiveContext(context).gridColumns,
          childAspectRatio: ResponsiveContext(context).gridAspectRatio,
        ),
        itemBuilder: (context, index) {
          final doc = documents[index];

          return documentGridCard(context: context, doc: doc, owner: user);
        },
      ),
    );
  }
}

Widget documentGridCard({
  required BuildContext context,
  required DocumentModel doc,
  required UserModel owner,
}) {
  final theme = Theme.of(context);
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: InkWell(
      hoverColor: theme.colorScheme.primary.withValues(alpha: 0.05),
      splashColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
      highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),

      borderRadius: .circular(4),
      onTap: () {
        if (kIsWeb) {
          GoRouter.of(context).go('/document/${doc.id}');
        } else {
          context.push('/document/${doc.id}');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),

        decoration: BoxDecoration(
          borderRadius: .circular(4),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),

        child: Column(
          crossAxisAlignment: .start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(),
                child: Center(
                  child: Icon(CupertinoIcons.doc_text_fill, size: 40),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              thickness: 0.5,
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  doc.title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.robotoCondensed,

                    fontSize: 18,
                  ),
                ),
                if (doc.createdAt != null)
                  Text(
                    DateFormat('MMM d, yyyy • h:mm a').format(doc.createdAt!),
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                const SizedBox(height: 5),

                Row(
                  children: [
                    customUserProfile(context: context, user: owner, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      owner.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: AppFonts.robotoCondensed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
