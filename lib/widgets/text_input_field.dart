import 'package:flutter/material.dart';
import 'package:instagram_clone/theme/app_theme.dart';

class CustomeTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  const CustomeTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.isPassword = false,
      this.keyboardType = TextInputType.text});

  @override
  State<CustomeTextField> createState() => _CustomeTextFieldState();
}

class _CustomeTextFieldState extends State<CustomeTextField> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return TextField(
      controller: widget.controller,
      style: TextStyle(color: appTheme!.theme.primaryTextColor),
      cursorColor: appTheme.theme.secondaryTextColor,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: appTheme.theme.secondaryTextColor),
        filled: true,
        fillColor: appTheme.theme.textFieldFillColor,
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: appTheme.theme.secondaryTextColor, width: 0.5)),
        contentPadding: const EdgeInsets.all(10),
        suffixIcon: widget.isPassword == true
            ? IconButton(
                onPressed: () => setState(() {
                  isHidden = !isHidden;
                }),
                icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
                color: appTheme.theme.primaryTextColor,
              )
            : null,
      ),
      obscureText: widget.isPassword == true ? isHidden : false,
      keyboardType: widget.keyboardType,
      onTapOutside: (e) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
