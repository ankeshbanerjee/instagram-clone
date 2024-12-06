import 'dart:developer';
import 'dart:io';

import 'package:instagram_clone/data/data_provider/auth_data_provider.dart';
import 'package:instagram_clone/models/user.dart' as user_model;
import 'package:instagram_clone/utils/apputils.dart';

class AuthRepository {
  final AuthDataProvider authDataProvider;
  AuthRepository({required this.authDataProvider});

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required File? profilePicture,
    required String bio,
  }) async {
    try {
      await authDataProvider.registerUser(
          username: username,
          email: email,
          password: password,
          profilePicture: profilePicture,
          bio: bio);
    } catch (e) {
      log("error in register user: ${e.toString()}");
      throw (e.toString());
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await authDataProvider.loginUser(email, password);
    } catch (e) {
      log("error in login user: ${e.toString()}");
      throw (e.toString());
    }
  }

  Future<user_model.User> getUserDetails() async {
    try {
      final details = await authDataProvider.getUserDetails();
      return user_model.User.fromJson(details);
    } catch (e) {
      log("error in get user details: ${e.toString()}");
      throw (e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await authDataProvider.signOut();
      showToast("Signed Out!");
    } catch (e) {
      log("error in sign out: ${e.toString()}");
      throw (e.toString());
    }
  }
}
