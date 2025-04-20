import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class TransactionRowShimmer extends StatelessWidget {
  const TransactionRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2C2C2C),
      highlightColor: const Color(0xFF3A3A3A),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Icon Placeholder
            Container(
              height: 45.h,
              width: 45.w,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(40.r),
              ),
            ),
            SizedBox(width: 10.w),
            // Text Column Placeholder
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14.h, width: 120.w, color: Colors.grey),
                  SizedBox(height: 4.h),
                  Container(height: 12.h, width: 90.w, color: Colors.grey),
                  SizedBox(height: 4.h),
                  Container(height: 16.h, width: 160.w, color: Colors.grey),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            // Amount Placeholder
            Container(height: 14.h, width: 60.w, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
