// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:manycards/view/bottom%20nav%20bar/main_screen.dart';
// import 'package:manycards/view/constants/text/text.dart';
// import 'package:manycards/view/constants/widgets/button.dart';
// import 'package:manycards/view/constants/widgets/colors.dart';
// import 'package:manycards/gen/assets.gen.dart';

// class ConfirmEmail extends StatefulWidget {
//   const ConfirmEmail({super.key});

//   @override
//   State<ConfirmEmail> createState() => _ConfirmResetState();
// }

// class _ConfirmResetState extends State<ConfirmEmail>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );

//     _scaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
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
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.start,
//                     //   children: const [AppBackButton()],
//                     // ),
//                     SizedBox(height: 40.h),
//                     FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: ScaleTransition(
//                         scale: _scaleAnimation,
//                         child: Container(
//                           height: 120.h,
//                           width: 120.w,
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF2C2C2C),
//                             borderRadius: BorderRadius.circular(60.r),
//                           ),
//                           child: Center(
//                             child: Assets.images.more.image(
//                               height: 40.h,
//                               width: 40.w,
//                               color: fisrtHeaderTextColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 24.h),
//                     FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: CustomTextWidget(
//                         text: 'Check Your Email',
//                         fontSize: 24.sp,
//                         color: fisrtHeaderTextColor,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     FadeTransition(
//                       opacity: _fadeAnimation,
//                       child: CustomTextWidget(
//                         text:
//                             'We\'ve sent a link to your email. Please check your inbox and click the link to verify your email.',
//                         fontSize: 14.sp,
//                         color: secondHeadTextColor,
//                         fontWeight: FontWeight.normal,
//                         maxLines: 3,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 40.h),

//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16.w),
//                 child: FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: CustomButton(
//                     text: 'Continue',
//                     onTap: () async {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const MainScreen(),
//                         ),
//                       );
//                     },
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
