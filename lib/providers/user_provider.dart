import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as user_model;
import 'package:instagram_clone/services/auth_services.dart';

class UserProvider extends ChangeNotifier {
  user_model.User? _user;

  user_model.User get getUser => _user!;

  Future<void> refreshUser() async {
    _user = await AuthServices().getUserDetails();
    notifyListeners();
  }
}
