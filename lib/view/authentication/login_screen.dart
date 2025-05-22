// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/authentication/reset_password.dart';
import 'package:manycards/view/authentication/sign_up_screen.dart';
import 'package:manycards/view/bottom%20nav%20bar/main_screen.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/textfield.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isFormValid = false;
  @override
  void initState() {
    super.initState();
    // Add listeners to track form changes
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        validateLoginEmail(emailController.text) == null &&
        validateLoginPassword(passwordController.text) == null;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  //email validation
  String? validateLoginEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  //password validation
  String? validateLoginPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  @override
  void dispose() {
    // Remove listeners
    emailController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);

    // Dispose controllers
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    CustomTextWidget(
                      text: 'Welcome Back',
                      fontSize: 24.sp,
                      color: fisrtHeaderTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextWidget(
                      text: 'Sign in to continue to your ManySubs account',
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
                      // Email field
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
                        validator: validateLoginEmail,
                      ),
                      SizedBox(height: 12.h),

                      // Password field
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
                        hintText: 'Enter your password',
                        controller: passwordController,
                        primaryBorderColor: Colors.transparent,
                        errorBorderColor: Colors.red,
                        obscureText: true,
                        validator: validateLoginPassword,
                      ),
                      SizedBox(height: 12.h),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Handle forgot password
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResetPassword(),
                              ),
                            );
                          },
                          child: CustomTextWidget(
                            text: 'Forgot Password?',
                            fontSize: 14.sp,
                            color: fisrtHeaderTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Log In button
                      CustomButton(
                        text: 'Log In',
                        onTap: () async {
                          try {
                            final success = await authController.signIn(
                              emailController.text.trim(), // Trim spaces
                              passwordController.text,
                            );

                            if (success && mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                              );
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Login failed')),
                                );
                              }
                            }
                          } catch (e) {
                            debugPrint(
                              "Sign in error: $e",
                            ); // Print the full error message
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                ),
                              );
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

                      // Google sign-in button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: GoogleSignInButton(
                          onPressed: () async {
                            await authController.signInWithGoogle(context);
                          },
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // Don't have an account? Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextWidget(
                            text: 'Don\'t have an account? ',
                            fontSize: 15.sp,
                            color: secondHeadTextColor,
                            fontWeight: FontWeight.normal,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: CustomTextWidget(
                              text: 'Sign Up',
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
            ],
          ),
        ),
      ),
    );
  }
}
