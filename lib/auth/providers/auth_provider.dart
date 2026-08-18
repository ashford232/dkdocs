import 'package:dk_docs/auth/notifiers/user_notifier.dart';
import 'package:dk_docs/auth/repo/auth_repo.dart';
import 'package:dk_docs/auth/repo/local_storage_repo.dart';
import 'package:dk_docs/shared/resources/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final googleSignInProvider = Provider((ref) => GoogleSignIn.instance);
final httpClientProvider = Provider((ref) => http.Client());
final localStorageRepoProvider = Provider((ref) => LocalStorageRepo());
final authRepoProvider = Provider(
  (ref) => AuthRepo(
    googleSignIn: ref.watch(googleSignInProvider),
    client: ref.watch(httpClientProvider),
    localStorageRepo: ref.watch(localStorageRepoProvider),
  ),
);

final userNotifierProvider = NotifierProvider(() => UserNotifier());

final userProvider = FutureProvider((ref) async {
  final token = await ref
      .read(localStorageRepoProvider)
      .getVal(key: Constants.tokenHeaderValue);

  if (token == null || token.isEmpty) {
    return null;
  }

  final result = await ref.read(authRepoProvider).getUserData(newToken: token);

  if (result.user != null) {
    ref.read(userNotifierProvider.notifier).updateUser(result.user!);
  }
  return result.user;
});
