import 'package:dk_docs/auth/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null;
  }

  void updateUser(UserModel? user) {
    state = user;
  }
}
