import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/view/cards/sub_card_screen.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/cards.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/currency_dropdown.dart';
import 'package:manycards/view/constants/widgets/shimmers.dart';
import 'package:manycards/view/constants/widgets/transaction_row_widget.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/card_controller.dart';
import 'package:manycards/controller/currency_controller.dart';
import 'package:manycards/controller/transaction_controller.dart';
import 'package:manycards/model/transaction history/res/get_all_transactions_res.dart';
import 'package:intl/intl.dart';

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

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      case 'NGN':
        return '₦';
      default:
        return '';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${_formatTime(date)}';
    }
  }

  Widget _getTransactionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'funding':
      case 'top_up':
        return Icon(
          Icons.add_circle_outline,
          color: fisrtHeaderTextColor,
          size: 20.sp,
        );
      case 'transfer':
        return Icon(Icons.swap_horiz, color: fisrtHeaderTextColor, size: 20.sp);
      case 'withdrawal':
      case 'withdraw':
        return Icon(
          Icons.remove_circle_outline,
          color: fisrtHeaderTextColor,
          size: 20.sp,
        );
      case 'payment':
        return Icon(Icons.payment, color: fisrtHeaderTextColor, size: 20.sp);
      default:
        return Icon(
          Icons.account_balance_wallet,
          color: fisrtHeaderTextColor,
          size: 20.sp,
        );
    }
  }

  String _getTransactionTitle(String type) {
    switch (type.toLowerCase()) {
      case 'funding':
      case 'top_up':
        return 'Card Funding';
      case 'transfer':
        return 'Transfer';
      case 'withdrawal':
      case 'withdraw':
        return 'Withdrawal';
      case 'payment':
        return 'Payment';
      default:
        return 'Transaction';
    }
  }

  String _getTransactionDescription(Transaction transaction) {
    switch (transaction.type.toLowerCase()) {
      case 'funding':
      case 'top_up':
        return 'You funded your ${transaction.currency ?? 'Card'}';
      case 'transfer':
        // Show destination currency instead of card ID
        if (transaction.destinationCurrency != null) {
          return 'Transfer to ${transaction.destinationCurrency} main card';
        }
        return 'Transfer to another card';
      case 'withdrawal':
      case 'withdraw':
        return 'Withdrawal from your card';
      case 'payment':
        return 'Payment processed';
      default:
        return 'Transaction completed';
    }
  }

  String _formatAmount(Transaction transaction, String currencyCode) {
    final format = NumberFormat('#,##0.00');
    if (transaction.type.toLowerCase() == 'transfer') {
      final amountDebited = transaction.amountDebited ?? 0;
      final sourceCurrency = transaction.sourceCurrency ?? currencyCode;
      return '-${_getCurrencySymbol(sourceCurrency)}${format.format(amountDebited)}';
    } else {
      final amount = transaction.amount ?? 0;
      final currency = transaction.currency ?? currencyCode;
      if (transaction.type.toLowerCase() == 'funding' ||
          transaction.type.toLowerCase() == 'top_up') {
        return '+${_getCurrencySymbol(currency)}${format.format(amount)}';
      } else {
        return '-${_getCurrencySymbol(currency)}${format.format(amount)}';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<CardController, CurrencyController, TransactionController>(
      builder: (
        context,
        cardController,
        currencyController,
        transactionController,
        child,
      ) {
        final selectedCard = cardController.selectedCard;
        final currentCurrency = cardController.currencyCode;
        final filteredTransactions =
            transactionController.transactions.where((transaction) {
              return transaction.currency == currentCurrency ||
                  transaction.sourceCurrency == currentCurrency ||
                  transaction.destinationCurrency == currentCurrency;
            }).toList();
        final isFilteredEmpty =
            filteredTransactions.isEmpty &&
            !(cardController.isLoading || currencyController.isLoading);
        final showAll = ValueNotifier<bool>(false);

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
                          expiryDate: selectedCard.expiry,
                          cardholderName:
                              '****', // You can update this if you have the name
                          isBackVisible: cardController.isCardDetailsVisible,
                          cvv: selectedCard.cvv,
                          fullCardNumber: selectedCard.number,
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
                            onTap: () {
                              cardController.toggleCardDetailsVisibility();
                            },
                            icon: Padding(
                              padding: EdgeInsets.all(5.sp),
                              child:
                                  cardController.isCardDetailsVisible
                                      ? Icon(
                                        Icons.visibility_off,
                                        color: Color(0xFFC4C4C4),
                                        size: 24,
                                      )
                                      : Assets.images.view.image(
                                        color: const Color(0xFFC4C4C4),
                                      ),
                            ),
                            label:
                                cardController.isCardDetailsVisible
                                    ? 'Hide Details'
                                    : 'View Details',
                          ),
                          QuickActionButton(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: const RouteSettings(
                                    name: '/subcard',
                                  ),
                                  builder: (context) => const SubCardScreen(),
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
                      if (isFilteredEmpty)
                        ValueListenableBuilder<bool>(
                          valueListenable: showAll,
                          builder:
                              (context, value, _) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: actionButtonColor,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      showAll.value = !showAll.value;
                                    },
                                    child: Text(
                                      value ? 'Show Filtered' : 'Show All',
                                    ),
                                  ),
                                ],
                              ),
                        ),
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
                        ValueListenableBuilder<bool>(
                          valueListenable: showAll,
                          builder: (context, value, _) {
                            final list =
                                value
                                    ? transactionController.transactions
                                    : filteredTransactions;
                            if (list.isEmpty) {
                              return Center(
                                child: CustomTextWidget(
                                  text:
                                      value
                                          ? 'No transactions available.'
                                          : 'No transactions available for $currentCurrency',
                                  fontSize: 14.sp,
                                  color: secondHeadTextColor,
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final transaction = list[index];
                                return Column(
                                  children: [
                                    TransactionRowWidget(
                                      leadingIcon: _getTransactionIcon(
                                        transaction.type,
                                      ),
                                      title: _getTransactionTitle(
                                        transaction.type,
                                      ),
                                      subtitle: _formatDate(
                                        transaction.createdAt,
                                      ),
                                      description: _getTransactionDescription(
                                        transaction,
                                      ),
                                      amount:
                                          currencyController.isBalanceVisible
                                              ? _formatAmount(
                                                transaction,
                                                currentCurrency,
                                              )
                                              : '* * * * * *',
                                    ),
                                    if (index < list.length - 1)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8.h,
                                        ),
                                        child: Divider(
                                          thickness: 1.h,
                                          color: actionButtonColor,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            );
                          },
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
