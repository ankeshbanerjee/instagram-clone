import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/firebase_options.dart';
import 'package:instagram_clone/router/routes.dart';
import 'package:instagram_clone/screens/splash_screen.dart';
import 'package:instagram_clone/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeProvider(
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        // routes: routes,
        onGenerateRoute: onGenerateRoute,
      ),
    );
  }
}
