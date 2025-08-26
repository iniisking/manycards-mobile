// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/authentication/login_screen.dart';
import 'package:manycards/view/authentication/verify_email.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/textfield.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isFormValid = false;
  bool _termsAccepted = false;
  bool _isLoading = false;

  // form validation logic
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    final trimmedValue = value.trim();
    final nameParts = trimmedValue.split(' ');

    if (nameParts.length != 2) {
      return 'Please enter your first and last name';
    }

    final nameRegExp = RegExp(r"^[A-Za-zÀ-ÿ ,.'-]+$");
    if (!nameRegExp.hasMatch(nameParts[0]) ||
        !nameRegExp.hasMatch(nameParts[1])) {
      return 'Name can only contain letters, spaces, hyphens, or apostrophes';
    }

    if (nameParts[0].length < 2 || nameParts[1].length < 2) {
      return 'First and last name must be at least 2 characters long';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    // Check minimum length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    // Check for uppercase letters
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for lowercase letters
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for numbers
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    // Check for symbols
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one symbol';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to all controllers
    fullNameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        validateFullName(fullNameController.text) == null &&
        validateEmail(emailController.text) == null &&
        validatePassword(passwordController.text) == null &&
        _termsAccepted;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    CustomTextWidget(
                      text: 'Sign Up',
                      fontSize: 24.sp,
                      color: fisrtHeaderTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextWidget(
                      text: 'Enter your personal details to create an account',
                      fontSize: 14.sp,
                      color: secondHeadTextColor,
                      fontWeight: FontWeight.normal,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Full name field
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: CustomTextWidget(
                          text: 'Full Name',
                          fontSize: 14.sp,
                          color: fisrtHeaderTextColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AuthTextFormField(
                        hintText: 'Enter your first and last name',
                        controller: fullNameController,
                        primaryBorderColor: Colors.transparent,
                        errorBorderColor: Colors.red,
                        validator: validateFullName,
                      ),
                      SizedBox(height: 12.sp),

                      //Email field
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: CustomTextWidget(
                          text: 'Email',
                          fontSize: 14.sp,
                          color: fisrtHeaderTextColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AuthTextFormField(
                        hintText: 'Enter your email address',
                        controller: emailController,
                        primaryBorderColor: Colors.transparent,
                        errorBorderColor: Colors.red,
                        validator: validateEmail,
                      ),
                      SizedBox(height: 12.sp),

                      //Password field
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: CustomTextWidget(
                          text: 'Password',
                          fontSize: 14.sp,
                          color: fisrtHeaderTextColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AuthTextFormField(
                        hintText: 'Enter a strong pasword',
                        controller: passwordController,
                        primaryBorderColor: Colors.transparent,
                        errorBorderColor: Colors.red,

                        obscureText: true,
                        validator: validatePassword,
                      ),

                      SizedBox(height: 8.sp),

                      //Terms and conditions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (value) {
                              setState(() {
                                _termsAccepted = value ?? false;
                                _validateForm();
                              });
                            },
                            activeColor: fisrtHeaderTextColor,
                            checkColor: buttonTextColor,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          CustomTextWidget(
                            text: 'I accept the ',
                            fontSize: 12.sp,
                            color: secondHeadTextColor,
                            fontWeight: FontWeight.normal,
                          ),
                          CustomTextWidget(
                            text: 'Terms and Conditions',
                            fontSize: 12.sp,
                            color: fisrtHeaderTextColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      CustomButton(
                        text: 'Sign Up',
                        isEnabled: _isFormValid,
                        isLoading: _isLoading,
                        loadingText: 'Signing Up...',
                        onTap: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              debugPrint('Starting sign-up process in UI...');
                              final success = await authController.signUp(
                                fullNameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text,
                              );

                              debugPrint('Sign-up result in UI: $success');
                              if (success && mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const VerifyEmailScreen(),
                                  ),
                                );
                              } else if (mounted) {
                                debugPrint(
                                  'Sign-up failed in UI: ${authController.error}',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authController.error ?? 'Sign up failed',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint('Sign-up error in UI: $e');
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'An error occurred: ${e.toString()}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12.h),

                      // Divider with "or" text
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: const Color(0xFF3A3A3A),
                              thickness: 1.5,
                              height: 1.h,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: CustomTextWidget(
                              text: 'or',
                              fontSize: 14.sp,
                              color: secondHeadTextColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: const Color(0xFF3A3A3A),
                              thickness: 1.5,
                              height: 1.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              // already have an account? Log in
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextWidget(
                    text: 'Already have an account? ',
                    fontSize: 15.sp,
                    color: secondHeadTextColor,
                    fontWeight: FontWeight.normal,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: CustomTextWidget(
                      text: 'Sign In',
                      fontSize: 15.sp,
                      color: fisrtHeaderTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Remove all listeners
    fullNameController.removeListener(_validateForm);
    emailController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);

    // Dispose controllers
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
