import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as user_model;
import 'package:instagram_clone/services/upload_file.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/constants.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required File? profilePicture,
    required String bio,
  }) async {
    final authRes = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    final String picUrl = profilePicture != null
        ? await upload(profilePicture, FileDirectories.profilePicture.name)
        : userIcon;

    final user = user_model.User(
        username: username,
        email: email,
        uid: authRes.user!.uid,
        bio: bio,
        profilePicture: picUrl,
        followers: [],
        following: [],
        favorites: []);

    CollectionReference usersRef =
        _firestore.collection(DBCollections.users.name);
    await usersRef.doc(authRes.user!.uid).set(user.toJson());
  }

  Future<void> loginUser(String email, String password) async {
    final authRes = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    log(authRes.user!.uid);
  }

  Future<user_model.User> getUserDetails() async {
    final CollectionReference users =
        _firestore.collection(DBCollections.users.name);
    final DocumentSnapshot snapshot =
        await users.doc(_auth.currentUser!.uid).get();
    final snapData =
        snapshot.data() as Map<String, dynamic>; // Map is a subclass of Object
    return user_model.User.fromJson(snapData);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    showToast("Signed out!");
  }
}
