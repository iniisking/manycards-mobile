// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/utils/number_formatter.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/currency_controller.dart';

class CurrencyRowWidget extends StatelessWidget {
  final Map<String, dynamic> currency;
  final String selectedCurrencyCode;
  final Function(String) onCurrencySelected;
  final dynamic isRefreshing;
  final dynamic isInitialLoading;

  const CurrencyRowWidget({
    super.key,
    required this.currency,
    required this.selectedCurrencyCode,
    required this.onCurrencySelected,
    required this.isRefreshing,
    this.isInitialLoading = false,
  });

  String _formatBalance(double balance, String symbol) {
    return NumberFormatter.formatBalanceWithSymbol(balance, symbol);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = isRefreshing && !isInitialLoading;
    final controller = Provider.of<CurrencyController>(context);

    return InkWell(
      onTap: () {
        onCurrencySelected(currency['code'] as String);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Currency logo and label
            Row(
              children: [
                // Currency flag
                currency['flag'] as Widget,
                SizedBox(width: 8.w),
                // Currency details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      text: currency['code'] as String,
                      fontSize: 16.sp,
                      color: const Color(0xFFEAEAEA),
                      fontWeight: FontWeight.w500,
                    ),
                    CustomTextWidget(
                      text: currency['name'] as String,
                      fontSize: 12.sp,
                      color: const Color(0xFF949494),
                    ),
                  ],
                ),
              ],
            ),

            // Amount and radio button
            Row(
              children: [
                isLoading
                    ? Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(
                        width: 80.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    )
                    : CustomTextWidget(
                      text:
                          controller.isBalanceVisible
                              ? _formatBalance(
                                controller.getBalanceForCurrency(
                                  currency['code'] as String,
                                ),
                                currency['symbol'] as String,
                              )
                              : '* * * * * *',
                      fontSize: 16.sp,
                      color: const Color(0xFFEAEAEA),
                      fontWeight: FontWeight.w500,
                    ),
                Radio<String>(
                  value: currency['code'] as String,
                  groupValue: selectedCurrencyCode,
                  onChanged: (value) {
                    if (value != null) {
                      onCurrencySelected(value);
                      Navigator.pop(context);
                    }
                  },
                  activeColor: Colors.green,
                  fillColor: MaterialStateProperty.resolveWith<Color>((
                    Set<MaterialState> states,
                  ) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.green;
                    }
                    return Colors.grey;
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
