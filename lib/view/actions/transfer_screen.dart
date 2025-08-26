// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:provider/provider.dart';
import 'package:manycards/view/constants/widgets/currency_dropdown.dart';
import 'package:manycards/controller/transfer_controller.dart';
import 'package:manycards/view/constants/widgets/shimmers.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cards after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final controller = Provider.of<TransferController>(
          context,
          listen: false,
        );
        if (!controller.disposed) {
          controller.fetchCards();
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Add the flag icon helper function
  Widget _getFlagForCurrency(String currency) {
    switch (currency) {
      case 'NGN':
        return Image.asset(
          'assets/images/nigerian flag.png',
          height: 20,
          width: 20,
        );
      case 'USD':
        return Image.asset('assets/images/us flag.png', height: 20, width: 20);
      case 'GBP':
        return Image.asset('assets/images/uk flag.png', height: 20, width: 20);
      default:
        return const SizedBox(width: 20, height: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransferController>(
      builder: (context, controller, child) {
        // Check if the controller is disposed
        if (!mounted) {
          return const SizedBox.shrink();
        }

        final sourceAmountController = TextEditingController(
          text: controller.sourceAmount,
        );
        final destAmountController = TextEditingController(
          text: controller.destAmount,
        );
        sourceAmountController.selection = TextSelection.collapsed(
          offset: controller.sourceAmount.length,
        );
        destAmountController.selection = TextSelection.collapsed(
          offset: controller.destAmount.length,
        );

        void onSourceAmountChanged(String value) {
          final raw = value.replaceAll(',', '');
          if (raw.isEmpty) {
            controller.setSourceAmount('');
            return;
          }
          final parsed = double.tryParse(raw);
          if (parsed == null) {
            controller.setSourceAmount('');
            return;
          }
          final formatted = controller.numberFormat.format(parsed);
          if (formatted != value) {
            final newSelection = TextSelection.collapsed(
              offset: formatted.length,
            );
            sourceAmountController.value = TextEditingValue(
              text: formatted,
              selection: newSelection,
            );
          }
          controller.setSourceAmount(formatted);
        }

        void onDestAmountChanged(String value) {
          final raw = value.replaceAll(',', '');
          if (raw.isEmpty) {
            controller.setDestAmount('');
            return;
          }
          final parsed = double.tryParse(raw);
          if (parsed == null) {
            controller.setDestAmount('');
            return;
          }
          final formatted = controller.numberFormat.format(parsed);
          if (formatted != value) {
            final newSelection = TextSelection.collapsed(
              offset: formatted.length,
            );
            destAmountController.value = TextEditingValue(
              text: formatted,
              selection: newSelection,
            );
          }
          controller.setDestAmount(formatted);
        }

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
                        initialValue: controller.sourceCurrency,
                        onCurrencyChanged:
                            (val) => controller.setSourceCurrency(val!),
                        backgroundColor: const Color(0xFF232323),
                        shadowColor: Colors.black,
                        customCurrencies:
                            controller.cards
                                .where(
                                  (c) => c.currency != controller.destCurrency,
                                )
                                .map(
                                  (c) => CurrencyOption(
                                    value: c.currency,
                                    flagAsset: _getFlagForCurrency(c.currency),
                                    label: c.currency,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Swap button
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: const Color(0xFF232323),
                          shape: const CircleBorder(),
                          elevation: 0,
                        ),
                        onPressed: () {
                          final oldFrom = controller.sourceCurrency;
                          final oldTo = controller.destCurrency;
                          controller.setSourceCurrency(oldTo);
                          controller.setDestCurrency(oldFrom);
                        },
                        child: Icon(
                          Icons.swap_horiz,
                          color: fisrtHeaderTextColor,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CurrencyDropdown(
                        initialValue: controller.destCurrency,
                        onCurrencyChanged:
                            (val) => controller.setDestCurrency(val!),
                        backgroundColor: const Color(0xFF232323),
                        shadowColor: Colors.black,
                        customCurrencies:
                            controller.cards
                                .where(
                                  (c) =>
                                      c.currency != controller.sourceCurrency,
                                )
                                .map(
                                  (c) => CurrencyOption(
                                    value: c.currency,
                                    flagAsset: _getFlagForCurrency(c.currency),
                                    label: c.currency,
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                CustomTextWidget(
                  text: 'From',
                  fontSize: 14.sp,
                  color: fisrtHeaderTextColor,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                Builder(
                  builder: (context) {
                    if (controller.isCardLoading) {
                      return const BalanceShimmer();
                    } else if (controller.sourceCard != null) {
                      return CustomTextWidget(
                        text:
                            'Available:  ${controller.numberFormat.format(controller.sourceCard!.balance)} ${controller.sourceCard!.currency}',
                        fontSize: 13.sp,
                        color: secondHeadTextColor,
                        fontWeight: FontWeight.w400,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: sourceAmountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(
                    color: fisrtHeaderTextColor,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount (${controller.sourceCurrency})',
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter amount';
                    }
                    final raw = value.replaceAll(',', '');
                    final parsed = double.tryParse(raw);
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid amount';
                    }
                    if (controller.sourceCard != null &&
                        parsed > controller.sourceCard!.balance) {
                      return 'Insufficient balance';
                    }
                    return null;
                  },
                  onChanged: onSourceAmountChanged,
                ),
                SizedBox(height: 24.h),
                // TO SECTION
                CustomTextWidget(
                  text: 'To',
                  fontSize: 14.sp,
                  color: fisrtHeaderTextColor,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8.h),
                Builder(
                  builder: (context) {
                    if (controller.isCardLoading) {
                      return const BalanceShimmer();
                    } else if (controller.destCard != null) {
                      return CustomTextWidget(
                        text:
                            'Available: ${controller.numberFormat.format(controller.destCard!.balance)} ${controller.destCard!.currency}',
                        fontSize: 13.sp,
                        color: secondHeadTextColor,
                        fontWeight: FontWeight.w400,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: destAmountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(
                    color: fisrtHeaderTextColor,
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Amount (${controller.destCurrency})',
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: onDestAmountChanged,
                ),
                SizedBox(height: 16.h),
                Builder(
                  builder: (context) {
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
                if (controller.error != null &&
                    !controller.error!.contains('No cards available'))
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      controller.error!,
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onTap:
                        controller.isFormValid && !controller.isLoading
                            ? () async {
                              final result = await controller.performTransfer();
                              if (result && context.mounted) {
                                await Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => const TransferSuccessScreen(),
                                  ),
                                );
                              }
                            }
                            : null,
                    text: controller.isLoading ? 'Processing...' : 'Transfer',
                    color:
                        controller.isFormValid && !controller.isLoading
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
                  // Navigate back to the root of the app without accessing the disposed controller
                  Navigator.of(context).popUntil((route) => route.isFirst);
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
