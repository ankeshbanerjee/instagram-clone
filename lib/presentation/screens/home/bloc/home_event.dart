part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class TabChange extends HomeEvent {
  final int index;

  TabChange(this.index);
}
