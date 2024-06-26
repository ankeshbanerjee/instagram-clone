import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/router/args.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/services/profile_services.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _postServices = PostServices();
  final _profileServices = ProfileServices();
  bool _isLoading = true;
  List<Post> _myPosts = [];
  User? _profile;

  Future<void> loadPosts() async {
    try {
      final uid =
          (ModalRoute.of(context)!.settings.arguments as ProfileScreenArgs).uid;
      final res = await _postServices.getPostsByUid(uid);
      final res1 = await _profileServices.getUserByUid(uid);
      setState(() {
        _myPosts = res;
        _profile = res1;
        _isLoading = false;
      });
    } catch (e) {
      showToast(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> handleFollow(String uid, String idToBeFollowed) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _profileServices.follow(uid, idToBeFollowed);
      if (context.mounted) {
        await context.read<UserProvider>().refreshUser();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  Future<void> handleUnFollow(String uid, String idToBeUnFollowed) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _profileServices.unfollow(uid, idToBeUnFollowed);
      if (context.mounted) {
        await context.read<UserProvider>().refreshUser();
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      showToast(e.toString());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final User user = context.watch<UserProvider>().getUser;
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                _profile!.username,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              centerTitle: false,
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16, top: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(_profile!.profilePicture),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DetailsItem(
                                    value: _myPosts.length.toString(),
                                    section: 'posts'),
                                DetailsItem(
                                    value:
                                        _profile!.followers.length.toString(),
                                    section: 'followers'),
                                DetailsItem(
                                    value:
                                        _profile!.following.length.toString(),
                                    section: 'following'),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              child: _profile!.followers.contains(user.uid)
                                  ? FollowButton(
                                      backgroundColor: Colors.blueGrey.shade900,
                                      borderColor: Colors.blueGrey.shade900,
                                      text: "Unfollow",
                                      textColor: Colors.white,
                                      function: () {
                                        handleUnFollow(user.uid, _profile!.uid);
                                      })
                                  : FollowButton(
                                      backgroundColor: Colors.blue.shade600,
                                      borderColor: Colors.blue.shade600,
                                      text: "Follow",
                                      textColor: Colors.white,
                                      function: () {
                                        handleFollow(user.uid, _profile!.uid);
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
                    _profile!.username,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 16),
                  child: Text(
                    _profile!.bio,
                    textAlign: TextAlign.start,
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
            ));
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
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        Text(section)
      ],
    );
  }
}
