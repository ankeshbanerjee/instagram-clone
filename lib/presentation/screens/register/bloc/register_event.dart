part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

final class DoRegisterEvent extends RegisterEvent {
  final String email;
  final String password;
  final String username;
  final String bio;
  final File? profilePicture;

  DoRegisterEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.bio,
    this.profilePicture,
  });
}

final class ChooseImage extends RegisterEvent {}
