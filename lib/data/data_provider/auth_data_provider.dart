import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as user_model;
import 'package:instagram_clone/services/upload_file.dart';
import 'package:instagram_clone/utils/constants.dart';

class AuthDataProvider {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthDataProvider({
    required this.auth,
    required this.firestore,
  });

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required File? profilePicture,
    required String bio,
  }) async {
    final authRes = await auth.createUserWithEmailAndPassword(
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
        firestore.collection(DBCollections.users.name);
    await usersRef.doc(authRes.user!.uid).set(user.toJson());
  }

  Future<void> loginUser(String email, String password) async {
    final authRes =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    log(authRes.user!.uid);
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    final CollectionReference users =
        firestore.collection(DBCollections.users.name);
    final DocumentSnapshot snapshot =
        await users.doc(auth.currentUser!.uid).get();
    final snapData =
        snapshot.data() as Map<String, dynamic>; // Map is a subclass of Object
    return snapData;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
