import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:instagram_clone/data/repository/profile_repository.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final PostRepository postRepository;
  final ProfileRepository profileRepository;
  SearchBloc({
    required this.postRepository,
    required this.profileRepository,
  }) : super(SearchInitial()) {
    on<FetchPostsEvent>(_onFetchPostsEvent);
    on<FetchUsersEvent>(_onFetchUsersEvent);
  }

  FutureOr<void> _onFetchPostsEvent(
      FetchPostsEvent event, Emitter<SearchState> emit) {
    emit(SearchLoading());
    try {
      return emit.forEach(postRepository.getAllPosts(),
          onData: (posts) => PostsFetchSuccess(posts),
          onError: (e, st) => PostsFetchFailure(e.toString()));
    } catch (e) {
      log("error in fetching posts in search bloc: ${e.toString()}");
      emit(PostsFetchFailure(e.toString()));
    }
  }

  void _onFetchUsersEvent(
      FetchUsersEvent event, Emitter<SearchState> emit) async {
    final String query = event.query;
    if (query.trim().isEmpty) {
      showToast("Please enter a valid query");
      return;
    }
    emit(SearchLoading());
    try {
      final users = await profileRepository.getUsersByUsername(query);
      emit(UsersFetchSuccess(users));
    } catch (e) {
      log("error in fetching users in search bloc: ${e.toString()}");
      emit(UsersFetchFailure(e.toString()));
    }
  }
}
