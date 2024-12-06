import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone/data/repository/auth_repository.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AuthRepository authRepository;
  UserBloc(this.authRepository) : super(UserInitial()) {
    on<RefreshUserEvent>(_handleRefreshUser);
    on<RemoveUserEvent>(_handleRemoveUser);
  }

  FutureOr<void> _handleRefreshUser(
      RefreshUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await authRepository.getUserDetails();
      log("user name: ${user.username}");
      emit(UserFetchSuccess(user));
    } catch (e) {
      emit(UserFetchFailure(e.toString()));
    }
  }

  FutureOr<void> _handleRemoveUser(
      RemoveUserEvent event, Emitter<UserState> emit) {
    emit(UserRemoved());
  }
}
