import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FirebaseAuth firebaseAuth;
  SplashBloc(this.firebaseAuth) : super(SplashInitial()) {
    on<CheckAuthEvent>(_handleCheckAuth);
  }

  FutureOr<void> _handleCheckAuth(
      CheckAuthEvent event, Emitter<SplashState> emit) {
    final bool isAuthed = firebaseAuth.currentUser != null;
    emit(AuthChecked(isAuthenticated: isAuthed));
  }
}
