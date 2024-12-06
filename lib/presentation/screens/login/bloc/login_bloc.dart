import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone/data/repository/auth_repository.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  LoginBloc(this.authRepository) : super(LoginInitial()) {
    on<DoLoginEvent>(_onLoginEvent);
  }

  Future<void> _onLoginEvent(
      DoLoginEvent event, Emitter<LoginState> emit) async {
    if (event.email.isEmpty || event.password.isEmpty) {
      showToast("Please fill all the details!");
      return;
    }
    emit(LoginLoading());
    try {
      await authRepository.loginUser(event.email, event.password);
      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
