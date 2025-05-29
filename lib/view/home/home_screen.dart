import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/currency_bottom_sheet.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/shimmers.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/currency_controller.dart';
import '../../controller/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _handleRefresh(
    BuildContext context,
    CurrencyController controller,
  ) async {
    try {
      await controller.refreshBalances();
    } catch (e) {
      debugPrint('Refresh error: $e');
    }
  }

  void showCurrencyBottomSheet(
    BuildContext context,
    CurrencyController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (_) => CurrencyBottomSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CurrencyController>(context);
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LiquidPullToRefresh(
          onRefresh: () => _handleRefresh(context, controller),
          color: actionButtonColor,
          backgroundColor: fisrtHeaderTextColor,
          height: 70.h,
          animSpeedFactor: 3,
          showChildOpacityTransition: false,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 22.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: 'Welcome, ${authController.firstName}',
                        fontSize: 20.sp,
                        color: fisrtHeaderTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      Container(
                        height: 45.h,
                        width: 45.w,
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: actionButtonColor,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Assets.svg.notification.svg(),
                      ),
                    ],
                  ),
                  SizedBox(height: 36.h),
                  Row(
                    children: [
                      CustomTextWidget(
                        text: 'Your total account balance',
                        fontSize: 15.sp,
                        color: fisrtHeaderTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          controller.toggleBalanceVisibility();
                        },
                        child: Icon(
                          controller.isBalanceVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20.sp,
                          color: fisrtHeaderTextColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      controller.selectedCurrency.flag,
                      SizedBox(width: 8.w),
                      CustomTextWidget(
                        text: controller.selectedCurrency.code,
                        fontSize: 16.sp,
                        color: fisrtHeaderTextColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () => showCurrencyBottomSheet(context, controller),
                    child: Row(
                      children: [
                        controller.isLoading || controller.isRefreshing
                            ? Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[700]!,
                              child: Container(
                                width: 200.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                controller.isBalanceVisible
                                    ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextWidget(
                                          text:
                                              '${controller.selectedCurrency.symbol}${controller.totalBalance.toStringAsFixed(2)}',
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.bold,
                                          color: fisrtHeaderTextColor,
                                        ),
                                      ],
                                    )
                                    : CustomTextWidget(
                                      text: '* * * * * *',
                                      fontSize: 40.sp,
                                      fontWeight: FontWeight.bold,
                                      color: fisrtHeaderTextColor,
                                    ),
                              ],
                            ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 25.sp,
                          color: fisrtHeaderTextColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Top Up
                      QuickActionButton(
                        onTap: () {
                          // your tap logic here
                        },
                        icon: Padding(
                          padding: EdgeInsets.all(5.sp),
                          child: Assets.images.plus.image(
                            color: actionButtonIconColor,
                          ),
                        ),
                        label: 'Top Up',
                      ),

                      //Transfer
                      QuickActionButton(
                        onTap: () {
                          // your tap logic here
                        },
                        icon: Padding(
                          padding: EdgeInsets.all(2.sp),
                          child: Assets.images.transfer.image(
                            color: actionButtonIconColor,
                          ),
                        ),
                        label: 'Transfer',
                      ),

                      //create card
                      QuickActionButton(
                        onTap: () {
                          // your tap logic here
                        },
                        icon: Padding(
                          padding: EdgeInsets.all(1.sp),
                          child: Assets.images.createCard.image(
                            color: actionButtonIconColor,
                          ),
                        ),
                        label: 'Create Card',
                      ),

                      //withdraw
                      QuickActionButton(
                        onTap: () {},
                        icon: Assets.images.withdraw.image(
                          color: actionButtonIconColor,
                        ),

                        label: 'Withdraw',
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  // Transaction History
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: 'Recent Transactions',
                        fontSize: 18.sp,
                        color: fisrtHeaderTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: CustomTextWidget(
                          text: 'See all',
                          fontSize: 14.sp,
                          color: secondHeadTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return TransactionRowShimmer();
                    },
                  ),

                  // TransactionRowWidget(
                  //   leadingIcon: Icon(
                  //     Icons.attach_money,
                  //     color: fisrtHeaderTextColor,
                  //     size: 20.sp,
                  //   ),
                  //   title: 'Card Funding',
                  //   subtitle: 'Feb 3 at 5:17 PM',
                  //   description: 'You funded your USD Card',
                  //   amount:
                  //       controller.isBalanceVisible
                  //           ? '+\$500.00'
                  //           : '* * * * * *',
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 8.h),
                  //   child: Divider(thickness: 1.h, color: actionButtonColor),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
