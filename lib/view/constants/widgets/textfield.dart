import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/view/constants/widgets/colors.dart';

class AuthTextFormField extends StatefulWidget {
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

  @override
  State<AuthTextFormField> createState() => _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends State<AuthTextFormField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      obscureText: _isObscured,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.maxLines,
      cursorColor: fisrtHeaderTextColor,
      style: TextStyle(
        fontSize: widget.fontSize.toDouble(),
        overflow: TextOverflow.ellipsis,
        color: fisrtHeaderTextColor,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hintTextColor,
          fontSize: widget.fontSize.toDouble(),
          letterSpacing: 0,
          overflow: TextOverflow.ellipsis,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        focusedBorder: _buildBorder(fisrtHeaderTextColor),
        focusedErrorBorder: _buildBorder(widget.errorBorderColor),
        enabledBorder: _buildBorder(widget.primaryBorderColor),
        errorBorder: _buildBorder(widget.errorBorderColor),
        suffixIcon:
            widget.obscureText
                ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child:
                        _isObscured
                            ? Assets.images.hide.image(
                              height: 20.h,
                              width: 20.w,
                              color: widget.hintTextColor,
                            )
                            : Assets.images.view.image(
                              height: 20.h,
                              width: 20.w,
                              color: widget.hintTextColor,
                            ),
                  ),
                )
                : widget.suffixIcon,
        filled: true,
        fillColor: const Color(0xFF232323),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(17.r),
      borderSide: BorderSide(color: color),
    );
  }
}
