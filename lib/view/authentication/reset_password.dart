import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [AppBackButton()],
            ),
            SizedBox(height: 16.h),
            CustomTextWidget(
              text: 'Reset password',
              fontSize: 20.sp,
              color: fisrtHeaderTextColor,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
