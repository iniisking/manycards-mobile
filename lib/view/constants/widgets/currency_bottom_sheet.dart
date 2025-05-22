import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/controller/currency_controller.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:shimmer/shimmer.dart';
import 'currency_row_widget.dart';

class CurrencyBottomSheet extends StatefulWidget {
  final CurrencyController controller;

  const CurrencyBottomSheet({super.key, required this.controller});

  @override
  State<CurrencyBottomSheet> createState() => _CurrencyBottomSheetState();
}

class _CurrencyBottomSheetState extends State<CurrencyBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        return SizedBox(
          height: 360.h,
          child: Column(
            children: [
              const SizedBox(height: 15),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 8.h),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: 'View your balance in:',
                            fontSize: 16.sp,
                            color: Color(0xFFEAEAEA),
                            fontWeight: FontWeight.bold,
                          ),
                          // Add toggle button in the bottom sheet header too
                          GestureDetector(
                            onTap: () {
                              widget.controller.toggleBalanceVisibility();
                            },
                            child: Icon(
                              widget.controller.isBalanceVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: const Color(0xFFEAEAEA),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      widget.controller.isLoading ||
                              widget.controller.isRefreshing
                          ? Expanded(
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[800]!,
                                    highlightColor: Colors.grey[700]!,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 25.w,
                                          height: 25.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 40.w,
                                              height: 16.h,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 4.h),
                                            Container(
                                              width: 100.w,
                                              height: 12.h,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 80.w,
                                          height: 16.h,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.w),
                                        Container(
                                          width: 20.w,
                                          height: 20.h,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          : Expanded(
                            child: ListView(
                              children:
                                  widget.controller.currencies
                                      .map(
                                        (currency) => CurrencyRowWidget(
                                          currency: currency,
                                          selectedCurrencyCode:
                                              widget
                                                  .controller
                                                  .selectedCurrencyCode,
                                          onCurrencySelected:
                                              widget
                                                  .controller
                                                  .setSelectedCurrency,
                                          isRefreshing:
                                              widget.controller.isRefreshing,
                                          isInitialLoading:
                                              widget.controller.isLoading,
                                        ),
                                      )
                                      .toList(),
                            ),
                          ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
