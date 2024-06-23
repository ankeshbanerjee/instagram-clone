import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/services/auth_services.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/widgets/text_input_field.dart';

class RegisterScreen extends StatefulWidget {
  static String routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _passwordController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? imageFile;
  bool isLoading = false;

  Future<void> handleRegister() async {
    if (isLoading) return;
    final username = _nameController.text;
    final bio = _bioController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    if (username.isEmpty || bio.isEmpty || email.isEmpty || password.isEmpty) {
      showToast('Please enter all the details!');
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await AuthServices().registerUser(
          username: username,
          email: email,
          bio: bio,
          password: password,
          profilePicture: imageFile);
      setState(() {
        isLoading = false;
      });
      showToast("Registered Successfully! Please login now.");
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: imageFile != null
                    ? FileImage(imageFile!) as ImageProvider
                    : const NetworkImage(userIcon),
              ),
              Positioned(
                  bottom: -4,
                  right: 0,
                  child: IconButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(blueColor),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.all(10))),
                    onPressed: () async {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        imageFile = File(image!.path);
                      });
                    },
                    icon: const Icon(Icons.add_a_photo),
                    color: primaryColor,
                  ))
            ],
          ),
          const SizedBox(height: 24),
          CustomeTextField(
              controller: _nameController, hintText: "Enter your username"),
          const SizedBox(height: 14),
          CustomeTextField(
              controller: _bioController, hintText: "Enter your bio"),
          const SizedBox(height: 14),
          CustomeTextField(
              controller: _emailController, hintText: "Enter your email"),
          const SizedBox(height: 14),
          CustomeTextField(
            controller: _passwordController,
            hintText: "Enter your password",
            isPassword: true,
          ),
          const SizedBox(height: 30),
          InkWell(
            onTap: handleRegister,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                  color: blueColor,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    )));
  }
}
