import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: AppColors.textLight),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.fieldFill,
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textHint),
          prefixIcon: Icon(prefixIcon, color: AppColors.textLight),
          suffixIcon: isPassword
              ? const Icon(Icons.visibility_off, color: AppColors.textLight)
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
