import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/di/service_locator.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/common_widgets/loading_widget.dart';
import 'package:instagram_clone/presentation/screens/profile/bloc/profile_screen_bloc.dart';
import 'package:instagram_clone/presentation/screens/profile/widgets/details_item.dart';
import 'package:instagram_clone/configs/routes/args.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/presentation/common_widgets/follow_button.dart';

class ProfileScreenWrapper extends StatelessWidget {
  static const routeName = '/profile';
  const ProfileScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileScreenBloc(
          postRepository: getIt(), profileRepository: getIt()),
      child: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        final uid =
            (ModalRoute.of(context)!.settings.arguments as ProfileScreenArgs)
                .uid;
        context.read<ProfileScreenBloc>().add(FetchPostsAndProfile(uid));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Builder(builder: (context) {
      final userState = context.watch<UserBloc>().state;
      final screenState = context.watch<ProfileScreenBloc>().state;
      return screenState is ProfileScreenLoading
          ? Container(
              decoration: BoxDecoration(color: theme.backgroundColor),
              child: const LoadingWidget(),
            )
          : Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: screenState is FetchPostsAndProfileSuccess
                  ? AppBar(
                      leading: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: theme.primaryTextColor,
                          )),
                      backgroundColor: theme.backgroundColor,
                      title: Text(
                        screenState.profile.username,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.primaryTextColor),
                      ),
                      centerTitle: false,
                    )
                  : null,
              body: Container(
                color: theme.backgroundColor,
                child: screenState is FetchPostsAndProfileSuccess &&
                        userState is UserFetchSuccess
                    ? Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16, top: 20),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      screenState.profile.profilePicture),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          DetailsItem(
                                              value: screenState.posts.length
                                                  .toString(),
                                              section: 'posts'),
                                          DetailsItem(
                                              value: screenState
                                                  .profile.followers.length
                                                  .toString(),
                                              section: 'followers'),
                                          DetailsItem(
                                              value: screenState
                                                  .profile.following.length
                                                  .toString(),
                                              section: 'following'),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        child: screenState.profile.followers
                                                .contains(userState.user.uid)
                                            ? FollowButton(
                                                backgroundColor:
                                                    theme.secondaryBtnColor,
                                                borderColor:
                                                    theme.secondaryBtnColor,
                                                text: "Unfollow",
                                                textColor:
                                                    theme.primaryTextColor,
                                                function: () {
                                                  context
                                                      .read<ProfileScreenBloc>()
                                                      .add(UnFollowEvent(
                                                          userState.user.uid,
                                                          screenState
                                                              .profile.uid));
                                                })
                                            : FollowButton(
                                                backgroundColor:
                                                    theme.primaryBtnColor,
                                                borderColor:
                                                    theme.primaryBtnColor,
                                                text: "Follow",
                                                textColor: Colors.white,
                                                function: () {
                                                  context
                                                      .read<ProfileScreenBloc>()
                                                      .add(FollowEvent(
                                                          userState.user.uid,
                                                          screenState
                                                              .profile.uid));
                                                }),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                              screenState.profile.username,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: 16, color: theme.primaryTextColor),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                              screenState.profile.bio,
                              textAlign: TextAlign.start,
                              style: TextStyle(color: theme.primaryTextColor),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: GridView.count(
                              controller: searchScrollController,
                              crossAxisCount: 3,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                              children: List.generate(
                                screenState.posts.length,
                                (index) {
                                  return Image.network(
                                    screenState.posts[index].photoUrl,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ));
    });
  }
}
