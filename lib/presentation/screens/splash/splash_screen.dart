import 'package:flutter/material.dart';
import 'package:instagram_clone/di/service_locator.dart';
import 'package:instagram_clone/presentation/common_widgets/render_svg.dart';
import 'package:instagram_clone/presentation/screens/home/home_screen.dart';
import 'package:instagram_clone/presentation/screens/login/login_screen.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/presentation/screens/splash/bloc/splash_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/services/assets_provider/svg_assets_provider.dart';

class SplashScreenWrapper extends StatelessWidget {
  static const String routeName = '/splash';
  const SplashScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc(getIt()),
      child: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        context.read<SplashBloc>().add(CheckAuthEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Scaffold(
        body: BlocConsumer<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is AuthChecked) {
          if (state.isAuthenticated) {
            Navigator.pushReplacementNamed(
                context, HomeScreenWrapper.routeName);
          } else {
            Navigator.pushReplacementNamed(
                context, LoginScreenWrapper.routeName);
          }
        }
      },
      builder: (context, state) {
        return Container(
          color: theme.backgroundColor,
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              RenderSvg(
                path: SvgAssetsProvider.instagram,
                color: theme.primaryTextColor,
              )
            ]),
          ),
        );
      },
    ));
  }
}
