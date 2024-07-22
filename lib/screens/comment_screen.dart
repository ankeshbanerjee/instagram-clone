import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/router/args.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/widgets/comment_item.dart';

class CommentScreen extends ConsumerStatefulWidget {
  static const String routeName = "/comment";
  const CommentScreen({super.key});

  @override
  ConsumerState<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
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
    final User user = ref.watch(userProvider)!;
    final appTheme = AppTheme.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.theme.backgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: appTheme.theme.primaryTextColor,
            )),
        title: Text("Comments",
            style: TextStyle(color: appTheme.theme.primaryTextColor)),
        centerTitle: false,
      ),
      bottomNavigationBar: Container(
        color: appTheme.theme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 10)
            .copyWith(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePicture),
          ),
          Expanded(
              child: TextField(
            style: TextStyle(color: appTheme.theme.primaryTextColor),
            controller: _commentController,
            decoration: InputDecoration(
                hintText: "Add comment as ${user.username}",
                hintStyle: TextStyle(
                    fontSize: 14,
                    color: appTheme.theme.primaryTextColor.withOpacity(0.5)),
                border: const OutlineInputBorder(borderSide: BorderSide.none)),
          )),
          IconButton(
              onPressed: () => handleAddComment(
                  postId: args.postId,
                  username: user.username,
                  uid: user.uid,
                  profilePic: user.profilePicture),
              icon: Icon(
                Icons.send,
                size: 28,
                color: appTheme.theme.primaryBtnColor,
              ))
        ]),
      ),
      body: Container(
        color: appTheme.theme.backgroundColor,
        child: Column(
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
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue.shade600,
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
