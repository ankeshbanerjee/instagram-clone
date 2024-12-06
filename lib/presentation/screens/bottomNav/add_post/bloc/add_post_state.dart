part of 'add_post_bloc.dart';

@immutable
sealed class AddPostState {}

final class AddPostInitial extends AddPostState {}

final class AddPostLoading extends AddPostState {
  final File image;
  AddPostLoading(this.image);
}

final class ImagePicked extends AddPostState {
  final File image;
  ImagePicked(this.image);
}

final class AddPostSuccess extends AddPostState {}

final class AddPostFailure extends AddPostState {
  final String message;
  AddPostFailure(this.message);
}
