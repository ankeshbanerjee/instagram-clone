import 'package:flutter/material.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/common_widgets/loading_widget.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/favorites/bloc/favorites_bloc.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/presentation/common_widgets/post_card/post_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    final userState = context.read<UserBloc>().state;
    if (userState is UserFetchSuccess) {
      context
          .read<FavoritesBloc>()
          .add(FetchFavorites(userState.user.favorites));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserFetchSuccess) {
          context
              .read<FavoritesBloc>()
              .add(FetchFavorites(state.user.favorites));
        }
      },
      child: Builder(builder: (context) {
        final userState = context.watch<UserBloc>().state;
        final tabState = context.watch<FavoritesBloc>().state;
        return Scaffold(
          appBar: AppBar(
              centerTitle: false,
              backgroundColor: theme.backgroundColor,
              title: Text(
                "Favorites",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: theme.primaryTextColor),
              )),
          body:
              userState is UserFetchSuccess && userState.user.favorites.isEmpty
                  ? Container(
                      color: theme.backgroundColor,
                      child: Center(
                        child: Text(
                          "Nothing to show!",
                          style: TextStyle(
                              fontSize: 16, color: theme.primaryTextColor),
                        ),
                      ),
                    )
                  : tabState is FavoritesFetchSuccess
                      ? Container(
                          color: theme.backgroundColor,
                          child: ListView.builder(
                              controller: favoriteScrollController,
                              itemCount: tabState.posts.length,
                              itemBuilder: (context, index) {
                                return PostCard(post: tabState.posts[index]);
                              }),
                        )
                      : tabState is FavoritesLoading
                          ? const LoadingWidget()
                          : Container(),
        );
      }),
    );
  }
}
