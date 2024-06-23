import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/services/upload_file.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:uuid/uuid.dart';

class PostServices {
  final CollectionReference posts =
      FirebaseFirestore.instance.collection(DBCollections.posts.name);

  Future<void> uploadPost(
      {required String desc,
      required String uid,
      required String username,
      required File imageFile,
      required String profileImage}) async {
    try {
      final photoUrl =
          await upload(imageFile, FileDirectories.postPicture.name);
      final postId =
          const Uuid().v1(); // generates a unique id according to time
      final newPost = Post(
          description: desc,
          uid: uid,
          username: username,
          likes: [],
          postId: postId,
          datePublished: DateTime.now(),
          photoUrl: photoUrl,
          profileImage: profileImage);
      await posts.doc(postId).set(newPost.toJson());
    } catch (e) {
      showToast(e.toString());
    }
  }
}
