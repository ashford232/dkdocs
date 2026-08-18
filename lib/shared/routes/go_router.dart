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

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: notifier,
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    routes: authRoutes,

    redirect: (context, state) {
      final isInitializing = ref.read(userProvider).isLoading;
      final user = ref.read(userNotifierProvider);
      final isLoggedIn = user != null;
final currentLocation = state.matchedLocation;
      final isAuthRoute =
          state.uri.path == Login.route ||
          state.uri.path == WebAuthCallback.route ||
          state.uri.path == EnterPassword.route;

if (isInitializing) {
        if (currentLocation != '/') {
          return Home.route; 
        }
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
