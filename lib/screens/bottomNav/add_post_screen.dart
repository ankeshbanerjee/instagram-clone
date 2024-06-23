import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/services/post_services.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  File? _imageFile;
  final _descController = TextEditingController();
  bool _isLoading = false;

  Future<void> handleAddPost(
      String uid, String username, String profilePicture) async {
    if (_isLoading) return;
    final String desc = _descController.text;

    if (desc.isEmpty) {
      showToast("Please write a description");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await PostServices().uploadPost(
        desc: desc,
        uid: uid,
        username: username,
        profileImage: profilePicture,
        imageFile: _imageFile!,
      );
      setState(() {
        _isLoading = false;
      });
      showToast("Post added successfully!");
      clearImage();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log(e.toString());
    }
  }

  void clearImage() {
    setState(() {
      _imageFile = null;
      _descController.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: _imageFile != null
          ? AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: clearImage, icon: const Icon(Icons.arrow_back)),
              title: const Text(
                "Post Image",
              ),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => handleAddPost(
                      userProvider.getUser.uid,
                      userProvider.getUser.username,
                      userProvider.getUser.profilePicture),
                  child: const Text("Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                )
              ],
            )
          : null,
      body: _imageFile == null
          ? Center(
              child: InkWell(
                onTap: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _imageFile = File(image!.path);
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: secondaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload,
                          size: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Upload image")
                      ]),
                ),
              ),
            )
          : Column(
              children: [
                _isLoading ? const LinearProgressIndicator() : Container(),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            NetworkImage(userProvider.getUser.profilePicture),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      Expanded(
                          child: TextField(
                        controller: _descController,
                        decoration: const InputDecoration(
                            hintText: "Say something about this post"),
                        onTapOutside: (event) =>
                            FocusScope.of(context).unfocus(),
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.file(_imageFile!),
                  ),
                )
              ],
            ),
    );
  }
}
