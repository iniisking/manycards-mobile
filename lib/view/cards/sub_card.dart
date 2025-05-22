import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/view/cards/create_subcard.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:page_transition/page_transition.dart';

class SubCard extends StatelessWidget {
  const SubCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Calculate available height for the card stack
    // final screenHeight = MediaQuery.of(context).size.height;
    // final topPadding = MediaQuery.of(context).padding.top;
    // final availableHeight =
    //     screenHeight - topPadding - 120.h; // Subtract top bar and padding

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),

          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBackButton(), // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Assets.images.nigerianFlag.image(
                        height: 25.h,
                        width: 25.w,
                      ),
                      CustomTextWidget(
                        text: ' Subcards',
                        fontSize: 18.sp,
                        color: fisrtHeaderTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              SizedBox(height: 100.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      isIos: Platform.isIOS,
                      type: PageTransitionType.bottomToTop,
                      duration: const Duration(milliseconds: 400),

                      child: const CreateSubcard(),
                    ),
                  );
                },
                child: DottedBorder(
                  color: actionButtonColor,
                  strokeWidth: 2,
                  dashPattern: const [8, 4],
                  radius: Radius.circular(20.r),
                  borderType: BorderType.RRect,
                  child: SizedBox(
                    height: 186.h,
                    width: 327.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextWidget(
                          text: 'No Subcards',
                          fontSize: 18.sp,
                          color: const Color(0xFF606060),
                          fontWeight: FontWeight.w500,
                        ),
                        SizedBox(height: 10.h),
                        CustomTextWidget(
                          text: 'Create a subcard to get started',
                          fontSize: 14.sp,
                          color: const Color(0xFF606060),
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(height: 10.h),
                        Assets.images.plus.image(
                          height: 30.h,
                          width: 30.w,
                          color: const Color(0xFF606060),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     // Back button
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         GestureDetector(
          //           onTap: () {
          //             Navigator.pop(context);
          //           },
          //           child: Container(
          //             height: 32.h,
          //             width: 48.w,
          //             decoration: BoxDecoration(
          //               color: const Color(0xFF2C2C2C),
          //               borderRadius: BorderRadius.circular(50.r),
          //             ),
          //             child: Center(child: Assets.svg.backArrow.svg()),
          //           ),
          //         ),
          //       ],
          //     ),
          //     SizedBox(height: 30.h),

          //     // Title
          //     Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Assets.images.nigerianFlag.image(height: 25.h, width: 25.w),
          //         CustomTextWidget(
          //           text: ' Subcards',
          //           fontSize: 18.sp,
          //           color: Color(0xFFEAEAEA),
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ],
          //     ),

          //     SizedBox(height: 30.h),
          //     SwiperBuilder(),

          //     // Card stack with explicit height

          //     // Expanded(
          //     //   child: CardStackAnimation(
          //     //     height: availableHeight,
          //     //     onCardSelected: (selected) {
          //     //       if (selected) {
          //     //         // Handle card selection here
          //     //         ScaffoldMessenger.of(
          //     //           context,
          //     //         ).showSnackBar(SnackBar(content: Text('Card selected!')));
          //     //       }
          //     //     },
          //     //   ),
          //     // ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
