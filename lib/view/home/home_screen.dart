import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/services/card_service.dart';
import 'package:manycards/services/transfer_service.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/currency_bottom_sheet.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/shimmers.dart';
import 'package:manycards/view/constants/widgets/transaction_row_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/currency_controller.dart';
import '../../controller/auth_controller.dart';
import '../../controller/transaction_controller.dart';
import '../transaction history/transaction_history.dart';
import '../actions/top_up_screen.dart';
import '../actions/transfer_screen.dart';
import '../../controller/transfer_controller.dart';
import '../../model/transaction history/res/get_all_transactions_res.dart';
import '../cards/create_subcard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionController = Provider.of<TransactionController>(context, listen: false);
      final currencyController = Provider.of<CurrencyController>(context, listen: false);
      
      transactionController.loadTransactions(
        currency: currencyController.selectedCurrencyCode,
        limit: 5,
      );
    });
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
        return Icon(
          Icons.swap_horiz,
          color: fisrtHeaderTextColor,
          size: 20.sp,
        );
      case 'withdrawal':
      case 'withdraw':
        return Icon(
          Icons.remove_circle_outline,
          color: fisrtHeaderTextColor,
          size: 20.sp,
        );
      case 'payment':
        return Icon(
          Icons.payment,
          color: fisrtHeaderTextColor,
          size: 20.sp,
        );
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
    if (transaction.type.toLowerCase() == 'transfer') {
      // For transfers, show the debited amount with source currency
      final amountDebited = transaction.amountDebited ?? 0;
      final sourceCurrency = transaction.sourceCurrency ?? currencyCode;
      
      return '-${_getCurrencySymbol(sourceCurrency)}${(amountDebited / 100).toStringAsFixed(2)}';
    } else {
      // For funding/other transactions, use the standard amount and currency
      final amount = transaction.amount ?? 0;
      final currency = transaction.currency ?? currencyCode;
      
      if (transaction.type.toLowerCase() == 'funding' || 
          transaction.type.toLowerCase() == 'top_up') {
        return '+${_getCurrencySymbol(currency)}${(amount / 100).toStringAsFixed(2)}';
      } else {
        return '-${_getCurrencySymbol(currency)}${(amount / 100).toStringAsFixed(2)}';
      }
    }
  }

  Future<void> _handleRefresh(
    BuildContext context,
    CurrencyController controller,
    TransactionController transactionController,
  ) async {
    try {
      await controller.refreshBalances();
      await transactionController.loadTransactions(
        currency: controller.selectedCurrencyCode,
      );
    } catch (e) {
      debugPrint('Refresh error: $e');
    }
  }

  void showCurrencyBottomSheet(
    BuildContext context,
    CurrencyController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (_) => CurrencyBottomSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CurrencyController>(context);
    final authController = Provider.of<AuthController>(context);
    final transactionController = Provider.of<TransactionController>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LiquidPullToRefresh(
          onRefresh: () => _handleRefresh(context, controller, transactionController),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 22.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: 'Hi, ${authController.firstName}',
                        fontSize: 20.sp,
                        color: fisrtHeaderTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      Container(
                        height: 45.h,
                        width: 45.w,
                        padding: EdgeInsets.all(12.sp),
                        decoration: BoxDecoration(
                          color: actionButtonColor,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Assets.svg.notification.svg(),
                      ),
                    ],
                  ),
                  SizedBox(height: 36.h),
                  Row(
                    children: [
                      CustomTextWidget(
                        text: 'Your total account balance',
                        fontSize: 15.sp,
                        color: fisrtHeaderTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          controller.toggleBalanceVisibility();
                        },
                        child: Icon(
                          controller.isBalanceVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20.sp,
                          color: fisrtHeaderTextColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      controller.selectedCurrency['flag'] as Widget,
                      SizedBox(width: 8.w),
                      CustomTextWidget(
                        text: controller.selectedCurrency['code'] as String,
                        fontSize: 16.sp,
                        color: fisrtHeaderTextColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () => showCurrencyBottomSheet(context, controller),
                    child: Row(
                      children: [
                        controller.isLoading || controller.isRefreshing
                            ? Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[700]!,
                              child: Container(
                                width: 200.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            )
                            : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                controller.isBalanceVisible
                                    ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomTextWidget(
                                          text: controller.getFormattedBalance(
                                            controller.selectedCurrencyCode,
                                          ),
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.bold,
                                          color: fisrtHeaderTextColor,
                                        ),
                                      ],
                                    )
                                    : CustomTextWidget(
                                      text: '* * * * * *',
                                      fontSize: 40.sp,
                                      fontWeight: FontWeight.bold,
                                      color: fisrtHeaderTextColor,
                                    ),
                              ],
                            ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 25.sp,
                          color: fisrtHeaderTextColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Top Up
                      QuickActionButton(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height,
                            ),
                            routeSettings: const RouteSettings(name: 'modal'),
                            builder: (context) => const TopUpScreen(),
                          );
                        },
                        icon: Padding(
                          padding: EdgeInsets.all(5.sp),
                          child: Assets.images.plus.image(
                            color: actionButtonIconColor,
                          ),
                        ),
                        label: 'Top Up',
                      ),

                      //Transfer
                      QuickActionButton(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height,
                            ),
                            routeSettings: const RouteSettings(
                              name: 'transfer',
                            ),
                            builder: (context) {
                              return ChangeNotifierProvider<TransferController>(
                                create:
                                    (context) => TransferController(
                                      transferService:
                                          Provider.of<TransferService>(
                                            context,
                                            listen: false,
                                          ),
                                      cardService: Provider.of<CardService>(
                                        context,
                                        listen: false,
                                      ),
                                    )..fetchCards(),
                                child: const TransferScreen(),
                              );
                            },
                          );
                        },
                        icon: Padding(
                          padding: EdgeInsets.all(2.sp),
                          child: Assets.images.transfer.image(
                            color: actionButtonIconColor,
                          ),
                        ),
                        label: 'Transfer',
                      ),

                      //create card
                      QuickActionButton(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height,
                            ),
                            routeSettings: const RouteSettings(name: 'create_subcard'),
                            builder: (context) => const CreateSubcard(),
                          );
                        },
                        icon: Padding(
                          padding: EdgeInsets.all(1.sp),
                          child: Assets.images.createCard.image(
                            color: actionButtonIconColor,
                          ),
                        ),
                        label: 'Create Subcard',
                      ),

                      // withdraw
                      QuickActionButton(
                        onTap: () {},
                        icon: Assets.images.withdraw.image(
                          color: actionButtonIconColor,
                        ),

                        label: 'Withdraw',
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),

                  // Transaction History
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: 'Recent Transactions',
                        fontSize: 18.sp,
                        color: fisrtHeaderTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to transaction history screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TransactionHistory(),
                            ),
                          );
                        },
                        child: CustomTextWidget(
                          text: 'See all',
                          fontSize: 14.sp,
                          color: secondHeadTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  transactionController.isLoading
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return TransactionRowShimmer();
                          },
                        )
                      : transactionController.recentTransactions.isEmpty
                          ? Center(
                              child: CustomTextWidget(
                                text: 'No transactions available',
                                fontSize: 14.sp,
                                color: secondHeadTextColor,
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactionController.recentTransactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactionController.recentTransactions[index];
                                return Column(
                                  children: [
                                    TransactionRowWidget(
                                      leadingIcon: _getTransactionIcon(transaction.type),
                                      title: _getTransactionTitle(transaction.type),
                                      subtitle: _formatDate(transaction.createdAt),
                                      description: _getTransactionDescription(transaction),
                                      amount: controller.isBalanceVisible
                                          ? _formatAmount(transaction, controller.selectedCurrencyCode)
                                          : '* * * * * *',
                                    ),
                                    if (index < transactionController.recentTransactions.length - 1)
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                        child: Divider(thickness: 1.h, color: actionButtonColor),
                                      ),
                                  ],
                                );
                              },
                            ),

                  // TransactionRowWidget(
                  //   leadingIcon: Icon(
                  //     Icons.attach_money,
                  //     color: fisrtHeaderTextColor,
                  //     size: 20.sp,
                  //   ),
                  //   title: 'Card Funding',
                  //   subtitle: 'Feb 3 at 5:17 PM',
                  //   description: 'You funded your USD Card',
                  //   amount:
                  //       controller.isBalanceVisible
                  //           ? '+\$500.00'
                  //           : '* * * * * *',
                  // ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 8.h),
                  //   child: Divider(thickness: 1.h, color: actionButtonColor),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
