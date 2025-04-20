import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/currency_dropdown.dart';
import 'package:manycards/view/constants/widgets/shimmers.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    String selectedCurrency = 'USD';
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextWidget(
                    text: 'Transaction History',
                    fontSize: 18.sp,
                    color: Color(0xFFEAEAEA),
                    fontWeight: FontWeight.bold,
                  ),
                  CurrencyDropdown(
                    initialValue: selectedCurrency,
                    onCurrencyChanged: (value) {
                      // setState(() {
                      //   selectedCurrency = value;
                      // });
                    },
                    backgroundColor: Color(0xFF232323),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              TransactionRowShimmer(),
              TransactionRowShimmer(),
              TransactionRowShimmer(),
              TransactionRowShimmer(),
              TransactionRowShimmer(),
              TransactionRowShimmer(),
              TransactionRowShimmer(),
              TransactionRowShimmer(),
              TransactionRowShimmer(),
            ],
          ),
        ),
      ),
    );
  }
}
