import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  final double iconSize = 30;
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
            body: bottomNavPages[pageIndex],
            bottomNavigationBar: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom, top: 6),
                decoration: const BoxDecoration(
                    color: mobileBackgroundColor,
                    border: Border(
                        top: BorderSide(width: 0.25, color: secondaryColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          pageIndex = 0;
                        });
                      },
                      icon: pageIndex == 0
                          ? Icon(
                              Icons.home,
                              size: iconSize,
                              color: primaryColor,
                            )
                          : Icon(
                              Icons.home_outlined,
                              size: iconSize,
                              color: secondaryColor,
                            ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          pageIndex = 1;
                        });
                      },
                      icon: pageIndex == 1
                          ? Icon(
                              Icons.search,
                              size: iconSize,
                              color: primaryColor,
                            )
                          : Icon(
                              Icons.search_outlined,
                              size: iconSize,
                              color: secondaryColor,
                            ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          pageIndex = 2;
                        });
                      },
                      icon: pageIndex == 2
                          ? Icon(
                              Icons.add_circle,
                              size: iconSize,
                              color: primaryColor,
                            )
                          : Icon(
                              Icons.add_circle_outline,
                              size: iconSize,
                              color: secondaryColor,
                            ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          pageIndex = 3;
                        });
                      },
                      icon: pageIndex == 3
                          ? Icon(
                              Icons.favorite,
                              size: iconSize,
                              color: primaryColor,
                            )
                          : Icon(
                              Icons.favorite_outline,
                              size: iconSize,
                              color: secondaryColor,
                            ),
                    ),
                    IconButton(
                      enableFeedback: false,
                      onPressed: () {
                        setState(() {
                          pageIndex = 4;
                        });
                      },
                      icon: pageIndex == 4
                          ? Icon(
                              Icons.person,
                              size: iconSize,
                              color: primaryColor,
                            )
                          : Icon(
                              Icons.person_outline,
                              size: iconSize,
                              color: secondaryColor,
                            ),
                    ),
                  ],
                )),
          );
  }
}
