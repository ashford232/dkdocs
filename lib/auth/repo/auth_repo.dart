import 'dart:convert';
import 'package:dk_docs/auth/models/error_model.dart';
import 'package:dk_docs/auth/models/user_model.dart';
import 'package:dk_docs/auth/providers/auth_provider.dart';
import 'package:dk_docs/auth/repo/local_storage_repo.dart';
import 'package:dk_docs/shared/resources/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AuthRepo {
  final GoogleSignIn _googleSignIn;
  final http.Client _client;
  final LocalStorageRepo _localStorageRepo;

  AuthRepo({
    required this._googleSignIn,
    required this._client,
    required this._localStorageRepo,
  });

  Future<void> logout(WidgetRef ref) async {
    try {
      _localStorageRepo.setVal(key: Constants.tokenHeaderValue, value: "");
      ref.read(userNotifierProvider.notifier).updateUser(null);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<({ErrorModel? error, UserModel? user})> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final uri = Uri.parse("${Constants.serverBaseUrl}/auth/google");
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        return (error: null, user: null);
      } else {
        await _googleSignIn.initialize(serverClientId: Constants.clientIdWeb);
        final GoogleSignInAccount account = await _googleSignIn.authenticate();

        final idToken = account.authentication.idToken;
        if (idToken == null) {
          throw Exception("Google ID token is missing");
        }
        return await authenticateMobileWithGoogle(idToken);
      }
    } catch (e) {
      debugPrint(e.toString());
      return (error: ErrorModel(err: e.toString()), user: null);
    }
  }

  Future<void> continueWithGitHub() async {
    final uri = Uri.parse("${Constants.serverBaseUrl}/auth/github");
    await launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  Future<({ErrorModel? error, UserModel? user})> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? photoUrl,
    DateTime? dob,
  }) async {
    try {
      final res = await _client.post(
        Uri.parse("${Constants.serverBaseUrl}/auth/signup"),
        body: jsonEncode({
          "email": email,
          "password": password,
          "name": name,
          "photoUrl": photoUrl,
          "dob": dob?.toIso8601String(),
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 201) {
        final token = data['token'];
        final resUser = data['user'];
        final userModel = UserModel(
          uid: resUser['_id'] ?? '',
          email: resUser['email'],
          name: resUser['name'],
          photoUrl: resUser['photoUrl'] ?? '',
          token: token,
        );
        _localStorageRepo.setVal(key: Constants.tokenHeaderValue, value: token);

        return (error: null, user: userModel);
      } else {
        return (
          error: ErrorModel(err: data['message'] ?? 'Signup failed'),
          user: null,
        );
      }
    } catch (e) {
      return (error: ErrorModel(err: e.toString()), user: null);
    }
  }

  Future<({ErrorModel? error, UserModel? user})> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.post(
        Uri.parse("${Constants.serverBaseUrl}/auth/login"),
        body: jsonEncode({"email": email, "password": password}),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final token = data['token'];
        final resUser = data['user'];
        final userModel = UserModel(
          uid: resUser['_id'] ?? '',
          email: resUser['email'],
          name: resUser['name'],
          photoUrl: resUser['photoUrl'] ?? '',
          token: token,
        );

        _localStorageRepo.setVal(key: Constants.tokenHeaderValue, value: token);

        return (error: null, user: userModel);
      } else {
        return (
          error: ErrorModel(err: data['message'] ?? 'Login failed'),
          user: null,
        );
      }
    } catch (e) {
      return (error: ErrorModel(err: e.toString()), user: null);
    }
  }

  Future<({ErrorModel? error, UserModel? user})> getUserData({
    String? newToken,
  }) async {
    try {
      final token = await _localStorageRepo.getVal(
        key: Constants.tokenHeaderValue,
      );
      final res = await _client.get(
        Uri.parse("${Constants.serverBaseUrl}/auth/me"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': newToken ?? token ?? "",
        },
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final resUser = data['user'];
        final userModel = UserModel(
          uid: resUser['_id'] ?? '',
          email: resUser['email'],
          name: resUser['name'],
          photoUrl: resUser['photoUrl'] ?? '',
          token: '',
        );
        return (error: null, user: userModel);
      } else {
        return (
          error: ErrorModel(err: data['message'] ?? 'Failed to fetch user'),
          user: null,
        );
      }
    } catch (e) {
      return (error: ErrorModel(err: e.toString()), user: null);
    }
  }

  Future<({bool exists, bool hasPassword})> checkEmailExists(
    String email,
  ) async {
    try {
      final res = await _client.post(
        Uri.parse("${Constants.serverBaseUrl}/auth/emailExist"),
        body: jsonEncode({"email": email}),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (
          exists: data['exists'] as bool,
          hasPassword:
              data['hasPassword'] as bool, // Default to true if missing
        );
      }
      return (exists: false, hasPassword: true);
    } catch (e) {
      debugPrint(e.toString());
      return (exists: false, hasPassword: true);
    }
  }

  Future<({ErrorModel? error, UserModel? user})> authenticateMobileWithGoogle(
    String idToken,
  ) async {
    final uri = Uri.parse("${Constants.serverBaseUrl}/auth/google/mobile");

    final response = await _client.post(
      uri,
      body: jsonEncode({"idToken": idToken}),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final token = data['token'];
      final resUser = data['user'];

      final userModel = UserModel(
        uid: resUser['_id'] ?? '',
        email: resUser['email'],
        name: resUser['name'],
        photoUrl: resUser['photoUrl'] ?? '',
        token: token,
      );
      _localStorageRepo.setVal(key: Constants.tokenHeaderValue, value: token);
      return (error: null, user: userModel);
    } else {
      final error = data['message'] ?? "An error occurred";
      return (error: ErrorModel(err: error), user: null);
    }
  }
}
