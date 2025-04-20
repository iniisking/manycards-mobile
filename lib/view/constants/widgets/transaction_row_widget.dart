import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';

class TransactionRowWidget extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final String subtitle;
  final String description;
  final String amount;

  const TransactionRowWidget({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 45.h,
          width: 45.w,
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Center(child: leadingIcon),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                text: title,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFEAEAEA),
              ),
              SizedBox(height: 4.h),
              CustomTextWidget(
                text: subtitle,
                fontSize: 12.sp,
                color: const Color(0xFF949494),
              ),
              SizedBox(height: 4.h),
              CustomTextWidget(
                text: description,
                fontSize: 16.sp,
                color: const Color(0xFFEAEAEA),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        CustomTextWidget(
          text: amount,
          fontSize: 14.sp,
          color: const Color(0xFFEAEAEA),
        ),
      ],
    );
  }
}
