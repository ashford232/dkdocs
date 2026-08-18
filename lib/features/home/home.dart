import 'package:dk_docs/auth/providers/auth_provider.dart';
import 'package:dk_docs/auth/views/login.dart';
import 'package:dk_docs/features/home/widgets/user_profile_photo.dart';
import 'package:dk_docs/shared/resources/constants.dart';
import 'package:dk_docs/shared/ui/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Home extends ConsumerWidget {
  const Home({super.key});
  static const route = "/home";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    return userAsync.when(
      data: (user) {
        if (user == null) {
          return Login();
        }

        return Scaffold(
          drawer: Drawer(),

          floatingActionButton: kIsWeb
              ? null
              : FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                  onPressed: () {},
                  child: Icon(Icons.add),
                ),
          appBar: AppBar(
            title: Text(Constants.appName),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              IconButton(
                onPressed: () {},
                icon: customUserProfile(context: context, user: user),
              ),
              const SizedBox(width: 12),
            ],
          ),
        );
      },
      error: (err, st) => Scaffold(body: Center(child: Text(err.toString()))),
      loading: () => Scaffold(body: Center(child: appIndicator(context))),
    );
  }
}
