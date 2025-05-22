import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';

class CurrencyCard extends StatelessWidget {
  final String cardNumber;
  final String cardholderName;
  final String expiryDate;
  final String cardBalance;
  final String balanceAmount;
  final Widget? chipWidget;
  final Widget? cardTypeWidget;
  final Color backgroundColor;
  final Color textColor;

  const CurrencyCard({
    super.key,
    this.cardNumber = '**** **** **** 1234',
    this.cardholderName = 'IniOluwa Longe',
    this.expiryDate = '08/27',
    this.cardBalance = 'Card Balance',
    this.balanceAmount = '₦801,521.91',
    this.chipWidget,
    this.cardTypeWidget,
    this.backgroundColor = const Color(0xFF009933),
    this.textColor = const Color(0xFFFFFFFF),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 186,
      // width: 327,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              chipWidget ?? _defaultChipWidget(),
              SizedBox(width: 10.w),
              cardTypeWidget ?? _defaultCardTypeWidget(),
            ],
          ),
          SizedBox(height: 15.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                text: cardBalance,
                fontSize: 12.sp,
                color: textColor.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: 4.h),
              CustomTextWidget(
                text: balanceAmount,
                fontSize: 30,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomTextWidget(
                text: cardNumber,
                fontSize: 18, // Reduced from 24 to 18
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Reduced from 50 to 40 to accommodate the balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                text: cardholderName,
                fontSize: 15,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              CustomTextWidget(
                text: expiryDate,
                fontSize: 15,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _defaultChipWidget() {
    // A placeholder for the card chip
    return Container(
      width: 40,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _defaultCardTypeWidget() {
    // A placeholder for the card type (visa, mastercard, etc.)
    return Container(
      width: 50,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'VISA',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
