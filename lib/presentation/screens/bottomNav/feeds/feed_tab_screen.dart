import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/presentation/common_widgets/custom_error_widget.dart';
import 'package:instagram_clone/presentation/common_widgets/loading_widget.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/feeds/bloc/feed_bloc.dart';
import 'package:instagram_clone/services/assets_provider/svg_assets_provider.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/presentation/common_widgets/post_card/post_card.dart';

class FeedTabScreen extends StatefulWidget {
  const FeedTabScreen({super.key});

  @override
  State<FeedTabScreen> createState() => _FeedTabScreenState();
}

class _FeedTabScreenState extends State<FeedTabScreen> {
  @override
  void initState() {
    context.read<FeedBloc>().add(FetchFeed());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: theme.backgroundColor,
        title: SvgPicture.asset(
          SvgAssetsProvider.instagram,
          colorFilter:
              ColorFilter.mode(theme.primaryTextColor, BlendMode.srcIn),
          height: 36.0,
        ),
        actions: [
          IconButton(
              onPressed: () {
                AppTheme.of(context)!.toggleTheme();
              },
              icon: theme.isDark
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
      body: BlocBuilder<FeedBloc, FeedState>(
        buildWhen: (previous, current) {
          log("previous: $previous, current: $current");
          return true;
        },
        builder: (context, state) {
          if (state is FeedLoading) {
            return Container(
                color: theme.backgroundColor, child: const LoadingWidget());
          } else if (state is FeedError) {
            return CustomErrorWidget(onRetry: () {
              context.read<FeedBloc>().add(FetchFeed());
            });
          } else if (state is FeedFetched) {
            final posts = state.posts;
            return Container(
              color: theme.backgroundColor,
              child: ListView.builder(
                  controller: feedScrollController,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    return PostCard(post: posts[index]);
                  }),
            );
          } else {
            return Container(
              color: theme.backgroundColor,
            );
          }
        },
      ),
    );
  }
}
