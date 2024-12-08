import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/configs/routes/screens.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/presentation/common_widgets/follow_button.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/profile/widgets/details_item.dart';

class ProfileTabScreen extends StatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    if (userState is UserFetchSuccess) {
      context.read<ProfileBloc>().add(FetchPosts(userState.user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return BlocListener<ProfileBloc, ProfileState>(listener: (context, state) {
      if (state is SignedOut) {
        context.read<UserBloc>().add(RemoveUserEvent());
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreenWrapper.routeName, (route) => false);
      }
    }, child: Builder(builder: (context) {
      final userState = context.watch<UserBloc>().state;
      final tabState = context.watch<ProfileBloc>().state;
      return Container(
        color: theme.backgroundColor,
        child: tabState is ProfileLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.blue.shade600,
              ))
            : userState is UserFetchSuccess && tabState is ProfileLoaded
                ? Scaffold(
                    appBar: AppBar(
                      backgroundColor: theme.backgroundColor,
                      title: Text(
                        userState.user.username,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.primaryTextColor),
                      ),
                      centerTitle: false,
                    ),
                    body: Container(
                      color: theme.backgroundColor,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 16, top: 20),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                      userState.user.profilePicture),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          DetailsItem(
                                              value: tabState.posts.length
                                                  .toString(),
                                              section: 'posts'),
                                          DetailsItem(
                                              value: userState
                                                  .user.followers.length
                                                  .toString(),
                                              section: 'followers'),
                                          DetailsItem(
                                              value: userState
                                                  .user.following.length
                                                  .toString(),
                                              section: 'following'),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      FollowButton(
                                          backgroundColor:
                                              theme.secondaryBtnColor,
                                          borderColor: theme.secondaryBtnColor,
                                          text: "Sign out",
                                          textColor: theme.primaryTextColor,
                                          function: () => context
                                              .read<ProfileBloc>()
                                              .add(SignOutEvent()))
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
                              userState.user.username,
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
                            child: Text(userState.user.bio,
                                textAlign: TextAlign.start,
                                style:
                                    TextStyle(color: theme.primaryTextColor)),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                            child: GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3,
                              children: List.generate(
                                tabState.posts.length,
                                (index) {
                                  return Image.network(
                                    tabState.posts[index].photoUrl,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                : Container(),
      );
    }));
  }
}
