part of 'post_card_bloc.dart';

@immutable
sealed class PostCardEvent {}

final class DeletePost extends PostCardEvent {
  final String postId;

  DeletePost(this.postId);
}

final class LikePost extends PostCardEvent {
  final String postId;
  final String uid;

  LikePost({required this.postId, required this.uid});
}

final class AddToFavorites extends PostCardEvent {
  final String postId;
  final String uid;

  AddToFavorites({required this.postId, required this.uid});
}

final class RemoveFromFavorites extends PostCardEvent {
  final String postId;
  final String uid;

  RemoveFromFavorites({required this.postId, required this.uid});
}
