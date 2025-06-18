import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/gen/assets.gen.dart';

class CurrencyDropdown extends StatefulWidget {
  final String initialValue;
  final Function(String) onCurrencyChanged;
  final Color backgroundColor;
  final Color shadowColor;
  final List<CurrencyOption>? customCurrencies;
  final String? excludeCurrency;

  const CurrencyDropdown({
    super.key,
    required this.initialValue,
    required this.onCurrencyChanged,
    this.backgroundColor = Colors.white,
    this.shadowColor = Colors.black,
    this.customCurrencies,
    this.excludeCurrency,
  });

  @override
  State<CurrencyDropdown> createState() => _CurrencyDropdownState();
}

class _CurrencyDropdownState extends State<CurrencyDropdown> {
  late String selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    // Default currencies if custom currencies are not provided
    final currencies =
        widget.customCurrencies ??
        [
          CurrencyOption(
            value: 'NGN',
            flagAsset: Assets.images.nigerianFlag.image(
              height: 20.h,
              width: 20.w,
            ),
            label: 'NGN',
          ),
          CurrencyOption(
            value: 'USD',
            flagAsset: Assets.images.usFlag.image(height: 20.h, width: 20.w),
            label: 'USD',
          ),
          CurrencyOption(
            value: 'GBP',
            flagAsset: Assets.images.ukFlag.image(height: 20.h, width: 20.w),
            label: 'GBP',
          ),
        ];

    final filteredCurrencies =
        widget.excludeCurrency == null
            ? currencies
            : currencies
                .where((c) => c.value != widget.excludeCurrency)
                .toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: widget.backgroundColor,
          value: selectedCurrency,
          icon: Icon(Icons.keyboard_arrow_down, size: 18.sp),
          isDense: true,
          items:
              filteredCurrencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency.value,
                  child: Row(
                    children: [
                      currency.flagAsset,
                      SizedBox(width: 8.w),
                      Text(
                        currency.label,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEAEAEA),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedCurrency = value;
              });
              widget.onCurrencyChanged(value);
            }
          },
        ),
      ),
    );
  }
}

class CurrencyOption {
  final String value;
  final Widget flagAsset;
  final String label;

  CurrencyOption({
    required this.value,
    required this.flagAsset,
    required this.label,
  });
}
