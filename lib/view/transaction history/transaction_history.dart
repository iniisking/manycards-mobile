import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/currency_dropdown.dart';
import 'package:manycards/view/constants/widgets/shimmers.dart';
import 'package:manycards/view/constants/widgets/transaction_row_widget.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/transaction_controller.dart';
import 'package:manycards/controller/currency_controller.dart';
import 'package:manycards/model/transaction history/res/get_all_transactions_res.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  String selectedCurrency = 'USD';

  @override
  void initState() {
    super.initState();
    // Optionally, you can load transactions here if needed
  }

  List<Transaction> _getFilteredTransactions(
    TransactionController transactionController,
    String currency,
  ) {
    return transactionController.transactions.where((transaction) {
      return transaction.currency == currency ||
          transaction.sourceCurrency == currency ||
          transaction.destinationCurrency == currency;
    }).toList();
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
          color: Color(0xFFEAEAEA),
          size: 20.sp,
        );
      case 'transfer':
        return Icon(Icons.swap_horiz, color: Color(0xFFEAEAEA), size: 20.sp);
      case 'withdrawal':
      case 'withdraw':
        return Icon(
          Icons.remove_circle_outline,
          color: Color(0xFFEAEAEA),
          size: 20.sp,
        );
      case 'payment':
        return Icon(Icons.payment, color: Color(0xFFEAEAEA), size: 20.sp);
      default:
        return Icon(
          Icons.account_balance_wallet,
          color: Color(0xFFEAEAEA),
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
      final amountDebited = transaction.amountDebited ?? 0;
      final sourceCurrency = transaction.sourceCurrency ?? currencyCode;
      return '-${_getCurrencySymbol(sourceCurrency)}${(amountDebited / 100).toStringAsFixed(2)}';
    } else {
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionController, CurrencyController>(
      builder: (context, transactionController, currencyController, child) {
        final filteredTransactions = _getFilteredTransactions(
          transactionController,
          selectedCurrency,
        );
        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
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
                          setState(() {
                            selectedCurrency = value!;
                          });
                        },
                        backgroundColor: Color(0xFF232323),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  if (transactionController.isLoading)
                    ...List.generate(8, (index) => TransactionRowShimmer()),
                  if (!transactionController.isLoading &&
                      filteredTransactions.isEmpty)
                    CustomTextWidget(
                      text: 'No transactions available for $selectedCurrency',
                      fontSize: 14.sp,
                      color: Color(0xFFB0B0B0),
                    ),
                  if (!transactionController.isLoading &&
                      filteredTransactions.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          return Column(
                            children: [
                              TransactionRowWidget(
                                leadingIcon: _getTransactionIcon(
                                  transaction.type,
                                ),
                                title: _getTransactionTitle(transaction.type),
                                subtitle: _formatDate(transaction.createdAt),
                                description: _getTransactionDescription(
                                  transaction,
                                ),
                                amount:
                                    currencyController.isBalanceVisible
                                        ? _formatAmount(
                                          transaction,
                                          selectedCurrency,
                                        )
                                        : '* * * * * *',
                              ),
                              if (index < filteredTransactions.length - 1)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Divider(
                                    thickness: 1.h,
                                    color: Color(0xFF232323),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
