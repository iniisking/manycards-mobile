import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/authentication/reset_password.dart';
import 'package:manycards/view/authentication/sign_up_screen.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

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
                          // Handle login
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
                          onPressed: () {
                            // Handle Google sign-in
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
                              fontWeight: FontWeight.normal,
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
