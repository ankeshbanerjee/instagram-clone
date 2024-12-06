part of 'profile_screen_bloc.dart';

@immutable
sealed class ProfileScreenState {}

final class ProfileScreenInitial extends ProfileScreenState {}

final class ProfileScreenLoading extends ProfileScreenState {}

final class FetchPostsAndProfileSuccess extends ProfileScreenState {
  final List<Post> posts;
  final User profile;
  FetchPostsAndProfileSuccess({required this.posts, required this.profile});
}

final class FetchPostsAndProfileFailure extends ProfileScreenState {
  final String error;
  FetchPostsAndProfileFailure(this.error);
}

final class FollowFailure extends ProfileScreenState {
  final String error;
  FollowFailure(this.error);
}

final class UnFollowFailure extends ProfileScreenState {
  final String error;
  UnFollowFailure(this.error);
}
