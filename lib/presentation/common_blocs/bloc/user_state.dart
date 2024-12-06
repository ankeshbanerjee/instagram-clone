part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserFetchSuccess extends UserState {
  final User user;

  UserFetchSuccess(this.user);
}

final class UserFetchFailure extends UserState {
  final String message;

  UserFetchFailure(this.message);
}

final class UserRemoved extends UserState {}
