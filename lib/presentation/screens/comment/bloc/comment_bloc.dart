import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:instagram_clone/models/comment.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:meta/meta.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final PostRepository _postRepository;
  CommentBloc(this._postRepository) : super(CommentInitial()) {
    on<FetchComments>(_onFetchComments);
    on<AddComment>(_onAddComment);
  }

  FutureOr<void> _onFetchComments(
      FetchComments event, Emitter<CommentState> emit) {
    emit(CommentLoading());
    try {
      return emit.forEach(
        _postRepository.getComments(event.postId),
        onData: (comments) => CommentsFetchSuccess(comments),
        onError: (e, st) => CommentsFetchFailure(e.toString()),
      );
    } catch (e) {
      log("error in fetching comments: ${e.toString()}");
      emit(CommentsFetchFailure(e.toString()));
    }
  }

  Future<void> _onAddComment(
      AddComment event, Emitter<CommentState> emit) async {
    try {
      if (event.comment.trim().isEmpty) {
        showToast("Please enter a valid comment");
        return;
      }
      await _postRepository.addComment(
          postId: event.postId,
          content: event.comment,
          username: event.username,
          uid: event.uid,
          profilePic: event.profilePic);

      emit(AddCommentSuccess());
    } catch (e) {
      log("error in adding comment: ${e.toString()}");
      emit(AddCommentFailure(e.toString()));
    }
  }
}
