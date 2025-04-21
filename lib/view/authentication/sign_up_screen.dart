import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: CustomTextWidget(
                text: 'Sign Up',
                fontSize: 18.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
