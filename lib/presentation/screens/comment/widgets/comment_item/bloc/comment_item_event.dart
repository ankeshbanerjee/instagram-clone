part of 'comment_item_bloc.dart';

@immutable
sealed class CommentItemEvent {}

final class LikeComment extends CommentItemEvent {
  final String postId;
  final String commentId;
  final String uid;
  LikeComment(
      {required this.postId, required this.commentId, required this.uid});
}
