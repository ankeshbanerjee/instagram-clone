import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:meta/meta.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;
  StreamSubscription? _postSubscription;

  FeedBloc(this._postRepository) : super(FeedInitial()) {
    on<FetchFeed>(_onFetchFeed);
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onFetchFeed(FetchFeed event, Emitter<FeedState> emit) {
    emit(FeedLoading());
    try {
      return emit.forEach(_postRepository.getAllPosts(),
          onData: (posts) => FeedFetched(posts),
          onError: (error, stackTrace) => FeedError(error.toString()));
    } catch (e) {
      log("error in feed fetch bloc: ${e.toString()}");
      emit(FeedError(e.toString()));
    }
  }
}
