import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:meta/meta.dart';

part 'comment_item_event.dart';
part 'comment_item_state.dart';

class CommentItemBloc extends Bloc<CommentItemEvent, CommentItemState> {
  final PostRepository _postRepository;
  CommentItemBloc(this._postRepository) : super(CommentItemInitial()) {
    on<LikeComment>(_onLikeComment);
  }

  Future<void> _onLikeComment(
      LikeComment event, Emitter<CommentItemState> emit) async {
    try {
      await _postRepository.likeComment(
          postId: event.postId, commentId: event.commentId, uid: event.uid);
      emit(CommentLikeSuccess());
    } catch (e) {
      log("error in like comment: ${e.toString()}");
      emit(CommentLikeFailure(e.toString()));
    }
  }
}
