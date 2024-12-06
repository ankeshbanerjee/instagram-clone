import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/configs/routes/args.dart';
import 'package:instagram_clone/presentation/common_widgets/custom_error_widget.dart';
import 'package:instagram_clone/presentation/common_widgets/loading_widget.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/search/bloc/search_bloc.dart';
import 'package:instagram_clone/presentation/screens/profile/profile_screen.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/utils/apputils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(FetchPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Scaffold(
      body: Container(
        color: theme.backgroundColor,
        child: SafeArea(
          child: Container(
            color: theme.backgroundColor,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onEditingComplete: () {
                      // await loadUsers();
                      context
                          .read<SearchBloc>()
                          .add(FetchUsersEvent(_searchController.text));
                    },
                    style: TextStyle(color: theme.primaryTextColor),
                    cursorColor: theme.secondaryTextColor,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 10,
                      ),
                      hintText: "Search",
                      hintStyle: TextStyle(color: theme.secondaryTextColor),
                      filled: true,
                      fillColor: theme.textFieldFillColor,
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.primaryTextColor,
                      ),
                    ),
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Expanded(child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                  if (state is SearchLoading) {
                    return const LoadingWidget();
                  } else if (state is PostsFetchSuccess) {
                    final posts = state.posts;
                    return MasonryGridView.count(
                      controller: searchScrollController,
                      itemCount: posts.length,
                      crossAxisCount: 3,
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      itemBuilder: (context, index) {
                        return Image.network(
                          posts[index].photoUrl,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  } else if (state is UsersFetchSuccess) {
                    final users = state.users;
                    return ListView.builder(
                      controller: searchScrollController,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final item = users[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                ProfileScreenWrapper.routeName,
                                arguments:
                                    ProfileScreenArgs(uid: users[index].uid));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(item.profilePicture),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(item.username,
                                    style: TextStyle(
                                        color: theme.primaryTextColor)),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is PostsFetchFailure) {
                    return CustomErrorWidget(
                        onRetry: () =>
                            context.read<SearchBloc>().add(FetchPostsEvent()));
                  } else if (state is UsersFetchFailure) {
                    return CustomErrorWidget(
                        onRetry: () => context
                            .read<SearchBloc>()
                            .add(FetchUsersEvent(_searchController.text)));
                  }
                  return Container();
                })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
