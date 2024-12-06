part of 'splash_bloc.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

final class AuthChecked extends SplashState {
  final bool isAuthenticated;
  AuthChecked({required this.isAuthenticated});
}
