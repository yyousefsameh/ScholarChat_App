import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.keyBoardType,
  });

  final String? hintText;
  final Function(String)? onChanged;
  IconButton? suffixIcon;
  bool? obscureText = false;
  TextEditingController? controller;
  TextInputType? keyBoardType;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyBoardType,
      controller: controller,
      validator: (data) {
        if (data!.isEmpty) {
          return 'field is required';
        }
        return null;
      },
      obscureText: obscureText!,
      onChanged: onChanged,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
