import 'dart:developer';

import 'package:instagram_clone/data/data_provider/profile_data_provider.dart';
import 'package:instagram_clone/models/user.dart' as user_model;

class ProfileRepository {
  final ProfileDataProvider profileDataProvider;
  ProfileRepository({required this.profileDataProvider});

  Future<user_model.User> getUserByUid(String uid) async {
    try {
      final user = await profileDataProvider.getUserByUid(uid);
      return user_model.User.fromJson(user);
    } catch (e) {
      log("Error getting user by uid: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<List<user_model.User>> getUsersByUsername(String username) async {
    try {
      final users = await profileDataProvider.getUsersByUsername(username);
      return users;
    } catch (e) {
      log("Error getting users by username: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<void> follow(String uid, String idToBeFollowed) async {
    try {
      await profileDataProvider.follow(uid, idToBeFollowed);
    } catch (e) {
      log("Error following user: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<void> unfollow(String uid, String idToBeUnFollowed) async {
    try {
      await profileDataProvider.unfollow(uid, idToBeUnFollowed);
    } catch (e) {
      log("Error unfollowing user: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<void> addToFavorites(String uid, String postId) async {
    try {
      await profileDataProvider.addToFavorites(uid, postId);
    } catch (e) {
      log("Error adding to favorites: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<void> removeFromFavorites(String uid, String postId) async {
    try {
      await profileDataProvider.removeFromFavorites(uid, postId);
    } catch (e) {
      log("Error removing from favorites: ${e.toString()}");
      throw e.toString();
    }
  }
}
