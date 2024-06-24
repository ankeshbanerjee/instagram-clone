import 'package:flutter/material.dart';
import 'package:instagram_clone/router/args.dart';
import 'package:instagram_clone/utils/colors.dart';

class CommentScreen extends StatefulWidget {
  static String routeName = "/comment";
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as CommentScreenArgs;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Comments"),
        centerTitle: false,
      ),
    );
  }
}
