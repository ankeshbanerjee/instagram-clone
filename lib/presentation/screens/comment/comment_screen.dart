import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/di/service_locator.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/screens/comment/bloc/comment_bloc.dart';
import 'package:instagram_clone/configs/routes/args.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/presentation/screens/comment/widgets/comment_item/comment_item.dart';

class CommentScreenWrapper extends StatelessWidget {
  static const String routeName = "/comment";
  const CommentScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommentBloc(getIt()),
      child: CommentScreen(),
    );
  }
}

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key});

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CommentScreenArgs;
    final theme = AppTheme.of(context)!.theme;

    return BlocListener<CommentBloc, CommentState>(
      listener: (context, state) {
        if (state is AddCommentSuccess) {
          showToast("Comment added!");
        }
        if (state is AddCommentFailure || state is CommentsFetchFailure) {
          showToast((state as dynamic).message);
        }
      },
      child: Builder(builder: (context) {
        final userState = context.watch<UserBloc>().state;
        final screenState = context.watch<CommentBloc>().state;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.backgroundColor,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.primaryTextColor,
                )),
            title: Text("Comments",
                style: TextStyle(color: theme.primaryTextColor)),
            centerTitle: false,
          ),
          bottomNavigationBar: Container(
            color: theme.backgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 10)
                .copyWith(bottom: MediaQuery.of(context).padding.bottom),
            child: Row(children: [
              (userState is UserFetchSuccess)
                  ? CircleAvatar(
                      backgroundImage:
                          NetworkImage(userState.user.profilePicture),
                    )
                  : Container(),
              Expanded(
                  child: (userState is UserFetchSuccess)
                      ? TextField(
                          style: TextStyle(color: theme.primaryTextColor),
                          controller: _commentController,
                          decoration: InputDecoration(
                              hintText:
                                  "Add comment as ${userState.user.username}",
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color:
                                      theme.primaryTextColor.withOpacity(0.5)),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        )
                      : Container()),
              IconButton(
                  onPressed: () {
                    if (userState is UserFetchSuccess) {
                      context.read<CommentBloc>().add(AddComment(
                          postId: args.postId,
                          username: userState.user.username,
                          uid: userState.user.uid,
                          profilePic: userState.user.profilePicture,
                          comment: _commentController.text));
                      _commentController.clear();
                    }
                  },
                  icon: Icon(
                    Icons.send,
                    size: 28,
                    color: theme.primaryBtnColor,
                  ))
            ]),
          ),
          body: Container(
            color: theme.backgroundColor,
            child: Column(
              children: [
                screenState is CommentLoading
                    ? const LinearProgressIndicator()
                    : Container(),
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
                        final List<DocumentSnapshot> comments =
                            snapshot.data!.docs;
                        return ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = Comment.fromJson(comments[index]
                                  .data() as Map<String, dynamic>);
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
      }),
    );
  }
}
