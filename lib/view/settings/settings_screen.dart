import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/controller/auth_controller.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    // Get user info from JSON (simulate login info)
    final firstName = authController.firstName;
    final lastName = authController.lastName;
    String initials = '';
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      initials = firstName[0].toUpperCase() + lastName[0].toUpperCase();
    } else if (firstName.isNotEmpty) {
      initials = firstName[0].toUpperCase();
    } else if (lastName.isNotEmpty) {
      initials = lastName[0].toUpperCase();
    } else {
      initials = '?';
    }
    String fullName = ('$firstName $lastName').trim();
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar with initials
                CircleAvatar(
                  radius: 36.w,
                  backgroundColor: const Color(0xFFEAEAEA),
                  child: Text(
                    initials,
                    style: TextStyle(
                      color: const Color(0xFF121212),
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                if (fullName.isNotEmpty)
                  CustomTextWidget(
                    text: fullName,
                    fontSize: 16.sp,
                    color: const Color(0xFFEAEAEA),
                    fontWeight: FontWeight.w600,
                  ),
                SizedBox(height: 32.h),
                CustomTextWidget(
                  text: 'Settings',
                  fontSize: 16.sp,
                  color: const Color(0xFFEAEAEA),
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'Log Out',
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Log Out'),
                            content: const Text(
                              'Are you sure you want to log out?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text('Log Out'),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) {
                      showDialog(
                        barrierDismissible: false,
                        builder:
                            (context) => Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(
                                    color: backgroundColor,
                                  ),
                                  SizedBox(height: 16.h),
                                  CustomTextWidget(
                                    text: 'Logging out...',
                                    fontSize: 16.sp,
                                    color: const Color(0xFFEAEAEA),
                                  ),
                                ],
                              ),
                            ),
                        // ignore: use_build_context_synchronously
                        context: context,
                      );

                      if (context.mounted) {
                        Navigator.of(context).pop(); // Dismiss loading dialog
                      }
                      await authController.logout();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
