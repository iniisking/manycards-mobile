import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/authentication/login_screen.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/textfield.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    bool _termsAccepted = false;
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
                      text: 'Sign Up',
                      fontSize: 24.sp,
                      color: fisrtHeaderTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextWidget(
                      text:
                          'Enter your personal details to create a ManySubs account',
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
                      //First name field
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: CustomTextWidget(
                          text: 'First Name',
                          fontSize: 14.sp,
                          color: fisrtHeaderTextColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AuthTextFormField(
                        hintText: 'Enter your first name',
                        controller: controller,
                        primaryBorderColor: Colors.transparent,
                        errorBorderColor: Colors.red,
                      ),
                      SizedBox(height: 12.sp),

                      //Last name field
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: CustomTextWidget(
                          text: 'Last Name',
                          fontSize: 14.sp,
                          color: fisrtHeaderTextColor,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      AuthTextFormField(
                        hintText: 'Enter your last name',
                        controller: controller,
                        primaryBorderColor: Colors.transparent,
                        errorBorderColor: Colors.red,
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
                        controller: controller,
                        primaryBorderColor: Colors.transparent,
                        errorBorderColor: Colors.red,
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
                        controller: controller,
                        primaryBorderColor: Colors.transparent,
                        errorBorderColor: Colors.red,
                      ),

                      SizedBox(height: 8.sp),

                      //Terms and conditions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _termsAccepted,
                            onChanged: (value) {},
                            // value: _termsAccepted,
                            // onChanged: (value) {
                            //   setState(() {
                            //     _termsAccepted = value ?? false;
                            //     _validateForm();
                            //   });
                            // },
                            activeColor: fisrtHeaderTextColor,
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
                      CustomButton(text: 'Sign Up', onTap: () async {}),
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
                      fontWeight: FontWeight.normal,
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
}
