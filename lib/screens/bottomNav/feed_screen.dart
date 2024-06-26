import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/utils/colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
          height: 36,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message_outlined))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
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
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
