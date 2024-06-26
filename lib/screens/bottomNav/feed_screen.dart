import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/theme/app_theme.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: appTheme.theme.backgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          colorFilter: ColorFilter.mode(
              appTheme.theme.primaryTextColor, BlendMode.srcIn),
          height: 36,
        ),
        actions: [
          IconButton(
              onPressed: () {
                appTheme.toggleTheme();
              },
              icon: appTheme.theme.isDark
                  ? const Icon(
                      Icons.light_mode_outlined,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.dark_mode_outlined,
                      color: Colors.black,
                    ))
        ],
      ),
      body: Container(
        color: appTheme.theme.backgroundColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(DBCollections.posts.name)
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> posts = snapshot.data!.docs;
              return ListView.builder(
                  controller: feedScrollController,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = Post.fromJson(
                        posts[index].data() as Map<String, dynamic>);
                    return PostCard(post: post);
                  });
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong!"),
              );
            }
            return CircularProgressIndicator(
              color: Colors.blue.shade600,
            );
          },
        ),
      ),
    );
  }
}
