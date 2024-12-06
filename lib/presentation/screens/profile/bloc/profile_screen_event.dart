part of 'profile_screen_bloc.dart';

@immutable
sealed class ProfileScreenEvent {}

final class FetchPostsAndProfile extends ProfileScreenEvent {
  final String uid;
  FetchPostsAndProfile(this.uid);
}

final class FollowEvent extends ProfileScreenEvent {
  final String uid;
  final String idToBeFollowed;
  FollowEvent(this.uid, this.idToBeFollowed);
}

final class UnFollowEvent extends ProfileScreenEvent {
  final String uid;
  final String idToBeUnFollowed;
  UnFollowEvent(this.uid, this.idToBeUnFollowed);
}
