import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/configs/routes/screens.dart';
import 'package:instagram_clone/di/service_locator.dart';
import 'package:instagram_clone/presentation/screens/login/bloc/login_bloc.dart';
import 'package:instagram_clone/services/assets_provider/svg_assets_provider.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/utils/apputils.dart';
import 'package:instagram_clone/presentation/common_widgets/text_input_field.dart';

class LoginScreenWrapper extends StatelessWidget {
  static const String routeName = '/login';
  const LoginScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(getIt()),
      child: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, LandingScreen.routeName, (route) => false);
        } else if (state is LoginFailure) {
          showToast(state.errorMessage);
        }
      },
      builder: (context, state) {
        return Container(
          color: theme.backgroundColor,
          child: SafeArea(
              child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                SvgPicture.asset(
                  SvgAssetsProvider.instagram,
                  height: 60,
                  colorFilter:
                      ColorFilter.mode(theme.primaryTextColor, BlendMode.srcIn),
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
                  onTap: () {
                    if (state is LoginLoading) {
                      return;
                    }
                    context.read<LoginBloc>().add(DoLoginEvent(
                        _emailController.text, _passwordController.text));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        color: theme.primaryBtnColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4))),
                    child: state is LoginLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
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
                    Text("Don't have an account? ",
                        style: TextStyle(color: theme.primaryTextColor)),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RegisterScreenWrapper.routeName);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryTextColor),
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
