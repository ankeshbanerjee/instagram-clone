import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/theme/app_theme.dart';
import 'package:instagram_clone/utils/constants.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int pageIndex = 0;
  bool isLoading = true;

  Future<void> loadUser() async {
    await ref.watch(userProvider.notifier).refreshUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context)!;
    return isLoading
        ? Container(
            color: appTheme.theme.backgroundColor,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade500,
              ),
            ),
          )
        : Scaffold(
            // body: IndexedStack(
            //     index: pageIndex,
            //     children:
            //         bottomNavPages), // state of each page is kept intact even after navigating to another screen
            body: bottomNavPages[pageIndex],
            bottomNavigationBar: CupertinoTabBar(
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
                setState(() {
                  pageIndex = value;
                });
              },
              backgroundColor: appTheme.theme.backgroundColor,
              iconSize: 30.0,
              border: Border(
                  top: BorderSide(
                      color: appTheme.theme.secondaryTextColor, width: 0.25)),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                      color: appTheme.theme.secondaryTextColor,
                    ),
                    activeIcon: Icon(
                      Icons.home,
                      color: appTheme.theme.primaryTextColor,
                    )),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search_outlined,
                    color: appTheme.theme.secondaryTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.search,
                    color: appTheme.theme.primaryTextColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: appTheme.theme.secondaryTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.add_circle,
                    color: appTheme.theme.primaryTextColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_outline,
                    color: appTheme.theme.secondaryTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.favorite,
                    color: appTheme.theme.primaryTextColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_outline,
                    color: appTheme.theme.secondaryTextColor,
                  ),
                  activeIcon: Icon(
                    Icons.person,
                    color: appTheme.theme.primaryTextColor,
                  ),
                ),
              ],
            ),
          );
  }
}
