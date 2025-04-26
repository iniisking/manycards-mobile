// ignore_for_file: non_constant_identifier_names

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:manycards/model/card_info.dart';
import 'package:manycards/view/constants/widgets/cards.dart';

class CardStackAnimation extends StatefulWidget {
  final double height;
  final Function(bool)? onCardSelected;

  const CardStackAnimation({
    super.key,
    required this.height,
    this.onCardSelected,
  });

  @override
  State<CardStackAnimation> createState() => _CardStackAnimationState();
}

class _CardStackAnimationState extends State<CardStackAnimation> {
  late double positionY_line1;
  late double positionY_line2;
  late List<CardInfo> _cardInfoList;
  late double _middleAreaHeight;
  late double _outsiteCardInterval;
  late double scrollOffsetY;

  @override
  void initState() {
    super.initState();
    positionY_line1 = widget.height * 0.1;
    positionY_line2 = positionY_line1 + 200;

    _middleAreaHeight = positionY_line2 - positionY_line1;
    _outsiteCardInterval = 30.0;
    scrollOffsetY = 0.0;

    _cardInfoList = [
      CardInfo(
        cardholderName: "IniOluwa Longe",
        balanceAmount: "₦801,521.91",
        backgroundColor: Color(0xFFEA5EBE),
      ),
      CardInfo(
        cardholderName: "IniOluwa Longe",
        balanceAmount: "₦425,600.00",
        backgroundColor: Color(0xFF0A0A0A),
      ),
      CardInfo(
        cardholderName: "IniOluwa Longe",
        balanceAmount: "₦650,320.50",
        backgroundColor: Colors.pinkAccent,
      ),
      CardInfo(
        cardholderName: "IniOluwa Longe",
        balanceAmount: "₦975,432.25",
        backgroundColor: Color(0xFF0B258A),
      ),
      CardInfo(
        cardholderName: "IniOluwa Longe",
        balanceAmount: "₦123,450.75",
        backgroundColor: Colors.red,
      ),
    ];

    // Initialize card positions
    for (int i = 0; i < _cardInfoList.length; i++) {
      CardInfo cardInfo = _cardInfoList[i];
      if (i == 0) {
        cardInfo.positionY = positionY_line1;
        cardInfo.opacity = 1.0;
        cardInfo.rotate = 1.0;
        cardInfo.scale = 1.0;
      } else {
        cardInfo.positionY = positionY_line2 + (i - 1) * 30;
        cardInfo.opacity = 0.7 - (i - 1) * 0.1;
        cardInfo.rotate = -60;
        cardInfo.scale = 0.9;
      }
    }

    _cardInfoList = _cardInfoList.reversed.toList();
  }

  List<Widget> _buildCards() {
    List<Widget> widgetList = [];
    final screenWidth = MediaQuery.of(context).size.width;

    for (CardInfo cardInfo in _cardInfoList) {
      widgetList.add(
        Positioned(
          top: cardInfo.positionY,
          // Center the card horizontally
          left: 0,
          right: 0,
          child: Center(
            child: Transform(
              transform:
                  Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(pi / 180 * cardInfo.rotate)
                    ..scale(cardInfo.scale),
              alignment: Alignment.topCenter,
              child: Opacity(
                opacity: cardInfo.opacity,
                child: SizedBox(
                  width: screenWidth, // Use full screen width
                  child: CurrencyCard(
                    cardholderName: cardInfo.cardholderName,
                    balanceAmount: cardInfo.balanceAmount,
                    backgroundColor: cardInfo.backgroundColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return widgetList;
  }

  void _updateCardPosition(double offsetY) {
    scrollOffsetY += offsetY;

    void updatePosition(CardInfo cardInfo, double firstCardAreaIdx, int index) {
      double currentCardAreaIdx = firstCardAreaIdx + index;
      if (currentCardAreaIdx < 0) {
        cardInfo.positionY = positionY_line1 + currentCardAreaIdx * 5;

        cardInfo.scale =
            1.0 - 0.2 / 10 * (positionY_line1 - cardInfo.positionY);
        if (cardInfo.scale < 0.8) cardInfo.scale = 0.8;
        if (cardInfo.scale > 1) cardInfo.scale = 1.0;

        cardInfo.rotate = -90.0 / 5 * (positionY_line1 - cardInfo.positionY);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -90.0) cardInfo.rotate = -90.0;

        cardInfo.opacity =
            1.0 - 0.7 / 5 * (positionY_line1 - cardInfo.positionY);
        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;
        if (cardInfo.opacity > 1) cardInfo.opacity = 1.0;
      } else if (currentCardAreaIdx >= 0 && currentCardAreaIdx < 1) {
        cardInfo.scale =
            1.0 -
            0.1 /
                (positionY_line2 - positionY_line1) *
                (cardInfo.positionY - positionY_line1);
        if (cardInfo.scale < 0.9) cardInfo.scale = 0.9;
        if (cardInfo.scale > 1) cardInfo.scale = 1.0;

        cardInfo.positionY =
            positionY_line1 + currentCardAreaIdx * _middleAreaHeight;

        cardInfo.rotate =
            -60.0 /
            (positionY_line2 - positionY_line1) *
            (cardInfo.positionY - positionY_line1);
        if (cardInfo.rotate > 0.0) cardInfo.rotate = 0.0;
        if (cardInfo.rotate < -60.0) cardInfo.rotate = -60.0;

        cardInfo.opacity =
            1.0 -
            0.3 /
                (positionY_line2 - positionY_line1) *
                (cardInfo.positionY - positionY_line1);
        if (cardInfo.opacity < 0.0) cardInfo.opacity = 0.0;
        if (cardInfo.opacity > 1) cardInfo.opacity = 1.0;
      } else if (currentCardAreaIdx >= 1) {
        cardInfo.positionY =
            positionY_line2 + (currentCardAreaIdx - 1) * _outsiteCardInterval;
        cardInfo.rotate = -60.0;
        cardInfo.scale = 0.9;
        cardInfo.opacity = 0.7;
      }
    }

    double firstCardAreaIdx = scrollOffsetY / _middleAreaHeight;

    setState(() {
      for (int i = 0; i < _cardInfoList.length; i++) {
        CardInfo cardInfo = _cardInfoList[_cardInfoList.length - 1 - i];
        updatePosition(cardInfo, firstCardAreaIdx, i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails d) {
        _updateCardPosition(d.delta.dy);
      },
      onVerticalDragEnd: (DragEndDetails d) {
        scrollOffsetY =
            (scrollOffsetY / _middleAreaHeight).round() * _middleAreaHeight;
        _updateCardPosition(0);
      },
      child: Container(
        width: double.infinity, // Use all available width
        height: widget.height, // Use provided height
        decoration: BoxDecoration(color: Colors.transparent),
        child: Stack(
          alignment: Alignment.topCenter,
          fit: StackFit.expand, // Make stack fill its parent
          children: [..._buildCards()],
        ),
      ),
    );
  }
}
