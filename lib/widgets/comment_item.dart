import 'package:flutter/material.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatefulWidget {
  final String postId;
  final Comment comment;
  const CommentItem({super.key, required this.comment, required this.postId});

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    final User user = context.watch<UserProvider>().getUser;
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
                      text: TextSpan(text: widget.comment.username, children: [
                    TextSpan(
                        text:
                            "  ${timeago.format(widget.comment.datePublished, locale: 'en_short')}",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: secondaryColor))
                  ])),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.comment.content,
                    style: const TextStyle(fontSize: 15),
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
                    : const Icon(
                        Icons.favorite_outline,
                        size: 18,
                      ),
                Text(
                  widget.comment.likes.length.toString(),
                  style: const TextStyle(fontSize: 12),
                )
              ]),
            )
          ]),
    );
  }
}
