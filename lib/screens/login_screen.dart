import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/register_screen.dart';
import 'package:instagram_clone/services/auth_services.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> handleLogin() async {
    if (isLoading) return;
    final email = _emailController.text;
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      showToast("Please fill all the details!");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await AuthServices().loginUser(email, password);
      setState(() {
        isLoading = false;
      });
      showToast("Login successful!");
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    } catch (e) {
      log(e.toString());
      showToast(e.toString());
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
          SvgPicture.asset(
            'assets/ic_instagram.svg',
            height: 60,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(height: 66),
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
            onTap: handleLogin,
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                  color: blueColor,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Login',
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
              const Text("Don't have an account? "),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RegisterScreen.routeName);
                },
                child: const Text(
                  "Sign Up",
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
