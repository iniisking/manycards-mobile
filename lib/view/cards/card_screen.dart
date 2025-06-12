import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/view/cards/sub_card.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/cards.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/currency_dropdown.dart';
import 'package:manycards/view/constants/widgets/shimmers.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/card_controller.dart';
import 'package:manycards/controller/currency_controller.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  Future<void> _handleRefresh(
    BuildContext context,
    CardController controller,
  ) async {
    try {
      await controller.loadCards();
    } catch (e) {
      debugPrint('Refresh error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CardController, CurrencyController>(
      builder: (context, cardController, currencyController, child) {
        final selectedCard = cardController.selectedCard;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: LiquidPullToRefresh(
              onRefresh: () => _handleRefresh(context, cardController),
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
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            text: 'My Cards',
                            fontSize: 18.sp,
                            color: fisrtHeaderTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                          CurrencyDropdown(
                            initialValue: cardController.currencyCode,
                            onCurrencyChanged: (value) {
                              CardCurrency newCurrency;
                              switch (value) {
                                case 'GBP':
                                  newCurrency = CardCurrency.gbp;
                                  break;
                                case 'USD':
                                  newCurrency = CardCurrency.usd;
                                  break;
                                default:
                                  newCurrency = CardCurrency.ngn;
                              }
                              cardController.changeCurrency(newCurrency);
                            },
                            backgroundColor: textfieldBackgroundColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),
                      if (cardController.isLoading ||
                          currencyController.isLoading)
                        const CardShimmer()
                      else if (cardController.cards.isEmpty)
                        const Center(
                          child: Text(
                            'No cards available',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      else if (selectedCard == null)
                        const Center(
                          child: Text(
                            'No card available for selected currency',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      else
                        CurrencyCard(
                          cardColor: cardController.cardColor,
                          balance: selectedCard.balance.toDouble(),
                          currencySymbol: cardController.currencySymbol,
                          cardNumber: selectedCard.maskedNumber,
                        ),
                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          QuickActionButton(
                            onTap: () {},
                            icon: Padding(
                              padding: EdgeInsets.all(5.sp),
                              child: Assets.images.plus.image(
                                color: const Color(0xFFC4C4C4),
                              ),
                            ),
                            label: 'Top Up',
                          ),
                          QuickActionButton(
                            onTap: () {},
                            icon: Padding(
                              padding: EdgeInsets.all(5.sp),
                              child: Assets.images.view.image(
                                color: const Color(0xFFC4C4C4),
                              ),
                            ),
                            label: 'View Details',
                          ),
                          QuickActionButton(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: const RouteSettings(
                                    name: '/subcard',
                                  ),
                                  builder: (context) => const SubCard(),
                                ),
                              );
                              if (result == true) {
                                // Handle the result if needed
                              }
                            },
                            icon: Padding(
                              padding: EdgeInsets.all(5.sp),
                              child: Assets.images.veiwSubcards.image(
                                color: const Color(0xFFC4C4C4),
                              ),
                            ),
                            label: 'View Subcards',
                          ),
                          QuickActionButton(
                            onTap: () {},
                            icon: Padding(
                              padding: EdgeInsets.all(5.sp),
                              child: Assets.images.more.image(
                                color: const Color(0xFFC4C4C4),
                              ),
                            ),
                            label: 'More',
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomTextWidget(
                            text: 'Transactions',
                            fontSize: 18.sp,
                            color: const Color(0xFFEAEAEA),
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      if (cardController.isLoading ||
                          currencyController.isLoading)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return TransactionRowShimmer();
                          },
                        )
                      else
                        const Center(
                          child: Text(
                            'No transactions available',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      SizedBox(height: 75.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
