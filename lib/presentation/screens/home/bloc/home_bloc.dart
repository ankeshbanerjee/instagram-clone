import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial(0)) {
    on<TabChange>(_onTabChange);
  }

  void _onTabChange(TabChange event, Emitter<HomeState> emit) {
    emit(HomeInitial(event.index));
  }
}
