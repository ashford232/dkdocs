import 'package:dk_docs/auth/providers/auth_provider.dart';
import 'package:dk_docs/auth/repo/auth_repo.dart';
import 'package:dk_docs/auth/views/enter_password.dart';
import 'package:dk_docs/shared/resources/constants.dart';
import 'package:dk_docs/shared/themes/app_fonts.dart';
import 'package:dk_docs/shared/ui/buttons.dart';
import 'package:dk_docs/shared/ui/snackbar.dart';
import 'package:dk_docs/shared/ui/text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Login extends ConsumerStatefulWidget {
  final String? error;
  const Login({super.key, this.error});
  static const route = "/login";
  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  @override
  void initState() {
    super.initState();

    if (widget.error != null) {
      showCustomSnackBar(context, widget.error!);
    }
  }

  AuthRepo get authRepo => ref.read(authRepoProvider);

  Future<void> signInWithGoogle({bool web = false}) async {
    try {
      setState(() {
        isGoogleLoading = true;
      });
      final result = await authRepo.signInWithGoogle();

      if (result.user != null) {
        ref.read(userNotifierProvider.notifier).updateUser(result.user!);

        if (mounted) {
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
        isGoogleLoading = false;
      });
    }
  }

  bool isGoogleLoading = false;
  bool isGithubLoading = false;
  bool isLoading = false;

  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: .topCenter,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 400),

              child: SizedBox(
                child: Padding(
                  padding: kIsWeb
                      ? const .symmetric(horizontal: 20, vertical: 30)
                      : const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: kIsWeb ? .center : .start,
                    children: [
                      //
                      if (kIsWeb) ...[
                        Row(
                          crossAxisAlignment: .center,
                          mainAxisAlignment: .center,
                          children: [
                            Image.asset(
                              Constants.dkDocsLogo,
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              Constants.appName,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: AppFonts.robotoCondensed,
                                fontWeight: .bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        Text(
                          "Your documents, your workspace",
                          textAlign: .start,
                          style: TextStyle(
                            fontSize: 23,
                            fontFamily: AppFonts.alegreya,
                            fontWeight: .bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ] else ...[
                        const SizedBox(height: 45),
                        Text(
                          "Your documents, your workspace",
                          textAlign: .start,
                          style: TextStyle(
                            fontSize: kIsWeb ? 20 : 26,
                            fontFamily: kIsWeb ? null : AppFonts.alegreya,
                            fontWeight: .bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          textAlign: .start,

                          "Sign in to access your documents and keep your important files in one place",
                        ),
                        const SizedBox(height: 40),
                      ],
                      customAppButton(
                        isLoading: isGoogleLoading,
                        context: context,
                        text: "Sign in with Google",
                        onPressed: signInWithGoogle,
                        size: Size(double.infinity, 60),
                        radius: 30,
                        image: Image.asset(
                          Constants.googleLogo,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (kIsWeb) ...[
                        customAppButton(
                          context: context,
                          text: "Sign in with Github",
                          isLoading: isGithubLoading,
                          onPressed: () async {
                            try {
                              setState(() {
                                isGithubLoading = true;
                              });
                              await authRepo.continueWithGitHub();
                            } catch (e) {
                              debugPrint(e.toString());
                            } finally {
                              setState(() {
                                isGithubLoading = false;
                              });
                            }
                          },
                          size: Size(double.infinity, 60),
                          radius: 30,
                          image: Image.asset(
                            Constants.githubLogo,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      //
                      customTextField(
                        autofillHints: const {AutofillHints.email},
                        context: context,
                        controller: emailController,
                        labelText: ' or use Email',
                        hintText: 'john@example.com',
                      ),
                      const SizedBox(height: 10),
                      customAppButton(
                        radius: 30,
                        isPrimary: true,
                        context: context,
                        isLoading: isLoading,
                        size: Size(double.infinity, 60),

                        text: "Continue",
                        onPressed: () async {
                          if (emailController.text.isEmpty) {
                            showCustomSnackBar(
                              context,
                              'Please enter your email',
                            );
                            return;
                          }
                          if (!Constants.emailRegex.hasMatch(
                            emailController.text,
                          )) {
                            showCustomSnackBar(context, 'Invalid email');
                            return;
                          }
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            final result = await authRepo.checkEmailExists(
                              emailController.text.trim(),
                            );

                            if (result.exists && result.hasPassword) {
                              if (context.mounted) {
                                context.push(
                                  '/password',
                                  extra: EnterPasswordState(
                                    createAccount: false,
                                    email: emailController.text.trim(),
                                  ),
                                );
                              }
                            } else if (result.exists && !result.hasPassword) {
                              if (context.mounted) {
                                showCustomSnackBar(
                                  context,
                                  "This account was created with a social provider. Please continue with the provider you used to sign up.",
                                );
                              }
                            } else {
                              if (context.mounted) {
                                context.push(
                                  '/password',
                                  extra: EnterPasswordState(
                                    createAccount: true,
                                    email: emailController.text.trim(),
                                  ),
                                );

                                showCustomSnackBar(
                                  context,
                                  "No account found with this email.",
                                );
                              }
                            }
                          } catch (e) {
                            debugPrint(e.toString());
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
