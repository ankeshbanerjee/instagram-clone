import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as user_model;
import 'package:instagram_clone/utils/constants.dart';

class ProfileServices {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection(DBCollections.users.name);

  Future<user_model.User?> getUserByUid(String uid) async {
    final userDoc = await _users.doc(uid).get();
    final user =
        user_model.User.fromJson(userDoc.data() as Map<String, dynamic>);
    return user;
  }

  Future<List<user_model.User>> getUsersByUsername(String username) async {
    final userDoc =
        await _users.where('username', isGreaterThanOrEqualTo: username).get();
    final res = userDoc.docs
        .map((e) => user_model.User.fromJson(e.data() as Map<String, dynamic>))
        .where(
            (element) => element.uid != FirebaseAuth.instance.currentUser!.uid)
        .toList();
    return res;
  }

  Future<void> follow(String uid, String idToBeFollowed) async {
    await _users.doc(uid).update({
      'following': FieldValue.arrayUnion([idToBeFollowed])
    });
    await _users.doc(idToBeFollowed).update({
      'followers': FieldValue.arrayUnion([uid])
    });
  }

  Future<void> unfollow(String uid, String idToBeUnFollowed) async {
    await _users.doc(uid).update({
      'following': FieldValue.arrayRemove([idToBeUnFollowed])
    });
    await _users.doc(idToBeUnFollowed).update({
      'followers': FieldValue.arrayRemove([uid])
    });
  }

  Future<void> addToFavorites(String uid, String postId) async {
    await _users.doc(uid).update({
      'favorites': FieldValue.arrayUnion([postId])
    });
  }

  Future<void> removeFromFavorites(String uid, String postId) async {
    await _users.doc(uid).update({
      'favorites': FieldValue.arrayRemove([postId])
    });
  }
}
