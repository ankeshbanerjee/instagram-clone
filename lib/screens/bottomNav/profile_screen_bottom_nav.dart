import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/services/auth_services.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final postServices = PostServices();
  bool _isLoading = true;
  List<Post> _myPosts = [];

  Future<void> loadPosts() async {
    try {
      final res =
          await postServices.getPostsByUid(ref.watch(userProvider)!.uid);
      setState(() {
        _myPosts = res;
        _isLoading = false;
      });
    } catch (e) {
      showToast(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> handleSignOut() async {
    await AuthServices().signOut();
    if (context.mounted) {
      ref.read(userProvider.notifier).removeUser();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = ref.watch(userProvider)!;
    final appTheme = AppTheme.of(context)!;
    return Container(
      color: appTheme.theme.backgroundColor,
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Colors.blue.shade600,
            ))
          : Scaffold(
              appBar: AppBar(
                backgroundColor: appTheme.theme.backgroundColor,
                title: Text(
                  user.username,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: appTheme.theme.primaryTextColor),
                ),
                centerTitle: false,
              ),
              body: Container(
                color: appTheme.theme.backgroundColor,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16, top: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(user.profilePicture),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    DetailsItem(
                                        value: _myPosts.length.toString(),
                                        section: 'posts'),
                                    DetailsItem(
                                        value: user.followers.length.toString(),
                                        section: 'followers'),
                                    DetailsItem(
                                        value: user.following.length.toString(),
                                        section: 'following'),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                FollowButton(
                                    backgroundColor:
                                        appTheme.theme.secondaryBtnColor,
                                    borderColor:
                                        appTheme.theme.secondaryBtnColor,
                                    text: "Sign out",
                                    textColor: appTheme.theme.primaryTextColor,
                                    function: () => handleSignOut())
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
                        user.username,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16,
                            color: appTheme.theme.primaryTextColor),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 16),
                      child: Text(user.bio,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: appTheme.theme.primaryTextColor)),
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
                          _myPosts.length,
                          (index) {
                            return Image.network(
                              _myPosts[index].photoUrl,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )),
    );
  }
}

class DetailsItem extends StatelessWidget {
  const DetailsItem({
    super.key,
    required this.value,
    required this.section,
  });

  final String value;
  final String section;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context)!;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: appTheme.theme.primaryTextColor),
        ),
        Text(section, style: TextStyle(color: appTheme.theme.primaryTextColor))
      ],
    );
  }
}
