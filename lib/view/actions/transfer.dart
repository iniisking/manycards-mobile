// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/services/card_service.dart';
import 'package:provider/provider.dart';
import 'package:manycards/view/constants/widgets/currency_dropdown.dart';
import 'package:manycards/controller/transfer_controller.dart';
import 'package:manycards/services/transfer_service.dart';
import 'package:manycards/view/constants/widgets/shimmers.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransferController>(
      create:
          (context) => TransferController(
            transferService: Provider.of<TransferService>(
              context,
              listen: false,
            ),
            cardService: Provider.of<CardService>(context, listen: false),
          ),
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<TransferController>().fetchCards();
        });
        final sourceAmountController = TextEditingController(
          text: context.read<TransferController>().sourceAmount,
        );
        final destAmountController = TextEditingController(
          text: context.read<TransferController>().destAmount,
        );
        sourceAmountController.selection = TextSelection.collapsed(
          offset: context.read<TransferController>().sourceAmount.length,
        );
        destAmountController.selection = TextSelection.collapsed(
          offset: context.read<TransferController>().destAmount.length,
        );

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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      text: 'Transfer Funds',
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
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                CustomTextWidget(
                  text: 'Transfer between your main cards',
                  fontSize: 15.sp,
                  color: secondHeadTextColor,
                  fontWeight: FontWeight.normal,
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: CurrencyDropdown(
                        initialValue:
                            context.read<TransferController>().sourceCurrency,
                        onCurrencyChanged:
                            (val) => context
                                .read<TransferController>()
                                .setSourceCurrency(val),
                        backgroundColor: const Color(0xFF232323),
                        shadowColor: Colors.black,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: CurrencyDropdown(
                        initialValue:
                            context.read<TransferController>().destCurrency,
                        onCurrencyChanged:
                            (val) => context
                                .read<TransferController>()
                                .setDestCurrency(val),
                        backgroundColor: const Color(0xFF232323),
                        shadowColor: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Builder(
                  builder: (context) {
                    final controller = context.watch<TransferController>();
                    if (controller.isCardLoading) {
                      return const BalanceShimmer();
                    } else if (controller.sourceCard != null) {
                      return CustomTextWidget(
                        text:
                            'Available: ${controller.numberFormat.format(controller.sourceCard!.balance)} ${controller.sourceCard!.currency}',
                        fontSize: 14.sp,
                        color: secondHeadTextColor,
                        fontWeight: FontWeight.w400,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: sourceAmountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: TextStyle(
                          color: fisrtHeaderTextColor,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          labelText:
                              'Amount (${context.read<TransferController>().sourceCurrency})',
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator:
                            context
                                .read<TransferController>()
                                .validateSourceAmount,
                        onChanged:
                            context.read<TransferController>().setSourceAmount,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: TextFormField(
                        controller: destAmountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: TextStyle(
                          color: fisrtHeaderTextColor,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          labelText:
                              'Amount (${context.read<TransferController>().destCurrency})',
                          filled: true,
                          fillColor: const Color(0xFF1E1E1E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged:
                            context.read<TransferController>().setDestAmount,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Builder(
                  builder: (context) {
                    final controller = context.watch<TransferController>();
                    if (controller.isLoading && controller.exchangeRate == 0) {
                      return const RateShimmer();
                    } else if (controller.exchangeRate > 0) {
                      return CustomTextWidget(
                        text:
                            'Rate: 1 ${controller.sourceCurrency} = ${controller.numberFormat.format(controller.exchangeRate)} ${controller.destCurrency}',
                        fontSize: 14.sp,
                        color: secondHeadTextColor,
                        fontWeight: FontWeight.w400,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: 24.h),
                Builder(
                  builder: (context) {
                    final controller = context.watch<TransferController>();
                    if (controller.error != null &&
                        controller.error!.contains('No cards available')) {
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                controller.error!,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                if (context.read<TransferController>().error != null &&
                    !context.read<TransferController>().error!.contains(
                      'No cards available',
                    ))
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      context.read<TransferController>().error!,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onTap:
                        context.read<TransferController>().isFormValid &&
                                !context.read<TransferController>().isLoading
                            ? () async {
                              final result =
                                  await context
                                      .read<TransferController>()
                                      .performTransfer();
                              if (result && context.mounted) {
                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const TransferSuccessScreen(),
                                  ),
                                );
                                context.read<TransferController>().reset();
                              }
                            }
                            : null,
                    text:
                        context.read<TransferController>().isLoading
                            ? 'Processing...'
                            : 'Transfer',
                    color:
                        context.read<TransferController>().isFormValid &&
                                !context.read<TransferController>().isLoading
                            ? buttonBackgroundColor
                            : inactiveButtonBackground,
                    textColor: buttonTextColor,
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TransferSuccessScreen extends StatelessWidget {
  const TransferSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: buttonTextColor,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 80.sp,
              ),
              SizedBox(height: 24.h),
              CustomTextWidget(
                text: 'Transfer Successful!',
                fontSize: 24.sp,
                color: fisrtHeaderTextColor,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 12.h),
              Text(
                'Your funds have been transferred successfully.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: secondHeadTextColor,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 40.h),
              CustomButton(
                text: 'Go to Home',
                onTap: () async {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  return Future.value();
                },
                color: buttonBackgroundColor,
                textColor: buttonTextColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
