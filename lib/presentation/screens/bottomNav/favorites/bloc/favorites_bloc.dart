import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:meta/meta.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final PostRepository _postRepository;
  FavoritesBloc(this._postRepository) : super(FavoritesInitial()) {
    on<FetchFavorites>(_onFetchFavorites);
  }

  FutureOr<void> _onFetchFavorites(
      FetchFavorites event, Emitter<FavoritesState> emit) {
    emit(FavoritesLoading());
    try {
      return emit.forEach(_postRepository.getFavorites(event.favorites),
          onData: (posts) => FavoritesFetchSuccess(posts),
          onError: (e, st) => FavoritesFetchFailure(e.toString()));
    } catch (e) {
      emit(FavoritesFetchFailure(e.toString()));
    }
  }
}
