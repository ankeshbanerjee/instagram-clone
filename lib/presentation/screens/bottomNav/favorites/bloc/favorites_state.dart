part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesFetchSuccess extends FavoritesState {
  final List<Post> posts;

  FavoritesFetchSuccess(this.posts);
}

final class FavoritesFetchFailure extends FavoritesState {
  final String message;

  FavoritesFetchFailure(this.message);
}
