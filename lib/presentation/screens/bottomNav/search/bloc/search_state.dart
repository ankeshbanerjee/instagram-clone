part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

final class SearchInitial extends SearchState {}

final class SearchLoading extends SearchState {}

final class PostsFetchSuccess extends SearchState {
  final List<Post> posts;
  PostsFetchSuccess(this.posts);
}

final class PostsFetchFailure extends SearchState {
  final String message;
  PostsFetchFailure(this.message);
}

final class UsersFetchSuccess extends SearchState {
  final List<User> users;
  UsersFetchSuccess(this.users);
}

final class UsersFetchFailure extends SearchState {
  final String message;
  UsersFetchFailure(this.message);
}
