// ignore_for_file: unused_field

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/controller/payment_controller.dart';
import 'package:manycards/view/actions/paystack_webview.dart';
import 'package:intl/intl.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _numberFormat = NumberFormat("#,##0", "en_US");
  final _decimalFormat = NumberFormat("#,##0.00", "en_US");
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatAmount);
    _amountController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatAmount);
    _amountController.removeListener(_validateForm);
    _amountController.dispose();
    super.dispose();
  }

  void _validateForm() {
    if (_formKey.currentState != null) {
      _formKey.currentState!.validate();
      setState(() {
        final amount = double.tryParse(
          _amountController.text.replaceAll(',', ''),
        );
        _isFormValid = amount != null && amount >= 50 && amount <= 1000000;
      });
    }
  }

  void _formatAmount() {
    if (_amountController.text.isEmpty) return;

    // Remove all non-digit characters except decimal point
    String digitsOnly = _amountController.text.replaceAll(
      RegExp(r'[^\d.]'),
      '',
    );
    debugPrint('After removing non-digits: $digitsOnly');

    // Ensure only one decimal point
    if (digitsOnly.split('.').length > 2) {
      digitsOnly = digitsOnly.substring(0, digitsOnly.lastIndexOf('.'));
    }

    // Don't format if the user is currently typing after a decimal point
    if (digitsOnly.endsWith('.')) {
      if (digitsOnly != _amountController.text) {
        _amountController.value = TextEditingValue(
          text: digitsOnly,
          selection: TextSelection.collapsed(offset: digitsOnly.length),
        );
      }
      return;
    }

    // If there's a decimal point, only format the whole number part
    if (digitsOnly.contains('.')) {
      final parts = digitsOnly.split('.');
      debugPrint('Decimal parts: ${parts.join(', ')}');
      double wholeNumber = double.parse(parts[0]);
      String formatted = '${_numberFormat.format(wholeNumber)}.${parts[1]}';
      debugPrint('Formatted with decimal: $formatted');

      if (formatted != _amountController.text) {
        _amountController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
      return;
    }

    // Format whole numbers
    if (digitsOnly.isNotEmpty) {
      double number = double.parse(digitsOnly);
      String formatted = _numberFormat.format(number);
      debugPrint('Formatted whole number: $formatted');

      if (formatted != _amountController.text) {
        _amountController.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }
  }

  Future<void> _handleTopUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final paymentController = context.read<PaymentController>();

        // Get the raw input value and remove commas, parse as double
        final amount = double.parse(_amountController.text.replaceAll(',', ''));
        debugPrint('Amount to send: $amount');

        final success = await paymentController.initiateTopUp(context, amount);

        if (success && mounted) {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder:
                  (context) => PaystackWebView(
                    url: paymentController.authorizationUrl!,
                    reference: paymentController.reference!,
                    cardId: paymentController.cardId!,
                  ),
            ),
          );

          if (result == true && mounted) {
            // Refresh the home screen
            Navigator.pop(context, true);
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                paymentController.error ?? 'Failed to initiate payment',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      decoration: BoxDecoration(
        color: buttonTextColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  text: 'Top Up',
                  fontSize: 24.sp,
                  color: fisrtHeaderTextColor,
                  fontWeight: FontWeight.bold,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: fisrtHeaderTextColor,
                    size: 28.sp,
                    weight: 600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            CustomTextWidget(
              text: 'Fund your Naira wallet to make payments',
              fontSize: 15.sp,
              color: secondHeadTextColor,
              fontWeight: FontWeight.normal,
            ),

            SizedBox(height: 24.h),
            CustomTextWidget(
              text: 'Enter Amount (₦)',
              fontSize: 16.sp,
              color: fisrtHeaderTextColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: TextStyle(color: fisrtHeaderTextColor, fontSize: 16.sp),
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(
                  color: fisrtHeaderTextColor.withOpacity(0.5),
                  fontSize: 16.sp,
                ),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                prefixText: '₦ ',
                prefixStyle: TextStyle(
                  color: fisrtHeaderTextColor,
                  fontSize: 16.sp,
                ),
                errorStyle: TextStyle(color: Colors.red[400], fontSize: 12.sp),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                // Remove commas and convert to number
                final amount = double.tryParse(value.replaceAll(',', ''));
                if (amount == null) {
                  return 'Please enter a valid amount';
                }
                if (amount < 50) {
                  return 'Minimum amount is ₦50';
                }
                if (amount > 1000000) {
                  return 'Amount cannot exceed ₦1,000,000';
                }
                return null;
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onTap: _isLoading ? null : _handleTopUp,
                text: _isLoading ? 'Processing...' : 'Top Up',
                color:
                    _isFormValid
                        ? buttonBackgroundColor
                        : inactiveButtonBackground,
                textColor: _isFormValid ? buttonTextColor : inactiveButtonText,
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
