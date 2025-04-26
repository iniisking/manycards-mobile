import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/widgets/colors.dart';

class AuthTextFormField extends StatelessWidget {
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int fontSize;
  final Color hintTextColor;
  final Color primaryBorderColor;
  final Color errorBorderColor;

  const AuthTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.fontSize = 17,
    this.hintTextColor = const Color(0xFF9A9A9A),
    required this.primaryBorderColor,
    required this.errorBorderColor,
  });

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(17.r),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      cursorColor: fisrtHeaderTextColor,
      style: TextStyle(
        fontSize: fontSize.toDouble(),
        overflow: TextOverflow.ellipsis,
        color: fisrtHeaderTextColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor,
          fontSize: fontSize.toDouble(),
          letterSpacing: 0,
          overflow: TextOverflow.ellipsis,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        focusedBorder: _buildBorder(fisrtHeaderTextColor),
        focusedErrorBorder: _buildBorder(errorBorderColor),
        enabledBorder: _buildBorder(primaryBorderColor),
        errorBorder: _buildBorder(errorBorderColor),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF232323),
      ),
    );
  }
}
