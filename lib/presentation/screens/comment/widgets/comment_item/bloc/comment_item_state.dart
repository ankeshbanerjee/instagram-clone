part of 'comment_item_bloc.dart';

@immutable
sealed class CommentItemState {}

final class CommentItemInitial extends CommentItemState {}

final class CommentLikeSuccess extends CommentItemState {}

final class CommentLikeFailure extends CommentItemState {
  final String message;
  CommentLikeFailure(this.message);
}
