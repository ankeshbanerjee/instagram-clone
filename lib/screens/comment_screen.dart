import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/router/args.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/widgets/comment_item.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  static String routeName = "/comment";
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  Future<void> handleAddComment(
      {required String postId,
      required String username,
      required String uid,
      required String profilePic}) async {
    if (_isLoading) return;
    final commentText = _commentController.text;
    if (commentText.isEmpty) {
      showToast("Please type a comment");
      return;
    }
    _commentController.clear();
    setState(() {
      _isLoading = true;
    });
    try {
      await PostServices().addComment(
          postId: postId,
          content: commentText,
          username: username,
          uid: uid,
          profilePic: profilePic);
      setState(() {
        _isLoading = false;
      });
      showToast("Comment added.");
    } catch (e) {
      showToast(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CommentScreenArgs;
    final User user = context.watch<UserProvider>().getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Comments"),
        centerTitle: false,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10)
            .copyWith(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePicture),
          ),
          Expanded(
              child: TextField(
            controller: _commentController,
            decoration: InputDecoration(
                hintText: "Add comment as ${user.username}",
                hintStyle: const TextStyle(fontSize: 14),
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
          )),
          IconButton(
              onPressed: () => handleAddComment(
                  postId: args.postId,
                  username: user.username,
                  uid: user.uid,
                  profilePic: user.profilePicture),
              icon: const Icon(
                Icons.send,
                size: 28,
                color: blueColor,
              ))
        ]),
      ),
      body: Column(
        children: [
          _isLoading ? const LinearProgressIndicator() : Container(),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(DBCollections.posts.name)
                  .doc(args.postId)
                  .collection(DBCollections.comments.name)
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> comments = snapshot.data!.docs;
                  return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = Comment.fromJson(
                            comments[index].data() as Map<String, dynamic>);
                        return CommentItem(
                            comment: comment, postId: args.postId);
                      });
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Something Went Wrong!"),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
