import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: CustomTextWidget(
                text: 'Log In',
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
