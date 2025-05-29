import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:manycards/view/constants/widgets/cards.dart';

class SwiperBuilder extends StatelessWidget {
  const SwiperBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Swiper(
              itemWidth: 400,
              itemHeight: 240,
              loop: true,
              duration: 1800,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return imagepath[index];
              },
              itemCount: imagepath.length,
              layout: SwiperLayout.STACK,
            ),
          ),
        ),
      ),
    );
  }
}

List imagepath = [
  CurrencyCard(cardColor: Colors.orange, balance: 1000.0, currencySymbol: '\$'),
  CurrencyCard(cardColor: Colors.green, balance: 500.0, currencySymbol: '£'),
  CurrencyCard(cardColor: Colors.black, balance: 50000.0, currencySymbol: '₦'),
  CurrencyCard(cardColor: Colors.red, balance: 2000.0, currencySymbol: '\$'),
  CurrencyCard(cardColor: Colors.purple, balance: 1000.0, currencySymbol: '£'),
];
