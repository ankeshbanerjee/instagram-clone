import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  bool isLoading = true;

  Future<void> loadUser() async {
    await context.read<UserProvider>().refreshUser();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
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
              backgroundColor: mobileBackgroundColor,
              iconSize: 30.0,
              border: const Border(
                  top: BorderSide(color: secondaryColor, width: 0.25)),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                      color: secondaryColor,
                    ),
                    activeIcon: Icon(
                      Icons.home,
                      color: primaryColor,
                    )),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search_outlined,
                    color: secondaryColor,
                  ),
                  activeIcon: Icon(
                    Icons.search,
                    color: primaryColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: secondaryColor,
                  ),
                  activeIcon: Icon(
                    Icons.add_circle,
                    color: primaryColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_outline,
                    color: secondaryColor,
                  ),
                  activeIcon: Icon(
                    Icons.favorite,
                    color: primaryColor,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_outline,
                    color: secondaryColor,
                  ),
                  activeIcon: Icon(
                    Icons.person,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          );
  }
}
