import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'screens.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreenWrapper.routeName:
      return pageTransition(
        child: const SplashScreenWrapper(),
        settings: settings,
      );
    case LoginScreenWrapper.routeName:
      return pageTransition(
        child: const LoginScreenWrapper(),
        settings: settings,
      );
    case RegisterScreenWrapper.routeName:
      return pageTransition(
        child: const RegisterScreenWrapper(),
        settings: settings,
      );
    case HomeScreenWrapper.routeName:
      return pageTransition(
        child: const HomeScreenWrapper(),
        settings: settings,
      );
    case LandingScreen.routeName:
      return pageTransition(
        child: const LandingScreen(),
        settings: settings,
      );
    case CommentScreenWrapper.routeName:
      return pageTransition(
        child: const CommentScreenWrapper(),
        settings: settings,
      );
    case ProfileScreenWrapper.routeName:
      return pageTransition(
        child: const ProfileScreenWrapper(),
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
    type: PageTransitionType.rightToLeft,
    settings: settings,
  );
}
