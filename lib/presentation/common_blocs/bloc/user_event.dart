part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class RefreshUserEvent extends UserEvent {}

class RemoveUserEvent extends UserEvent {}
