import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/utils/number_formatter.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:flutter/services.dart';

class CurrencyCard extends StatelessWidget {
  final String cardNumber;
  final String cardholderName;
  final String expiryDate;
  final String cardBalance;
  final double balance;
  final String currencySymbol;
  final Widget? chipWidget;
  final Widget? cardTypeWidget;
  final Color cardColor;
  final Color textColor;
  final bool isBackVisible;
  final String? cvv;
  final String? fullCardNumber;

  const CurrencyCard({
    super.key,
    this.cardNumber = '**** **** **** 1234',
    this.cardholderName = 'IniOluwa Longe',
    this.expiryDate = '08/27',
    this.cardBalance = 'Card Balance',
    this.balance = 0.0,
    this.currencySymbol = '₦',
    this.chipWidget,
    this.cardTypeWidget,
    this.cardColor = const Color(0xFF1E1E1E),
    this.textColor = const Color(0xFFFFFFFF),
    this.isBackVisible = false,
    this.cvv,
    this.fullCardNumber,
  });

  String get formattedBalance {
    return NumberFormatter.formatBalanceWithSymbol(balance, currencySymbol);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        final rotate = Tween(begin: 0.0, end: 1.0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final isUnder = (ValueKey(isBackVisible) != child?.key);
            final value = isUnder ? (1 - rotate.value) : rotate.value;
            return Transform(
              transform: Matrix4.rotationY(value * 3.1416),
              alignment: Alignment.center,
              child: child,
            );
          },
        );
      },
      child: isBackVisible
          ? _buildBack(context)
          : _buildFront(context),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
    );
  }

  Widget _buildFront(BuildContext context) {
    return Container(
      key: const ValueKey('front'),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: cardColor,
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
                text: formattedBalance,
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
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          const SizedBox(height: 10),
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

  Widget _buildBack(BuildContext context) {
    return Container(
      key: const ValueKey('back'),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Container(
            height: 40.h,
            color: Colors.black.withOpacity(0.7),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      text: 'Card Number',
                      fontSize: 12.sp,
                      color: textColor.withOpacity(0.7),
                    ),
                    SizedBox(height: 4.h),
                    CustomTextWidget(
                      text: fullCardNumber ?? cardNumber,
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                color: textColor,
                tooltip: 'Copy Card Number',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: fullCardNumber ?? cardNumber));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Card number copied!')),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: 'Expiry',
                          fontSize: 12.sp,
                          color: textColor.withOpacity(0.7),
                        ),
                        SizedBox(height: 4.h),
                        CustomTextWidget(
                          text: expiryDate,
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      color: textColor,
                      tooltip: 'Copy Expiry',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: expiryDate));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Expiry date copied!')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          text: 'CVV',
                          fontSize: 12.sp,
                          color: textColor.withOpacity(0.7),
                        ),
                        SizedBox(height: 4.h),
                        CustomTextWidget(
                          text: cvv ?? '***',
                          fontSize: 15,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 16),
                      color: textColor,
                      tooltip: 'Copy CVV',
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: cvv ?? ''));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('CVV copied!')),
                        );
                      },
                    ),
                  ],
                ),
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
