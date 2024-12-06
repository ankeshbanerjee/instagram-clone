part of 'comment_bloc.dart';

@immutable
sealed class CommentEvent {}

final class FetchComments extends CommentEvent {
  final String postId;
  FetchComments(this.postId);
}

final class AddComment extends CommentEvent {
  final String postId;
  final String username;
  final String uid;
  final String profilePic;
  final String comment;

  AddComment(
      {required this.postId,
      required this.username,
      required this.uid,
      required this.profilePic,
      required this.comment});
}
