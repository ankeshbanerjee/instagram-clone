part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

final class FetchPostsEvent extends SearchEvent {}

final class FetchUsersEvent extends SearchEvent {
  final String query;
  FetchUsersEvent(this.query);
}
