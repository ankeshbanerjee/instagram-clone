import 'dart:developer';
import 'dart:io';

import 'package:instagram_clone/data/data_provider/post_data_provider.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/post.dart';

class PostRepository {
  final PostDataProvider postDataProvider;
  PostRepository({required this.postDataProvider});

  Future<void> uploadPost(
      {required String desc,
      required String uid,
      required String username,
      required File imageFile,
      required String profileImage}) async {
    try {
      await postDataProvider.uploadPost(
          desc: desc,
          uid: uid,
          username: username,
          imageFile: imageFile,
          profileImage: profileImage);
    } catch (e) {
      log("Error uploading post: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<void> likePost({required String postId, required String uid}) async {
    try {
      await postDataProvider.likePost(postId: postId, uid: uid);
    } catch (e) {
      log("Error liking post: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<void> deletePost({required String postId}) async {
    try {
      await postDataProvider.deletePost(postId: postId);
    } catch (e) {
      log("Error deleting post: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<void> addComment(
      {required String postId,
      required String content,
      required String username,
      required String uid,
      required String profilePic}) async {
    try {
      await postDataProvider.addComment(
          postId: postId,
          content: content,
          username: username,
          uid: uid,
          profilePic: profilePic);
    } catch (e) {
      log("Error adding comment: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<void> likeComment({
    required String postId,
    required String commentId,
    required String uid,
  }) async {
    try {
      await postDataProvider.likeComment(
          postId: postId, commentId: commentId, uid: uid);
    } catch (e) {
      log("Error liking comment: ${e.toString()}");
      throw e.toString();
    }
  }

  Future<List<Post>> getPostsByUid(String uid) async {
    try {
      final posts = await postDataProvider.getPostsByUid(uid);
      return posts
          .map((e) => Post.fromJson(e.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log("Error getting posts by uid: ${e.toString()}");
      throw e.toString();
    }
  }

  Stream<List<Post>> getAllPosts() async* {
    try {
      final posts = postDataProvider.getAllPosts();
      yield* posts.map((snapshot) {
        return snapshot.docs.map((doc) {
          return Post.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      log("Error getting all posts: ${e.toString()}");
      throw e.toString();
    }
  }

  Stream<List<Post>> getFavorites(List favorites) async* {
    try {
      final posts = postDataProvider.getFavorites(favorites);
      yield* posts.map((snapshot) {
        return snapshot.docs.map((doc) {
          return Post.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      log("Error getting favorites: ${e.toString()}");
      throw e.toString();
    }
  }

  Stream<List<Comment>> getComments(String postId) async* {
    try {
      final comments = postDataProvider.getComments(postId);
      yield* comments.map((snapshot) {
        return snapshot.docs.map((doc) {
          return Comment.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      log("Error getting comments: ${e.toString()}");
      throw e.toString();
    }
  }
}
