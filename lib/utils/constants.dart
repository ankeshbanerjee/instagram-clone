import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/bottomNav/add_post_screen.dart';
import 'package:instagram_clone/screens/bottomNav/feed_screen.dart';

enum FileDirectories { profilePicture, postPicture }

enum DBCollections { users, posts }

const userIcon = 'https://cdn-icons-png.freepik.com/512/8742/8742495.png';

const bottomNavPages = [
  FeedScreen(),
  Center(
    child: Text("search page"),
  ),
  AddPostScreen(),
  Center(
    child: Text("favorite page"),
  ),
  Center(
    child: Text("profile page"),
  ),
];
