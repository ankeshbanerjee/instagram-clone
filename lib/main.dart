import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/di/service_locator.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/configs/routes/routes.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/screens/splash/splash_screen.dart';
import 'package:instagram_clone/configs/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  serviceLocator();
  Bloc.observer = MyBlocObserver();
  // runApp(const ProviderScope(child: MyApp()));
  runApp(BlocProvider(
    create: (_) => UserBloc(getIt()),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeProvider(
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreenWrapper.routeName,
        // routes: routes,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log('Event: $event in Bloc: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('State changed in Bloc: ${bloc.runtimeType} => $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('Transition: $transition in Bloc: ${bloc.runtimeType}');
  }
}
