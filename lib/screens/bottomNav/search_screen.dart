import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/router/args.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/services/profile_services.dart';
import 'package:instagram_clone/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _postServices = PostServices();
  final _profileServices = ProfileServices();
  bool _isLoading = true;
  List<Post> _allPosts = [];
  bool _showUsers = false;
  List<User> _users = [];

  Future<void> loadPosts() async {
    try {
      List<Post> posts = await _postServices.getAllPosts();
      setState(() {
        _isLoading = false;
        _allPosts = posts;
      });
    } catch (e) {
      setState(() {
        showToast(e.toString());
        _isLoading = false;
      });
    }
  }

  Future<void> loadUsers() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _showUsers = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _showUsers = true;
    });
    try {
      List<User> users = await _profileServices.getUsersByUsername(query);
      setState(() {
        _isLoading = false;
        _users = users;
      });
    } catch (e) {
      setState(() {
        showToast(e.toString());
        _isLoading = false;
        _showUsers = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context)!;
    return Scaffold(
      body: Container(
        color: appTheme.theme.backgroundColor,
        child: SafeArea(
          child: Container(
            color: appTheme.theme.backgroundColor,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onEditingComplete: () async {
                      await loadUsers();
                    },
                    style: TextStyle(color: appTheme.theme.primaryTextColor),
                    cursorColor: appTheme.theme.secondaryTextColor,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                      hintText: "Search",
                      hintStyle:
                          TextStyle(color: appTheme.theme.secondaryTextColor),
                      filled: true,
                      fillColor: appTheme.theme.textFieldFillColor,
                      prefixIcon: Icon(
                        Icons.search,
                        color: appTheme.theme.primaryTextColor,
                      ),
                    ),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.blue.shade600,
                        ))
                      : _showUsers
                          ? ListView.builder(
                              controller: searchScrollController,
                              itemCount: _users.length,
                              itemBuilder: (context, index) {
                                final item = _users[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        ProfileScreen.routeName,
                                        arguments: ProfileScreenArgs(
                                            uid: _users[index].uid));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(item.profilePicture),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(item.username,
                                            style: TextStyle(
                                                color: appTheme
                                                    .theme.primaryTextColor)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : MasonryGridView.count(
                              controller: searchScrollController,
                              itemCount: _allPosts.length,
                              crossAxisCount: 3,
                              mainAxisSpacing: 3,
                              crossAxisSpacing: 3,
                              itemBuilder: (context, index) {
                                return Image.network(
                                  _allPosts[index].photoUrl,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
