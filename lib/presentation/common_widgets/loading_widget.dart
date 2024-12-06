import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/configs/theme/app_theme.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context)!.theme;
    return Center(
      child: Platform.isAndroid
          ? CircularProgressIndicator(
              color: theme.primaryBtnColor,
            )
          : CupertinoActivityIndicator(
              color: theme.primaryBtnColor,
            ),
    );
  }
}
