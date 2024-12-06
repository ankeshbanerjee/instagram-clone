import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/data/repository/auth_repository.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<DoRegisterEvent>(_onRegisterEvent);
    on<ChooseImage>(_onChooseImage);
  }

  Future<void> _onRegisterEvent(
      DoRegisterEvent event, Emitter<RegisterState> emit) async {
    if (event.email.isEmpty ||
        event.username.isEmpty ||
        event.bio.isEmpty ||
        event.password.isEmpty) {
      showToast("Please enter all the details");
      return;
    }
    emit(RegisterLoading());
    try {
      await _authRepository.registerUser(
          username: event.username,
          email: event.email,
          password: event.password,
          profilePicture: event.profilePicture,
          bio: event.bio);
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  Future<void> _onChooseImage(
      ChooseImage event, Emitter<RegisterState> emit) async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    emit(ImagePicked(File(image!.path)));
  }
}
