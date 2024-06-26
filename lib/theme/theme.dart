import 'package:flutter/material.dart';

class MyTheme {
  final bool isDark;
  final Color backgroundColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color primaryBtnColor;
  final Color secondaryBtnColor;
  final Color textFieldFillColor;
  final Color whiteInverse;
  final Color blackInverse;
  const MyTheme({
    required this.isDark,
    required this.backgroundColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.primaryBtnColor,
    required this.secondaryBtnColor,
    required this.textFieldFillColor,
    required this.whiteInverse,
    required this.blackInverse,
  });
}
