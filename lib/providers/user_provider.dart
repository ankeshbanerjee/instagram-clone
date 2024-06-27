import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/user.dart' as user_model;
import 'package:instagram_clone/services/auth_services.dart';
import 'package:instagram_clone/utils/apputils.dart';

class UserProvider extends Notifier<user_model.User?> {
  @override
  user_model.User? build() => null;

  Future<void> refreshUser() async {
    try {
      state = await AuthServices().getUserDetails();
    } catch (e) {
      showToast(e.toString());
    }
  }

  void removeUser() {
    state = null;
  }
}

final userProvider = NotifierProvider<UserProvider, user_model.User?>(() {
  return UserProvider();
});
