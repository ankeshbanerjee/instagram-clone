import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/di/service_locator.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/screens/comment/widgets/comment_item/bloc/comment_item_bloc.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatelessWidget {
  final String postId;
  final Comment comment;
  const CommentItem({super.key, required this.comment, required this.postId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentItemBloc(getIt()),
      child: _CommentItemContent(
        comment: comment,
        postId: postId,
      ),
    );
  }
}

class _CommentItemContent extends StatelessWidget {
  final String postId;
  final Comment comment;
  const _CommentItemContent(
      {super.key, required this.comment, required this.postId});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Builder(
      builder: (context) {
        final userState = context.read<UserBloc>().state;
        final itemState = context.read<CommentItemBloc>().state;
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 14).copyWith(bottom: 18),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.profilePic),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: comment.username,
                              style: TextStyle(color: theme.primaryTextColor),
                              children: [
                            TextSpan(
                                text:
                                    "  ${timeago.format(comment.datePublished, locale: 'en_short')}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: theme.secondaryTextColor))
                          ])),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        comment.content,
                        style: TextStyle(
                            fontSize: 15, color: theme.primaryTextColor),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (userState is UserFetchSuccess) {
                      context.read<CommentItemBloc>().add(LikeComment(
                          postId: postId,
                          commentId: comment.commentId,
                          uid: userState.user.uid));
                    }
                  },
                  child: Column(children: [
                    userState is UserFetchSuccess &&
                            comment.likes.contains(userState.user.uid)
                        ? const Icon(
                            Icons.favorite,
                            size: 18,
                            color: Colors.redAccent,
                          )
                        : Icon(
                            Icons.favorite_outline,
                            size: 18,
                            color: theme.primaryTextColor,
                          ),
                    Text(
                      comment.likes.length.toString(),
                      style: TextStyle(
                          fontSize: 12, color: theme.secondaryTextColor),
                    )
                  ]),
                )
              ]),
        );
      },
    );
  }
}
