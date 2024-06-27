import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/router/args.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/services/profile_services.dart';
import 'package:instagram_clone/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';

class PostCard extends ConsumerStatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  bool isLikeAnimating = false;
  final _postServices = PostServices();
  final _profileServices = ProfileServices();

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context)!;
    final postItem = widget.post;
    final User user = ref.watch(userProvider)!;
    bool isSaved = user.favorites.contains(postItem.postId);

    return Container(
      color: appTheme.theme.backgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(postItem.profileImage),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(postItem.username,
                    style: TextStyle(color: appTheme.theme.primaryTextColor)),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      if (user.uid != postItem.uid) {
                        showToast("No actions available!");
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return SimpleDialog(
                                backgroundColor: appTheme.theme.isDark
                                    ? Colors.grey.shade800
                                    : Colors.white,
                                title: Text(
                                  'Actions',
                                  style: TextStyle(
                                      color: appTheme.theme.primaryTextColor),
                                ),
                                children: <Widget>[
                                  SimpleDialogOption(
                                    onPressed: () async {
                                      _postServices.deletePost(
                                          postId: postItem.postId);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Delete Post',
                                        style: TextStyle(
                                            color: appTheme
                                                .theme.primaryTextColor)),
                                  ),
                                ],
                              );
                            });
                      }
                    },
                    icon: Icon(
                      Icons.more_horiz,
                      color: appTheme.theme.primaryTextColor,
                    ))
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;
              });
              await _postServices.likePost(
                  postId: postItem.postId, uid: user.uid);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  postItem.photoUrl,
                  height: MediaQuery.of(context).size.height / 3,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                LikeAnimation(
                    isAnimating: isLikeAnimating,
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 120,
                      ),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4).copyWith(bottom: 0),
            child: Row(children: [
              LikeAnimation(
                isAnimating: postItem.likes.contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      _postServices.likePost(
                          postId: postItem.postId, uid: user.uid);
                    },
                    icon: postItem.likes.contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 30,
                          )
                        : Icon(
                            Icons.favorite_outline,
                            size: 30,
                            color: appTheme.theme.primaryTextColor,
                          )),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CommentScreen.routeName,
                        arguments: CommentScreenArgs(postId: postItem.postId));
                  },
                  icon: Icon(
                    Icons.comment_outlined,
                    size: 30,
                    color: appTheme.theme.primaryTextColor,
                  )),
              // IconButton(
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.send_outlined,
              //       size: 30,
              //     )),
              const Spacer(),
              IconButton(
                  onPressed: () async {
                    try {
                      showLoaderDialog(context);
                      if (!user.favorites.contains(postItem.postId)) {
                        await _profileServices.addToFavorites(
                            user.uid, postItem.postId);
                        await ref.read(userProvider.notifier).refreshUser();
                        setState(() {
                          isSaved = true;
                        });
                        if (mounted) {
                          Navigator.pop(context);
                        }
                        showToast("Added to favorites");
                      } else {
                        await _profileServices.removeFromFavorites(
                            user.uid, postItem.postId);
                        await ref.read(userProvider.notifier).refreshUser();
                        setState(() {
                          isSaved = false;
                        });
                        if (mounted) {
                          Navigator.pop(context);
                        }
                        showToast("Removed from favorites");
                      }
                    } catch (e) {
                      showToast(e.toString());
                    }
                  },
                  icon: isSaved
                      ? Icon(
                          Icons.bookmark,
                          size: 30,
                          color: appTheme.theme.primaryTextColor,
                        )
                      : Icon(
                          Icons.bookmark_outline,
                          size: 30,
                          color: appTheme.theme.primaryTextColor,
                        )),
            ]),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, bottom: 4),
            child: Text('${postItem.likes.length} likes',
                style: TextStyle(color: appTheme.theme.primaryTextColor)),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, bottom: 4),
            child: RichText(
              softWrap: true,
              text: TextSpan(
                  style: TextStyle(color: appTheme.theme.primaryTextColor),
                  children: [
                    TextSpan(
                      text: postItem.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: " ${postItem.description}",
                    ),
                  ]),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, bottom: 4),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(CommentScreen.routeName,
                    arguments: CommentScreenArgs(postId: postItem.postId));
              },
              child: Text('View all ${postItem.commentCount} comments',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: appTheme.theme.secondaryTextColor)),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 10, bottom: 20),
            child: Text(DateFormat.yMMMEd().format(postItem.datePublished),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: appTheme.theme.secondaryTextColor, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
