import 'package:flutter/material.dart';

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
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.5)),
        contentPadding: const EdgeInsets.all(10),
        suffixIcon: widget.isPassword == true
            ? IconButton(
                onPressed: () => setState(() {
                      isHidden = !isHidden;
                    }),
                icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility))
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
