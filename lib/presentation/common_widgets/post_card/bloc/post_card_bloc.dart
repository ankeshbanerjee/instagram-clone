import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:instagram_clone/data/repository/profile_repository.dart';
import 'package:meta/meta.dart';

part 'post_card_event.dart';
part 'post_card_state.dart';

class PostCardBloc extends Bloc<PostCardEvent, PostCardState> {
  final PostRepository postRepository;
  final ProfileRepository profileRepository;

  PostCardBloc({
    required this.postRepository,
    required this.profileRepository,
  }) : super(PostCardInitial()) {
    on<DeletePost>(_onDeletePost);
    on<LikePost>(_onLikePost);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
  }

  Future<void> _onDeletePost(
      DeletePost event, Emitter<PostCardState> emit) async {
    try {
      await postRepository.deletePost(postId: event.postId);
      emit(DeletePostSuccess());
    } catch (e) {
      emit(DeletePostFailure(e.toString()));
    }
  }

  Future<void> _onLikePost(LikePost event, Emitter<PostCardState> emit) async {
    try {
      await postRepository.likePost(
        postId: event.postId,
        uid: event.uid,
      );
      emit(LikePostSuccess());
    } catch (e) {
      emit(LikePostFailure(e.toString()));
    }
  }

  Future<void> _onAddToFavorites(
      AddToFavorites event, Emitter<PostCardState> emit) async {
    emit(PostCardLoading());
    try {
      await profileRepository.addToFavorites(
        event.uid,
        event.postId,
      );
      emit(AddToFavoritesSuccess());
    } catch (e) {
      emit(AddToFavoritesFailure(e.toString()));
    }
  }

  Future<void> _onRemoveFromFavorites(
      RemoveFromFavorites event, Emitter<PostCardState> emit) async {
    emit(PostCardLoading());
    try {
      await profileRepository.removeFromFavorites(
        event.uid,
        event.postId,
      );
      emit(RemoveFromFavoritesSuccess());
    } catch (e) {
      emit(RemoveFromFavoritesFailure(e.toString()));
    }
  }
}
