part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {}

final class RegisterFailure extends RegisterState {
  final String errorMessage;

  RegisterFailure(this.errorMessage);
}

final class ImagePicked extends RegisterState {
  final File image;

  ImagePicked(this.image);
}
