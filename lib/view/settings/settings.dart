import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: CustomTextWidget(
          text: 'Settings',
          fontSize: 16.sp,
          color: const Color(0xFFEAEAEA),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
