part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

final class DoLoginEvent extends LoginEvent {
  final String email;
  final String password;

  DoLoginEvent(this.email, this.password);
}
