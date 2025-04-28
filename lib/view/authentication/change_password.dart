// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:manycards/view/constants/text/text.dart';
// import 'package:manycards/view/constants/widgets/button.dart';
// import 'package:manycards/view/constants/widgets/colors.dart';
// import 'package:manycards/view/constants/widgets/textfield.dart';
// import 'package:provider/provider.dart';
// import 'package:manycards/controller/auth_controller.dart';

// class ChangePassword extends StatefulWidget {
//   const ChangePassword({super.key});

//   @override
//   State<ChangePassword> createState() => _ChangePasswordState();
// }

// class _ChangePasswordState extends State<ChangePassword> {
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//       TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool _isFormValid = false;

//   String? validatePassword(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Please enter a password';
//     }

//     if (value.length < 6) {
//       return 'Password must be at least 6 characters long';
//     }

//     if (!RegExp(r'[A-Z]').hasMatch(value)) {
//       return 'Password must contain at least one uppercase letter';
//     }

//     if (!RegExp(r'[a-z]').hasMatch(value)) {
//       return 'Password must contain at least one lowercase letter';
//     }

//     if (!RegExp(r'[0-9]').hasMatch(value)) {
//       return 'Password must contain at least one number';
//     }

//     if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
//       return 'Password must contain at least one symbol';
//     }

//     return null;
//   }

//   String? validateConfirmPassword(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Please confirm your password';
//     }

//     if (value != newPasswordController.text) {
//       return 'Passwords do not match';
//     }

//     return null;
//   }

//   @override
//   void initState() {
//     super.initState();
//     newPasswordController.addListener(_validateForm);
//     confirmPasswordController.addListener(_validateForm);
//   }

//   void _validateForm() {
//     final isValid =
//         validatePassword(newPasswordController.text) == null &&
//         validateConfirmPassword(confirmPasswordController.text) == null;

//     if (_isFormValid != isValid) {
//       setState(() {
//         _isFormValid = isValid;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     newPasswordController.removeListener(_validateForm);
//     confirmPasswordController.removeListener(_validateForm);
//     newPasswordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authController = Provider.of<AuthController>(context);

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 24.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: const [AppBackButton()],
//                     ),
//                     SizedBox(height: 16.h),
//                     CustomTextWidget(
//                       text: 'Change Password',
//                       fontSize: 24.sp,
//                       color: fisrtHeaderTextColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     SizedBox(height: 8.h),
//                     CustomTextWidget(
//                       text: 'Create a new password for your account',
//                       fontSize: 14.sp,
//                       color: secondHeadTextColor,
//                       fontWeight: FontWeight.normal,
//                       maxLines: 2,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 24.h),

//               Form(
//                 key: _formKey,
//                 autovalidateMode: AutovalidateMode.onUnfocus,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // New Password field
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8.w),
//                         child: CustomTextWidget(
//                           text: 'New Password',
//                           fontSize: 14.sp,
//                           color: fisrtHeaderTextColor,
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       AuthTextFormField(
//                         hintText: 'Enter your new password',
//                         controller: newPasswordController,
//                         primaryBorderColor: Colors.transparent,
//                         errorBorderColor: Colors.red,
//                         obscureText: true,
//                         validator: validatePassword,
//                       ),
//                       SizedBox(height: 12.h),

//                       // Confirm Password field
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 8.w),
//                         child: CustomTextWidget(
//                           text: 'Confirm Password',
//                           fontSize: 14.sp,
//                           color: fisrtHeaderTextColor,
//                           fontWeight: FontWeight.normal,
//                         ),
//                       ),
//                       SizedBox(height: 4.h),
//                       AuthTextFormField(
//                         hintText: 'Confirm your new password',
//                         controller: confirmPasswordController,
//                         primaryBorderColor: Colors.transparent,
//                         errorBorderColor: Colors.red,
//                         obscureText: true,
//                         validator: validateConfirmPassword,
//                       ),
//                       SizedBox(height: 24.h),

//                       // Change Password button
//                       CustomButton(
//                         text: 'Change Password',
//                         onTap: () async {
//                           if (_formKey.currentState?.validate() ?? false) {
//                             final success = await authController.updatePassword(
//                               newPasswordController.text,
//                             );

//                             if (success && mounted) {
//                               Navigator.popUntil(
//                                 context,
//                                 (route) => route.isFirst,
//                               );
//                             } else if (mounted) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(authController.error),
//                                   backgroundColor: Colors.red,
//                                 ),
//                               );
//                             }
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
