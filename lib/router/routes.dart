import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/register_screen.dart';
import 'package:instagram_clone/screens/splash_screen.dart';
import 'package:page_transition/page_transition.dart';

// final Map<String, WidgetBuilder> routes = {
//   SplashScreen.routeName: (context) => const SplashScreen(),
//   LoginScreen.routeName: (context) => const LoginScreen(),
//   RegisterScreen.routeName: (context) => const RegisterScreen(),
//   HomeScreen.routeName: (context) => const HomeScreen(),
//   CommentScreen.routeName: (context) => const CommentScreen(),
//   ProfileScreen.routeName: (context) => const ProfileScreen(),
// };

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeName:
      return pageTransition(
        child: const SplashScreen(),
        settings: settings,
      );
    case LoginScreen.routeName:
      return pageTransition(
        child: const LoginScreen(),
        settings: settings,
      );
    case RegisterScreen.routeName:
      return pageTransition(
        child: const RegisterScreen(),
        settings: settings,
      );
    case HomeScreen.routeName:
      return pageTransition(
        child: const HomeScreen(),
        settings: settings,
      );
    case CommentScreen.routeName:
      return pageTransition(
        child: const CommentScreen(),
        settings: settings,
      );
    case ProfileScreen.routeName:
      return pageTransition(
        child: const ProfileScreen(),
        settings: settings,
      );
    default:
      return null;
  }
}

PageTransition<dynamic> pageTransition(
    {required Widget child, required RouteSettings settings}) {
  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
  );
}
