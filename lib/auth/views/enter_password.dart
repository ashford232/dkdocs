import 'package:dk_docs/auth/providers/auth_provider.dart';
import 'package:dk_docs/auth/repo/auth_repo.dart';
import 'package:dk_docs/shared/ui/buttons.dart';
import 'package:dk_docs/shared/ui/snackbar.dart';
import 'package:dk_docs/shared/ui/text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EnterPassword extends ConsumerStatefulWidget {
  final EnterPasswordState enterPasswordState;
  const EnterPassword({super.key, required this.enterPasswordState});
  static const route = "/password";

  bool get isCreate => enterPasswordState.createAccount == true;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnterPasswordState();
}

class _EnterPasswordState extends ConsumerState<EnterPassword> {
  AuthRepo get authRepo => ref.read(authRepoProvider);

  Future<void> createAccount() async {
    final res = valedate();
    if (!res) return;
    try {
      setState(() {
        isLoading = true;
      });

      final result = await authRepo.signUpWithEmailAndPassword(
        email: widget.enterPasswordState.email,
        password: passwordController.text.trim(),
        name: nameController.text,
      );
      if (result.user != null) {
        ref.read(userNotifierProvider.notifier).updateUser(result.user!);
        if (mounted) {
          context.pop();

          showCustomSnackBar(context, "Account Created");
        }
      }

      if (result.error != null) {
        if (mounted) {
          showCustomSnackBar(context, result.error!.err);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        showCustomSnackBar(context, e.toString());
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> confirmPassword() async {
    final res = valedate();
    if (!res) return;
    try {
      setState(() {
        isLoading = true;
      });

      final result = await authRepo.signInWithEmailAndPassword(
        email: widget.enterPasswordState.email,
        password: passwordController.text.trim(),
      );
      if (result.user != null) {
        ref.read(userNotifierProvider.notifier).updateUser(result.user!);
        if (mounted) {
          context.pop();

          showCustomSnackBar(context, "Logged in");
        }
      }

      if (result.error != null) {
        if (mounted) {
          showCustomSnackBar(context, result.error!.err);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool valedate() {
    if (nameController.text.trim().isEmpty && widget.isCreate) {
      showCustomSnackBar(context, "Please enter your name.");
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      showCustomSnackBar(context, "Please enter your password.");
      return false;
    }

    if (passwordController.text.trim().length < 8) {
      showCustomSnackBar(
        context,
        "Password must be at least 8 characters long.",
      );
      return false;
    }

    return true;
  }

  bool isLoading = false;

  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Align(
        alignment: kIsWeb ? .topCenter : .topStart,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),

              child: Padding(
                padding: kIsWeb
                    ? const .symmetric(horizontal: 20, vertical: 30)
                    : const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      widget.isCreate
                          ? "Create Account"
                          : "Enter your password",
                      textAlign: .start,
                      style: kIsWeb
                          ? theme.textTheme.headlineSmall
                          : theme.textTheme.titleLarge,
                    ),
                    Text(
                      widget.enterPasswordState.email,
                      textAlign: .start,
                      style: kIsWeb
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.titleMedium,
                    ),

                    const SizedBox(height: 20),

                    if (widget.isCreate) ...[
                      customTextField(
                        autofillHints: const {AutofillHints.name},
                        context: context,
                        controller: nameController,
                        labelText: 'Full name',
                        hintText: "eg. John Brown",
                      ),
                      const SizedBox(height: 5),
                    ],

                    customTextField(
                      obscureText: !showPassword,
                      autofillHints: const {AutofillHints.password},
                      context: context,

                      controller: passwordController,
                      labelText: 'Password',
                      hintText: widget.isCreate
                          ? 'Enter a strong password'
                          : "Enter your password",
                    ),
                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Checkbox(
                          value: showPassword,
                          onChanged: (value) {
                            setState(() {
                              showPassword = value ?? false;
                            });
                          },
                        ),
                        Text('Show Password'),
                      ],
                    ),
                    const SizedBox(height: 5),
                    customAppButton(
                      radius: 25,
                      context: context,
                      isLoading: isLoading,

                      size: Size(double.infinity, 50),
                      text: widget.isCreate ? "Create Account" : "Continue",
                      onPressed: widget.isCreate
                          ? createAccount
                          : confirmPassword,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EnterPasswordState {
  final bool createAccount;
  final String email;

  EnterPasswordState({required this.createAccount, required this.email});
}
