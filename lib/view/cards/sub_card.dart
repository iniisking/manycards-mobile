import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/view/cards/create_subcard.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/navigation_controller.dart';

class SubCard extends StatefulWidget {
  const SubCard({super.key});

  @override
  State<SubCard> createState() => _SubCardState();
}

class _SubCardState extends State<SubCard> {
  NavigationController? _navigationController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigationController = context.read<NavigationController>();
  }

  @override
  void initState() {
    super.initState();
    // Hide bottom nav bar when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _navigationController?.hideBottomNavBar();
      }
    });
  }

  @override
  void dispose() {
    // Show bottom nav bar when screen is disposed
    _navigationController?.showBottomNavBar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  AppBackButton(),
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

              SizedBox(height: 80.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(name: 'subcard'),
                      builder: (context) => const CreateSubcard(),
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
        ),
      ),
    );
  }
}
