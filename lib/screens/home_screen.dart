import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = '/';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
