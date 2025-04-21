import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manycards/gen/assets.gen.dart';

class CurrencyModel {
  final String code;
  final String name;
  final String locale;
  final String symbol;
  final Widget flag;
  double balance = 0.0;
  String formattedBalance = '';

  CurrencyModel({
    required this.code,
    required this.name,
    required this.locale,
    required this.symbol,
    required this.flag,
  });

  void formatBalance() {
    formattedBalance = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
    ).format(balance);
  }

  static List<CurrencyModel> getAvailableCurrencies() {
    return [
      CurrencyModel(
        code: 'NGN',
        name: 'Nigerian Naira',
        locale: 'en_NG',
        symbol: '₦',
        flag: Assets.images.nigerianFlag.image(height: 25, width: 25),
      ),
      CurrencyModel(
        code: 'USD',
        name: 'United States Dollar',
        locale: 'en_US',
        symbol: '\$',
        flag: Assets.images.usFlag.image(height: 25, width: 25),
      ),

      CurrencyModel(
        code: 'GBP',
        name: 'Great British Pound',
        locale: 'en_GB',
        symbol: '£',
        flag: Assets.images.ukFlag.image(height: 25, width: 25),
      ),
    ];
  }
}
