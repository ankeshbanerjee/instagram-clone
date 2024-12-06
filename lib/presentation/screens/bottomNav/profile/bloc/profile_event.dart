part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

final class FetchPosts extends ProfileEvent {
  final String uid;

  FetchPosts(this.uid);
}

final class SignOutEvent extends ProfileEvent {}
