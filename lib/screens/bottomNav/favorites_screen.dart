import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/theme/app_theme.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final User user = ref.watch(userProvider)!;
    final appTheme = AppTheme.of(context)!;
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          backgroundColor: appTheme.theme.backgroundColor,
          title: Text(
            "Favorites",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: appTheme.theme.primaryTextColor),
          )),
      body: user.favorites.isEmpty
          ? Container(
              color: appTheme.theme.backgroundColor,
              child: Center(
                child: Text(
                  "Nothing to show!",
                  style: TextStyle(
                      fontSize: 16, color: appTheme.theme.primaryTextColor),
                ),
              ),
            )
          : Container(
              color: appTheme.theme.backgroundColor,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(DBCollections.posts.name)
                    .where(FieldPath.documentId, whereIn: user.favorites)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> posts = snapshot.data!.docs;
                    return ListView.builder(
                        controller: favoriteScrollController,
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
