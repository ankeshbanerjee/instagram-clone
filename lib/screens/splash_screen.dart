import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkAuth() {
    if (FirebaseAuth.instance.currentUser != null) {
      Future.delayed(const Duration(milliseconds: 1000),
          () => Navigator.pushReplacementNamed(context, HomeScreen.routeName));
    } else {
      Future.delayed(const Duration(milliseconds: 1000),
          () => Navigator.pushReplacementNamed(context, LoginScreen.routeName));
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SvgPicture.asset(
          'assets/ic_instagram.svg',
          colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
        ),
      ]),
    ));
  }
}
