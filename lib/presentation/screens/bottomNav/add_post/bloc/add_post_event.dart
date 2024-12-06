part of 'add_post_bloc.dart';

@immutable
sealed class AddPostEvent {}

final class SelectImageEvent extends AddPostEvent {}

final class ClearImageEvent extends AddPostEvent {}

final class DoAddPostEvent extends AddPostEvent {
  final String uid;
  final String username;
  final String profilePicture;
  final String desc;
  final File imageFile;

  DoAddPostEvent({
    required this.uid,
    required this.username,
    required this.profilePicture,
    required this.desc,
    required this.imageFile,
  });
}

final class PickImageEvent extends AddPostEvent {}
