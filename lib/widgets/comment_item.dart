import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/theme/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends ConsumerStatefulWidget {
  final String postId;
  final Comment comment;
  const CommentItem({super.key, required this.comment, required this.postId});

  @override
  ConsumerState<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends ConsumerState<CommentItem> {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context)!;
    final User user = ref.watch(userProvider)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6).copyWith(bottom: 18),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.comment.profilePic),
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
                          text: widget.comment.username,
                          style:
                              TextStyle(color: appTheme.theme.primaryTextColor),
                          children: [
                        TextSpan(
                            text:
                                "  ${timeago.format(widget.comment.datePublished, locale: 'en_short')}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: appTheme.theme.secondaryTextColor))
                      ])),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.comment.content,
                    style: TextStyle(
                        fontSize: 15, color: appTheme.theme.primaryTextColor),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                await PostServices().likeComment(
                    postId: widget.postId,
                    commentId: widget.comment.commentId,
                    uid: user.uid);
              },
              child: Column(children: [
                widget.comment.likes.contains(user.uid)
                    ? const Icon(
                        Icons.favorite,
                        size: 18,
                        color: Colors.redAccent,
                      )
                    : Icon(
                        Icons.favorite_outline,
                        size: 18,
                        color: appTheme.theme.primaryTextColor,
                      ),
                Text(
                  widget.comment.likes.length.toString(),
                  style: TextStyle(
                      fontSize: 12, color: appTheme.theme.secondaryTextColor),
                )
              ]),
            )
          ]),
    );
  }
}
