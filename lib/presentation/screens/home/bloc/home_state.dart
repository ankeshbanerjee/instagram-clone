part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {
  final int index;

  HomeInitial(this.index);
}
