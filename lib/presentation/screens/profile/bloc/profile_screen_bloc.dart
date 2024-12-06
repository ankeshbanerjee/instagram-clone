import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:instagram_clone/data/repository/profile_repository.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:meta/meta.dart';

part 'profile_screen_event.dart';
part 'profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final PostRepository postRepository;
  final ProfileRepository profileRepository;

  List<Post> posts = [];
  User? profile;

  ProfileScreenBloc(
      {required this.postRepository, required this.profileRepository})
      : super(ProfileScreenInitial()) {
    on<FollowEvent>(_onFollowEvent);
    on<UnFollowEvent>(_onUnFollowEvent);
    on<FetchPostsAndProfile>(_onFetchPostsAndProfile);
  }

  Future<void> _onFollowEvent(
      FollowEvent event, Emitter<ProfileScreenState> emit) async {
    emit(ProfileScreenLoading());
    try {
      await profileRepository.follow(event.uid, event.idToBeFollowed);
      profile = await profileRepository.getUserByUid(event.idToBeFollowed);
      emit(FetchPostsAndProfileSuccess(posts: posts, profile: profile!));
    } catch (e) {
      emit(FollowFailure(e.toString()));
    }
  }

  Future<void> _onUnFollowEvent(
      UnFollowEvent event, Emitter<ProfileScreenState> emit) async {
    emit(ProfileScreenLoading());
    try {
      await profileRepository.unfollow(event.uid, event.idToBeUnFollowed);
      profile = await profileRepository.getUserByUid(event.idToBeUnFollowed);
      emit(FetchPostsAndProfileSuccess(posts: posts, profile: profile!));
    } catch (e) {
      emit(UnFollowFailure(e.toString()));
    }
  }

  Future<void> _onFetchPostsAndProfile(
      FetchPostsAndProfile event, Emitter<ProfileScreenState> emit) async {
    emit(ProfileScreenLoading());
    try {
      posts = await postRepository.getPostsByUid(event.uid);
      profile = await profileRepository.getUserByUid(event.uid);
      emit(FetchPostsAndProfileSuccess(posts: posts, profile: profile!));
    } catch (e) {
      emit(FetchPostsAndProfileFailure(e.toString()));
    }
  }
}
