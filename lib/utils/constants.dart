import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/bottomNav/add_post_screen.dart';
import 'package:instagram_clone/screens/bottomNav/favorites_screen.dart';
import 'package:instagram_clone/screens/bottomNav/feed_screen.dart';
import 'package:instagram_clone/screens/bottomNav/profile_screen_bottom_nav.dart';
import 'package:instagram_clone/screens/bottomNav/search_screen.dart';

enum FileDirectories { profilePicture, postPicture }

enum DBCollections { users, posts, comments }

const userIcon = 'https://cdn-icons-png.freepik.com/512/8742/8742495.png';

ScrollController feedScrollController = ScrollController();
ScrollController searchScrollController = ScrollController();
ScrollController favoriteScrollController = ScrollController();
ScrollController profileScrollController = ScrollController();

List<Widget> bottomNavPages = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const FavoriteScreen(),
  const ProfileScreen()
];
