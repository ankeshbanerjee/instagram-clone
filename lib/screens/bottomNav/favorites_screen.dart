import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/widgets/post_card.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = context.watch<UserProvider>().getUser;
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          backgroundColor: mobileBackgroundColor,
          title: const Text(
            "Favorites",
            style: TextStyle(fontWeight: FontWeight.w600),
          )),
      body: user.favorites.isEmpty
          ? const Center(
              child: Text(
                "Nothing to show!",
                style: TextStyle(fontSize: 16),
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(DBCollections.posts.name)
                  .where(FieldPath.documentId, whereIn: user.favorites)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> posts = snapshot.data!.docs;
                  return ListView.builder(
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
