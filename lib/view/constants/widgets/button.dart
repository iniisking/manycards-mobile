import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';

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
