import 'package:flutter/material.dart';

class CardInfo {
  final String cardholderName;
  final String balanceAmount;
  final Color backgroundColor;
  double positionY = 0;
  double rotate = 0;
  double scale = 0;
  double opacity = 0;

  CardInfo({
    required this.cardholderName,
    required this.balanceAmount,
    required this.backgroundColor,
    this.positionY = 0,
    this.rotate = 0,
    this.scale = 0,
    this.opacity = 0,
  });
}
