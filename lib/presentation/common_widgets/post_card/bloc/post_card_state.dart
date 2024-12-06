part of 'post_card_bloc.dart';

@immutable
sealed class PostCardState {}

final class PostCardInitial extends PostCardState {}

final class DeletePostSuccess extends PostCardState {}

final class DeletePostFailure extends PostCardState {
  final String errorMessage;

  DeletePostFailure(this.errorMessage);
}

final class LikePostSuccess extends PostCardState {}

final class LikePostFailure extends PostCardState {
  final String errorMessage;

  LikePostFailure(this.errorMessage);
}

final class AddToFavoritesSuccess extends PostCardState {}

final class AddToFavoritesFailure extends PostCardState {
  final String errorMessage;

  AddToFavoritesFailure(this.errorMessage);
}

final class RemoveFromFavoritesSuccess extends PostCardState {}

final class RemoveFromFavoritesFailure extends PostCardState {
  final String errorMessage;

  RemoveFromFavoritesFailure(this.errorMessage);
}

final class PostCardLoading extends PostCardState {}
