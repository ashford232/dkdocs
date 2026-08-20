import 'package:dk_docs/app/providers/document_provider.dart';
import 'package:dk_docs/app/repositories/document_repo.dart';
import 'package:dk_docs/auth/models/user_model.dart';
import 'package:dk_docs/auth/providers/auth_provider.dart';
import 'package:dk_docs/auth/views/login.dart';
import 'package:dk_docs/features/home/widgets/document_card.dart';
import 'package:dk_docs/features/home/widgets/user_profile_photo.dart';
import 'package:dk_docs/shared/resources/colors.dart';
import 'package:dk_docs/shared/resources/constants.dart';
import 'package:dk_docs/shared/resources/extension.dart';
import 'package:dk_docs/shared/themes/app_fonts.dart';
import 'package:dk_docs/shared/ui/snackbar.dart';
import 'package:dk_docs/shared/ui/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          context.push('/edit', extra: result);
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

          floatingActionButton: kIsWeb ? null : homeFAB(context, theme),
          appBar: homeAppBar(context, theme, user, ref),

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

  FloatingActionButton homeFAB(BuildContext context, ThemeData theme) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: .circular(50)),
      onPressed: createDocument,
      child: documentCreating
          ? appIndicator(
              context,
              color: getTextColor(theme.colorScheme.primary),
            )
          : Icon(Icons.add),
    );
  }

  AppBar homeAppBar(
    BuildContext context,
    ThemeData theme,
    UserModel user,
    WidgetRef ref,
  ) {
    return AppBar(
      titleSpacing: 0,
      title: Text(
        Constants.appName,
        style: TextStyle(fontFamily: AppFonts.hubotSans, fontWeight: .bold),
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
          onTap: () async {
            await ref.read(authRepoProvider).logout(ref);
          },
          child: customUserProfile(context: context, user: user),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
