import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/constants.dart';

class ProfileServices {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection(DBCollections.users.name);

  Future<User?> getUserByUid(String uid) async {
    try {
      final userDoc = await _users.doc(uid).get();
      final user = User.fromJson(userDoc.data() as Map<String, dynamic>);
      return user;
    } catch (e) {
      showToast(e.toString());
      return null;
    }
  }
}
