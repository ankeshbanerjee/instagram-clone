part of 'comment_bloc.dart';

@immutable
sealed class CommentState {}

final class CommentInitial extends CommentState {}

final class CommentLoading extends CommentState {}

final class CommentsFetchSuccess extends CommentState {
  final List<Comment> comments;
  CommentsFetchSuccess(this.comments);
}

final class CommentsFetchFailure extends CommentState {
  final String message;
  CommentsFetchFailure(this.message);
}

final class AddCommentSuccess extends CommentState {}

final class AddCommentFailure extends CommentState {
  final String message;
  AddCommentFailure(this.message);
}
