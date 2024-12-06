part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesEvent {}

final class FetchFavorites extends FavoritesEvent {
  final List favorites;
  FetchFavorites(this.favorites);
}
