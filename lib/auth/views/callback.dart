import 'package:dk_docs/auth/providers/auth_provider.dart';
import 'package:dk_docs/auth/views/login.dart';
import 'package:dk_docs/shared/resources/constants.dart';
import 'package:dk_docs/shared/ui/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WebAuthCallback extends ConsumerStatefulWidget {
  const WebAuthCallback({super.key});
  static const route = "/auth/callback";

  @override
  ConsumerState<WebAuthCallback> createState() => _WebCallbackState();
}

class _WebCallbackState extends ConsumerState<WebAuthCallback> {
  @override
  void initState() {
    super.initState();
    handleCallback();
  }

  Future<void> handleCallback() async {
    final uri = Uri.base;

    final success = uri.queryParameters['success'];
    final email = uri.queryParameters['email'];
    final error = uri.queryParameters['error'];
    final token = uri.queryParameters['token'] ?? "";

    if (success == 'true' && email != null) {
      final authRepo = ref.read(authRepoProvider);
      final result = await authRepo.getUserData(newToken: token);

      if (result.user != null && mounted) {
        ref.read(userNotifierProvider.notifier).updateUser(result.user!);
        ref
            .read(localStorageRepoProvider)
            .setVal(key: Constants.tokenHeaderValue, value: token);

        context.go('/');
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error?.err ?? "Failed to load user data"),
          ),
        );
        context.go('/');
      }
    } else {
      debugPrint("error: $error");
      if (mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uri = Uri.base;
    final error = uri.queryParameters['error'];
    final success = uri.queryParameters['success'];
    final email = uri.queryParameters['email'];

    if (email == null || success == "false") {
      return Login();
    }
    return Scaffold(
      body: Center(
        child: error != null
            ? Text(error)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [appIndicator(context)],
              ),
      ),
    );
  }
}
