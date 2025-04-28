import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/view/constants/widgets/colors.dart';

class QuickActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String label;

  const QuickActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(14.sp),
            height: 62.h,
            width: 62.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(40.r),
            ),
            child: icon,
          ),
          SizedBox(height: 6.h),
          CustomTextWidget(
            text: label,
            fontSize: 12.sp,
            color: const Color(0xFFC4C4C4),
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

//general custom button
class CustomButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onTap;
  final Color color;

  final double borderRadius;
  final Color textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = const Color(0xFFEAEAEA),

    this.borderRadius = 15,
    this.textColor = const Color(0xFF121212),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        alignment: Alignment.center,
        child: CustomTextWidget(
          text: text,

          color: textColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF232323),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF3A3A3A), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Assets.svg.google.svg(height: 16.h, width: 16.w),
            ),
            SizedBox(width: 12.w),
            CustomTextWidget(
              text: 'Continue with Google',
              fontSize: 12.sp,
              color: fisrtHeaderTextColor,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}

//App Back button
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 32.h,
        width: 48.w,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Center(child: Assets.svg.backArrow.svg()),
      ),
    );
  }
}
