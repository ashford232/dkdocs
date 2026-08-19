import 'package:dk_docs/features/documents/view/document_edit_view.dart';
import 'package:dk_docs/features/documents/view/document_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dk_docs/auth/views/callback.dart';
import 'package:dk_docs/auth/views/enter_password.dart';
import 'package:dk_docs/auth/views/login.dart';
import 'package:dk_docs/auth/wrapper/auth_wrapper.dart';
import 'package:dk_docs/features/home/home.dart';
import 'package:dk_docs/shared/resources/error_page.dart';
import 'package:dk_docs/auth/providers/auth_provider.dart'; // Add this import

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._ref) {
    _ref.listen(userNotifierProvider, (_, _) => notifyListeners());
    _ref.listen(userProvider, (_, _) => notifyListeners());
  }
  final Ref _ref;
}

final authRoutes = [
  GoRoute(path: Login.route, builder: (context, state) => const Login()),
  GoRoute(
    path: WebAuthCallback.route,
    builder: (context, state) => const WebAuthCallback(),
  ),
  GoRoute(path: '/', builder: (context, state) => const AuthWrapper()),
  GoRoute(path: Home.route, builder: (context, state) => const Home()),
  GoRoute(
    path: EnterPassword.route,
    redirect: (context, state) {
      if (state.extra == null || state.extra is! EnterPasswordState) {
        return '/';
      }
      return null;
    },
    builder: (context, state) {
      final result = state.extra as EnterPasswordState;
      return EnterPassword(enterPasswordState: result);
    },
  ),
];
final documentRoutes = [
  GoRoute(path: '/document', redirect: (_, _) => Home.route),
  GoRoute(
    path: DocumentView.route,

    builder: (context, state) {
      return DocumentView(documentId: state.pathParameters['id']!);
    },
  ),

  GoRoute(
    path: DocumentEditView.route,
    builder: (context, state) {
      return DocumentEditView(documentId: state.pathParameters['id']!);
    },
  ),
];
final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    routes: [...authRoutes, ...documentRoutes],

    redirect: (context, state) {
      final isInitializing = ref.read(userProvider).isLoading;
      final user = ref.read(userNotifierProvider);
      final isLoggedIn = user != null;
      final isAuthRoute =
          state.uri.path == Login.route ||
          state.uri.path == WebAuthCallback.route ||
          state.uri.path == EnterPassword.route;

      if (isInitializing) {
        return null;
      }
      if (!isLoggedIn && !isAuthRoute) {
        return Login.route;
      }

      if (isLoggedIn && isAuthRoute) {
        return Home.route;
      }

      return null;
    },
  );
});
