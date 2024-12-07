import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/configs/routes/screens.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';
import 'package:instagram_clone/presentation/common_blocs/bloc/user_bloc.dart';
import 'package:instagram_clone/presentation/common_widgets/loading_widget.dart';

class LandingScreen extends StatefulWidget {
  static const routeName = '/landing';
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    context.read<UserBloc>().add(RefreshUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Container(
      color: theme.backgroundColor,
      child: BlocConsumer<UserBloc, UserState>(listener: (context, state) {
        if (state is UserFetchSuccess) {
          Navigator.of(context)
              .pushReplacementNamed(HomeScreenWrapper.routeName);
        }
      }, builder: (context, state) {
        if (state is UserLoading) {
          return const LoadingWidget();
        }
        return Container();
      }),
    );
  }
}
