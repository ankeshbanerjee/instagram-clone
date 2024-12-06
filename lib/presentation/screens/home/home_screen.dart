import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/di/service_locator.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/common_widgets/loading_widget.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/add_post/bloc/add_post_bloc.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/favorites/bloc/favorites_bloc.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/feeds/bloc/feed_bloc.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/profile/bloc/profile_bloc.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/search/bloc/search_bloc.dart';
import 'package:instagram_clone/presentation/screens/home/bloc/home_bloc.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/configs/routes/screens.dart';

class HomeScreenWrapper extends StatelessWidget {
  static const String routeName = '/home';
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => HomeBloc(), child: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<UserBloc>().add(RefreshUserEvent());
    super.initState();
  }

  final _feedTabBloc = FeedBloc(getIt());
  final _searchTabBloc =
      SearchBloc(postRepository: getIt(), profileRepository: getIt());
  final _addPostTabBloc = AddPostBloc(getIt());
  final _favoritesTabBloc = FavoritesBloc(getIt());
  final _profileTabBloc =
      ProfileBloc(postRepository: getIt(), authRepository: getIt());

  List<Widget> get bottomNavPages => [
        BlocProvider.value(value: _feedTabBloc, child: const FeedTabScreen()),
        BlocProvider.value(
          value: _searchTabBloc,
          child: const SearchScreen(),
        ),
        BlocProvider.value(
          value: _addPostTabBloc,
          child: AddPostScreen(),
        ),
        BlocProvider.value(
          value: _favoritesTabBloc,
          child: const FavoriteScreen(),
        ),
        BlocProvider.value(
          value: _profileTabBloc,
          child: const ProfileTabScreen(),
        )
      ];

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Scaffold(
      // body: IndexedStack(
      //     index: pageIndex,
      //     children:
      //         bottomNavPages), // state of each page is kept intact even after navigating to another screen
      body: Builder(builder: (context) {
        final userState = context.watch<UserBloc>().state;
        final homeState = context.watch<HomeBloc>().state;
        if (userState is UserLoading) {
          return Container(
              color: theme.backgroundColor, child: const LoadingWidget());
        } else if (userState is UserFetchSuccess && homeState is HomeInitial) {
          return bottomNavPages[homeState.index];
        }
        return Container();
      }),
      bottomNavigationBar: Builder(builder: (context) {
        final userState = context.watch<UserBloc>().state;
        final homeState = context.watch<HomeBloc>().state;
        if (userState is UserLoading) {
          return Container(
              color: theme.backgroundColor, child: const LoadingWidget());
        }
        if (userState is UserFetchSuccess && homeState is HomeInitial) {
          final pageIndex = homeState.index;
          return CupertinoTabBar(
            height: 60,
            currentIndex: pageIndex,
            onTap: (value) {
              if (pageIndex == 0) {
                feedScrollController.animateTo(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              }
              if (pageIndex == 1) {
                searchScrollController.animateTo(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              }
              if (pageIndex == 3) {
                favoriteScrollController.animateTo(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              }
              if (pageIndex == 4) {
                profileScrollController.animateTo(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              }
              context.read<HomeBloc>().add(TabChange(value));
            },
            backgroundColor: theme.backgroundColor,
            iconSize: 30.0,
            border: Border(
                top: BorderSide(color: theme.secondaryTextColor, width: 0.25)),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    color: theme.secondaryTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.home,
                    color: theme.primaryTextColor,
                  )),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_outlined,
                  color: theme.secondaryTextColor,
                ),
                activeIcon: Icon(
                  Icons.search,
                  color: theme.primaryTextColor,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: theme.secondaryTextColor,
                ),
                activeIcon: Icon(
                  Icons.add_circle,
                  color: theme.primaryTextColor,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite_outline,
                  color: theme.secondaryTextColor,
                ),
                activeIcon: Icon(
                  Icons.favorite,
                  color: theme.primaryTextColor,
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                  color: theme.secondaryTextColor,
                ),
                activeIcon: Icon(
                  Icons.person,
                  color: theme.primaryTextColor,
                ),
              ),
            ],
          );
        }
        return Container();
      }),
    );
  }
}
