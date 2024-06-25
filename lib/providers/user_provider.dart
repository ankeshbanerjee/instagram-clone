import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as user_model;
import 'package:instagram_clone/services/auth_services.dart';
import 'package:instagram_clone/utils/apputils.dart';

class UserProvider extends ChangeNotifier {
  user_model.User? _user;

  user_model.User get getUser => _user!;

  Future<void> refreshUser() async {
    try {
      _user = await AuthServices().getUserDetails();
      notifyListeners();
    } catch (e) {
      showToast(e.toString());
    }
  }

  void removeUser() {
    _user = null;
  }
}
