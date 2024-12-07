import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:instagram_clone/data/data_provider/auth_data_provider.dart';
import 'package:instagram_clone/data/data_provider/post_data_provider.dart';
import 'package:instagram_clone/data/data_provider/profile_data_provider.dart';
import 'package:instagram_clone/data/data_provider/upload_data_provider.dart';
import 'package:instagram_clone/data/repository/auth_repository.dart';
import 'package:instagram_clone/data/repository/post_repository.dart';
import 'package:instagram_clone/data/repository/profile_repository.dart';
import 'package:instagram_clone/data/repository/upload_repository.dart';

final getIt = GetIt.instance;

void serviceLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);

  // auth data
  getIt.registerLazySingleton<AuthDataProvider>(() => AuthDataProvider(
      auth: getIt(), firestore: getIt(), uploadRepository: getIt()));
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(authDataProvider: getIt()));

  // post data
  getIt.registerLazySingleton<PostDataProvider>(
      () => PostDataProvider(fireStore: getIt(), uploadRepository: getIt()));
  getIt.registerLazySingleton<PostRepository>(
      () => PostRepository(postDataProvider: getIt()));

  // profile data
  getIt.registerLazySingleton<ProfileDataProvider>(
      () => ProfileDataProvider(fireStore: getIt()));
  getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepository(profileDataProvider: getIt()));

  // upload file
  getIt.registerLazySingleton<UploadDataProvider>(
      () => UploadDataProvider(firebaseStorage: getIt()));
  getIt.registerLazySingleton<UploadRepository>(
      () => UploadRepository(uploadDataProvider: getIt()));
}
