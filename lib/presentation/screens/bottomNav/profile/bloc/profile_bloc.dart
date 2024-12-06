import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/data/repository/auth_repository.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final PostRepository postRepository;
  final AuthRepository authRepository;
  ProfileBloc({required this.postRepository, required this.authRepository})
      : super(ProfileInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<SignOutEvent>(_onSignOut);
  }

  Future<void> _onFetchPosts(
      FetchPosts event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final posts = await postRepository.getPostsByUid(event.uid);
      emit(ProfileLoaded(posts));
    } catch (e) {
      log("error in fetching user's posts: ${e.toString()}");
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onSignOut(
      SignOutEvent event, Emitter<ProfileState> emit) async {
    try {
      await authRepository.signOut();
      emit(SignedOut());
    } catch (e) {
      log("error in sign out: ${e.toString()}");
      emit(ProfileError(e.toString()));
    }
  }
}
