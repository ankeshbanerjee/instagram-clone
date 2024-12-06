part of 'feed_bloc.dart';

@immutable
sealed class FeedState {}

final class FeedInitial extends FeedState {}

final class FeedLoading extends FeedState {}

final class FeedFetched extends FeedState {
  final List<Post> posts;

  FeedFetched(this.posts);
}

final class FeedError extends FeedState {
  final String message;

  FeedError(this.message);
}
