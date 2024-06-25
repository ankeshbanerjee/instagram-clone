import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/services/auth_services.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/follow_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final postServices = PostServices();
  bool _isLoading = true;
  List<Post> _myPosts = [];

  Future<void> loadPosts() async {
    try {
      final res = await postServices.getPostsByUid(
          Provider.of<UserProvider>(context, listen: false).getUser.uid);
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
      context.read<UserProvider>().removeUser();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
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
                user.username,
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
                        backgroundImage: NetworkImage(user.profilePicture),
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
                                backgroundColor: Colors.blueGrey.shade900,
                                borderColor: Colors.blueGrey.shade900,
                                text: "Sign out",
                                textColor: Colors.white,
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
                    user.bio,
                    textAlign: TextAlign.start,
                  ),
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
