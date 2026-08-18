import 'package:dk_docs/auth/providers/auth_provider.dart';
import 'package:dk_docs/auth/views/login.dart';
import 'package:dk_docs/features/home/home.dart';
import 'package:dk_docs/shared/resources/constants.dart';
import 'package:dk_docs/shared/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    authenticate();
  }

  Future<void> authenticate() async {
    final token = await ref
        .read(localStorageRepoProvider)
        .getVal(key: Constants.tokenHeaderValue);

    if (token == null || token.isEmpty) {
      setState(() {});
      return;
    }

    final result = await ref
        .read(authRepoProvider)
        .getUserData(newToken: token);

    if (!mounted) return;

    if (result.user != null) {
      ref.read(userNotifierProvider.notifier).updateUser(result.user!);
      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    return userAsync.when(
      data: (user) {
        if (user == null) {
          return Login();
        }

        return Home();
      },
      error: (err, st) => Center(child: Text(err.toString())),
      loading: () => Center(child: appIndicator(context)),
    );
  }
}
