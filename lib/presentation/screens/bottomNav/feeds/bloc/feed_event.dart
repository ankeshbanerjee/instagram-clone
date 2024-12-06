part of 'feed_bloc.dart';

@immutable
sealed class FeedEvent {}

final class FetchFeed extends FeedEvent {}
