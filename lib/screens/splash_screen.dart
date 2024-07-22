import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';
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
    final appTheme = AppTheme.of(context)!;
    return Scaffold(
        body: Container(
      color: appTheme.theme.backgroundColor,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            colorFilter: ColorFilter.mode(
                appTheme.theme.primaryTextColor, BlendMode.srcIn),
          ),
        ]),
      ),
    ));
  }
}
