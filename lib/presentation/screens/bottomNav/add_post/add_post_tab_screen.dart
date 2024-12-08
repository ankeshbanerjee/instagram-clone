import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/screens/bottomNav/add_post/bloc/add_post_bloc.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key});

  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Builder(
      builder: (context) {
        final tabState = context.watch<AddPostBloc>().state;
        final userState = context.watch<UserBloc>().state;
        return Scaffold(
          appBar: tabState is ImagePicked || tabState is AddPostLoading
              ? AppBar(
                  backgroundColor: theme.backgroundColor,
                  leading: IconButton(
                      onPressed: () {
                        context.read<AddPostBloc>().add(ClearImageEvent());
                        _descController.clear();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.primaryTextColor,
                      )),
                  title: Text(
                    "Post Image",
                    style: TextStyle(color: theme.primaryTextColor),
                  ),
                  centerTitle: false,
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (tabState is AddPostLoading) {
                          return;
                        }
                        if (userState is UserFetchSuccess &&
                            tabState is ImagePicked) {
                          final user = userState.user;
                          context.read<AddPostBloc>().add(DoAddPostEvent(
                              uid: user.uid,
                              username: user.username,
                              profilePicture: user.profilePicture,
                              desc: _descController.text,
                              imageFile: tabState.image));
                        }
                      },
                      child: const Text("Post",
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                    )
                  ],
                )
              : null,
          body: tabState is AddPostInitial || tabState is AddPostSuccess
              ? Container(
                  color: theme.backgroundColor,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        context.read<AddPostBloc>().add(PickImageEvent());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(20),
                        height: MediaQuery.of(context).size.height / 6,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: theme.secondaryTextColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload,
                                size: 40,
                                color: theme.primaryTextColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("Upload image",
                                  style:
                                      TextStyle(color: theme.primaryTextColor))
                            ]),
                      ),
                    ),
                  ),
                )
              : Container(
                  color: theme.backgroundColor,
                  child: Column(
                    children: [
                      tabState is AddPostLoading
                          ? const LinearProgressIndicator()
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            userState is UserFetchSuccess
                                ? CircleAvatar(
                                    radius: 24,
                                    backgroundImage: NetworkImage(
                                        userState.user.profilePicture),
                                  )
                                : Container(),
                            const SizedBox(
                              width: 14,
                            ),
                            Expanded(
                                child: TextField(
                              style: TextStyle(color: theme.primaryTextColor),
                              controller: _descController,
                              decoration: InputDecoration(
                                hintText: "Say something about this post",
                                hintStyle:
                                    TextStyle(color: theme.secondaryTextColor),
                              ),
                              onTapOutside: (event) =>
                                  FocusScope.of(context).unfocus(),
                            ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      tabState is ImagePicked || tabState is AddPostLoading
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Image.file((tabState as dynamic).image),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
        );
      },
    );
  }
}
