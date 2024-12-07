import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/di/service_locator.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/common_widgets/post_card/bloc/post_card_bloc.dart';
import 'package:instagram_clone/configs/routes/args.dart';
import 'package:instagram_clone/presentation/screens/comment/comment_screen.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/presentation/common_widgets/like_animation.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostCardBloc(
        postRepository: getIt(),
        profileRepository: getIt(),
      ),
      child: _PostCardContent(post: post),
    );
  }
}

class _PostCardContent extends StatefulWidget {
  final Post post;
  const _PostCardContent({super.key, required this.post});

  @override
  State<_PostCardContent> createState() => _PostCardContentState();
}

class _PostCardContentState extends State<_PostCardContent> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context)!;
    final postItem = widget.post;

    return MultiBlocListener(
      listeners: [
        BlocListener<PostCardBloc, PostCardState>(
          listener: (context, postCardWidgetState) {
            if (postCardWidgetState is AddToFavoritesSuccess) {
              context.read<UserBloc>().add(RefreshUserEvent());
            } else if (postCardWidgetState is AddToFavoritesFailure) {
              showToast(postCardWidgetState.errorMessage);
            } else if (postCardWidgetState is RemoveFromFavoritesSuccess) {
              context.read<UserBloc>().add(RefreshUserEvent());
            } else if (postCardWidgetState is RemoveFromFavoritesFailure) {
              showToast(postCardWidgetState.errorMessage);
            }
          },
        ),
        BlocListener<UserBloc, UserState>(
          listener: (context, userState) {
            log("user state: ${userState.runtimeType}");
            if (userState is UserFetchFailure) {
              showToast(userState.message);
            }
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final userState = context.watch<UserBloc>().state;
          final widgetState = context.watch<PostCardBloc>().state;
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
                          style: TextStyle(
                              color: appTheme.theme.primaryTextColor)),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            if (userState is UserFetchSuccess &&
                                userState.user.uid != postItem.uid) {
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
                                            color: appTheme
                                                .theme.primaryTextColor),
                                      ),
                                      children: <Widget>[
                                        SimpleDialogOption(
                                          onPressed: () {
                                            // _postServices.deletePost(
                                            //     postId: postItem.postId);
                                            // Navigator.pop(context);
                                            context.read<PostCardBloc>().add(
                                                DeletePost(postItem.postId));
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
                  onDoubleTap: () {
                    setState(() {
                      isLikeAnimating = true;
                    });
                    // await _postServices.likePost(
                    //     postId: postItem.postId, uid: user.uid);
                    if (userState is UserFetchSuccess) {
                      context.read<PostCardBloc>().add(LikePost(
                          postId: postItem.postId, uid: userState.user.uid));
                    }
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
                      isAnimating: userState is UserFetchSuccess
                          ? postItem.likes.contains(userState.user.uid)
                          : false,
                      smallLike: true,
                      child: IconButton(
                          onPressed: () {
                            // _postServices.likePost(
                            //     postId: postItem.postId, uid: user.uid);
                            if (userState is UserFetchSuccess) {
                              context.read<PostCardBloc>().add(LikePost(
                                  postId: postItem.postId,
                                  uid: userState.user.uid));
                            }
                          },
                          icon: userState is UserFetchSuccess &&
                                  postItem.likes.contains(userState.user.uid)
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
                          Navigator.of(context).pushNamed(
                              CommentScreenWrapper.routeName,
                              arguments:
                                  CommentScreenArgs(postId: postItem.postId));
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
                          if (userState is UserFetchSuccess) {
                            final user = userState.user;
                            // showLoaderDialog(context);
                            if (!user.favorites.contains(postItem.postId)) {
                              // await _profileServices.addToFavorites(
                              //     user.uid, postItem.postId);
                              // await ref.read(userProvider.notifier).refreshUser();
                              // setState(() {
                              //   isSaved = true;
                              // });
                              // if (mounted) {
                              //   Navigator.pop(context);
                              // }
                              // showToast("Added to favorites");
                              context.read<PostCardBloc>().add(AddToFavorites(
                                  postId: postItem.postId, uid: user.uid));
                            } else {
                              // await _profileServices.removeFromFavorites(
                              //     user.uid, postItem.postId);
                              // await ref.read(userProvider.notifier).refreshUser();
                              // setState(() {
                              //   isSaved = false;
                              // });
                              // if (mounted) {
                              //   Navigator.pop(context);
                              // }
                              context.read<PostCardBloc>().add(
                                  RemoveFromFavorites(
                                      postId: postItem.postId, uid: user.uid));
                            }
                          }
                        },
                        icon: userState is UserFetchSuccess &&
                                userState.user.favorites
                                    .contains(postItem.postId)
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
                        style:
                            TextStyle(color: appTheme.theme.primaryTextColor),
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
                      Navigator.of(context).pushNamed(
                          CommentScreenWrapper.routeName,
                          arguments:
                              CommentScreenArgs(postId: postItem.postId));
                    },
                    child: Text('View all ${postItem.commentCount} comments',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: appTheme.theme.secondaryTextColor)),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10, bottom: 20),
                  child: Text(
                      DateFormat.yMMMEd().format(postItem.datePublished),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: appTheme.theme.secondaryTextColor,
                          fontSize: 12)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
