import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/configs/routes/screens.dart';
import 'package:instagram_clone/di/service_locator.dart';
import 'package:instagram_clone/presentation/screens/register/bloc/register_bloc.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/utils/constants.dart';
import 'package:instagram_clone/presentation/common_widgets/text_input_field.dart';

class RegisterScreenWrapper extends StatelessWidget {
  static const String routeName = '/register';
  const RegisterScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(getIt()),
      child: RegisterScreen(),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context)!;
    return Scaffold(
        body: BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          showToast("Registered Successfully!");
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreenWrapper.routeName, (route) => false);
        } else if (state is RegisterFailure) {
          showToast(state.errorMessage);
        }
      },
      builder: (context, state) {
        return Container(
          color: appTheme.theme.backgroundColor,
          child: SafeArea(
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
                      backgroundImage: state is ImagePicked
                          ? FileImage(state.image) as ImageProvider
                          : const NetworkImage(userIcon),
                    ),
                    Positioned(
                        bottom: -4,
                        right: 0,
                        child: IconButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  appTheme.theme.primaryBtnColor),
                              padding: WidgetStateProperty.all(
                                  const EdgeInsets.all(10))),
                          onPressed: () {
                            context.read<RegisterBloc>().add(ChooseImage());
                          },
                          icon: const Icon(Icons.add_a_photo),
                          color: Colors.white,
                        ))
                  ],
                ),
                const SizedBox(height: 24),
                CustomeTextField(
                    controller: _nameController,
                    hintText: "Enter your username"),
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
                  onTap: () {
                    if (state is RegisterLoading) return;
                    context.read<RegisterBloc>().add(DoRegisterEvent(
                        email: _emailController.text,
                        password: _passwordController.text,
                        username: _nameController.text,
                        bio: _bioController.text,
                        profilePicture:
                            state is ImagePicked ? state.image : null));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: appTheme.theme.primaryBtnColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4))),
                    child: state is RegisterLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
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
                    Text(
                      "Already have an account? ",
                      style: TextStyle(color: appTheme.theme.primaryTextColor),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: appTheme.theme.primaryTextColor),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
        );
      },
    ));
  }
}
