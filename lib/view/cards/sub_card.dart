import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/subcard_animation.dart';

class SubCard extends StatelessWidget {
  const SubCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate available height for the card stack
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final availableHeight =
        screenHeight - topPadding - 120.h; // Subtract top bar and padding

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
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
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Assets.images.nigerianFlag.image(height: 25.h, width: 25.w),
                  CustomTextWidget(
                    text: ' Subcards',
                    fontSize: 18.sp,
                    color: Color(0xFFEAEAEA),
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              // Card stack with explicit height
              Expanded(
                child: CardStackAnimation(
                  height: availableHeight,
                  onCardSelected: (selected) {
                    if (selected) {
                      // Handle card selection here
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Card selected!')));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
