import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/data/repository/upload_repository.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:uuid/uuid.dart';

class PostDataProvider {
  final FirebaseFirestore fireStore;
  final CollectionReference posts;
  final UploadRepository uploadRepository;
  PostDataProvider({required this.fireStore, required this.uploadRepository})
      : posts = fireStore.collection(DBCollections.posts.name);

  Future<void> uploadPost(
      {required String desc,
      required String uid,
      required String username,
      required File imageFile,
      required String profileImage}) async {
    final photoUrl = await uploadRepository.upload(
        imageFile, FileDirectories.postPicture.name);
    final postId = const Uuid().v1(); // generates a unique id according to time
    final newPost = Post(
        description: desc,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        photoUrl: photoUrl,
        profileImage: profileImage,
        commentCount: 0);
    await posts.doc(postId).set(newPost.toJson());
  }

  Future<void> likePost({required String postId, required String uid}) async {
    final post = await posts.doc(postId).get();
    if (!post['likes'].contains(uid)) {
      await posts.doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    } else {
      await posts.doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    }
  }

  Future<void> deletePost({required String postId}) async {
    await posts.doc(postId).delete();
  }

  Future<void> addComment(
      {required String postId,
      required String content,
      required String username,
      required String uid,
      required String profilePic}) async {
    final commentId = const Uuid().v1();
    final cmnt = Comment(
        username: username,
        uid: uid,
        profilePic: profilePic,
        content: content,
        commentId: commentId,
        datePublished: DateTime.now(),
        likes: []);
    await posts
        .doc(postId)
        .collection(DBCollections.comments.name)
        .doc(commentId)
        .set(cmnt.toJson());
    await posts.doc(postId).update({'commentCount': FieldValue.increment(1)});
  }

  Future<void> likeComment({
    required String postId,
    required String commentId,
    required String uid,
  }) async {
    final comment = await posts
        .doc(postId)
        .collection(DBCollections.comments.name)
        .doc(commentId)
        .get();
    if (comment['likes'].contains(uid)) {
      await posts
          .doc(postId)
          .collection(DBCollections.comments.name)
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      await posts
          .doc(postId)
          .collection(DBCollections.comments.name)
          .doc(commentId)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getPostsByUid(String uid) async {
    final postsDocs = await posts.where('uid', isEqualTo: uid).get();
    return postsDocs.docs;
  }

  Stream<QuerySnapshot<Object?>> getAllPosts() async* {
    yield* posts.orderBy('datePublished', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getFavorites(List<dynamic> favorites) async* {
    yield* posts.where(FieldPath.documentId, whereIn: favorites).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getComments(String postId) async* {
    yield* posts
        .doc(postId)
        .collection(DBCollections.comments.name)
        .orderBy('datePublished', descending: true)
        .snapshots();
  }
}
