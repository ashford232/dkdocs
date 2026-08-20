import 'package:dk_docs/app/models/document_model.dart';
import 'package:dk_docs/auth/models/user_model.dart';
import 'package:dk_docs/features/home/widgets/user_profile_photo.dart';
import 'package:dk_docs/shared/themes/app_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dk_docs/shared/resources/extension.dart';
import 'package:intl/intl.dart';

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

      onTap: () {
        if (kIsWeb) {
          GoRouter.of(context).go('/document/${doc.id}');
        } else {
          context.push('/document/${doc.id}');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),

        child: Column(
          crossAxisAlignment: .start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,

                  borderRadius: .circular(6),
                  border: Border.all(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.article,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    size: 30,
                  ),
                ),
              ),
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
