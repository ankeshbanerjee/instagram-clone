import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:meta/meta.dart';

part 'add_post_event.dart';
part 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final PostRepository _postRepository;
  AddPostBloc(this._postRepository) : super(AddPostInitial()) {
    on<PickImageEvent>(_onPickImageEvent);
    on<ClearImageEvent>(_onClearImageEvent);
    on<DoAddPostEvent>(_onDoPostEvent);
  }

  Future<void> _onPickImageEvent(
      PickImageEvent event, Emitter<AddPostState> emit) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    emit(ImagePicked(File(image!.path)));
  }

  void _onClearImageEvent(ClearImageEvent event, Emitter<AddPostState> emit) {
    emit(AddPostInitial());
  }

  FutureOr<void> _onDoPostEvent(
      DoAddPostEvent event, Emitter<AddPostState> emit) async {
    final String uid = event.uid;
    final String username = event.username;
    final String desc = event.desc;
    final File imageFile = event.imageFile;
    final String profileImage = event.profilePicture;
    emit(AddPostLoading(imageFile));
    try {
      await _postRepository.uploadPost(
          desc: desc,
          uid: uid,
          username: username,
          imageFile: imageFile,
          profileImage: profileImage);
      showToast("Post added successfully");
      emit(AddPostSuccess());
    } catch (e) {
      log("error in add post bloc: ${e.toString()}");
      emit(AddPostFailure(e.toString()));
    }
  }
}
