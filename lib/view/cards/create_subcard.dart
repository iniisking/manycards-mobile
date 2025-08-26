import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/textfield.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/subcard_controller.dart';
import 'package:manycards/controller/card_controller.dart';
import 'package:intl/intl.dart';

class CreateSubcard extends StatefulWidget {
  const CreateSubcard({super.key});

  @override
  State<CreateSubcard> createState() => _CreateSubcardState();
}

class _CreateSubcardState extends State<CreateSubcard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  double _spendingLimit = 1000;
  String _duration = 'Per Month';
  String _selectedColor = '#479951'; // Default green color
  bool _isFormValid = false;

  final List<String> _durations = [
    'Per Month',
    'Per Year',
    'Per Transaction',
    'Total',
    'Single Use',
  ];

  final List<Map<String, dynamic>> _colors = [
    {'name': 'Green', 'color': '#479951'},
    {'name': 'Blue', 'color': '#1E3A8A'},
    {'name': 'Red', 'color': '#991B1B'},
    {'name': 'Purple', 'color': '#7C3AED'},
    {'name': 'Orange', 'color': '#EA580C'},
    {'name': 'Teal', 'color': '#0F766E'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    // Initialize spending limit to a reasonable default based on card balance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cardController = Provider.of<CardController>(
        context,
        listen: false,
      );
      final maxBalance = cardController.balance;
        setState(() {
        // Clamp the initial spending limit to the available balance
        _spendingLimit = _spendingLimit.clamp(0.0, maxBalance > 0 ? maxBalance : 10000);
        });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _nameController.text.trim().isNotEmpty;
    });
  }

  int _getDurationDays() {
    switch (_duration) {
      case 'Per Month':
        return 30;
      case 'Per Year':
        return 365;
      case 'Per Transaction':
        return 1;
      case 'Total':
        return 0; // No expiration
      case 'Single Use':
        return 1;
      default:
        return 30;
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final controller = Provider.of<SubcardController>(context, listen: false);
      final cardController = Provider.of<CardController>(
        context,
        listen: false,
      );

      // Validate spending limit doesn't exceed available balance
      if (_spendingLimit > cardController.balance) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Spending limit cannot exceed available balance'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final success = await controller.createSubcard(
        name: _nameController.text.trim(),
        color: _selectedColor,
        spendingLimit: _spendingLimit.toInt(),
        durationDays: _getDurationDays(),
        resume: _duration == 'Total', // Resume if it's a total limit
        merchantName:
            _nameController.text.trim(), // Use card name as merchant name
      );

      if (success && mounted) {
        // Show success animation and navigate back
        await _showSuccessDialog();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              controller.errorMessage ?? 'Failed to create subcard',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.green, size: 40.sp),
                ),
                SizedBox(height: 16.h),
                CustomTextWidget(
                  text: 'Subcard Created!',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: fisrtHeaderTextColor,
                ),
                SizedBox(height: 8.h),
                CustomTextWidget(
                  text: 'Your subcard has been created successfully',
                  fontSize: 14.sp,
                  color: secondHeadTextColor,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'Continue',
                  onTap: () async {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Close modal
                    // Navigate back to subcard screen and refresh
                    if (mounted) {
                      Navigator.pop(
                        context,
                        true,
                      ); // Return true to indicate success
                    }
                  },
                  color: buttonBackgroundColor,
                  textColor: buttonTextColor,
                ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SubcardController>(context);
    final cardController = Provider.of<CardController>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      decoration: BoxDecoration(
        color: backgroundColor,
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
            SizedBox(height: 20.h),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  text: 'Create Sub Card',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: fisrtHeaderTextColor,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 32.h,
                    width: 48.w,
                    decoration: BoxDecoration(
                      color: actionButtonColor,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(
                      Icons.close,
                      color: fisrtHeaderTextColor,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            CustomTextWidget(
              text: 'Create a subcard with spending\nlimits and duration',
              fontSize: 14.sp,
              color: secondHeadTextColor,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(height: 20.h),

            // Name Field
            CustomTextWidget(
              text: 'Subcard Name',
              fontSize: 14.sp,
              color: fisrtHeaderTextColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            AuthTextFormField(
              hintText: 'Enter subcard name',
              controller: _nameController,
              primaryBorderColor: textfiledBorderColor,
              errorBorderColor: errorBorderColor,
              validator:
                  (value) =>
                      value == null || value.isEmpty ? 'Enter a name' : null,
            ),
            SizedBox(height: 20.h),

            // Color Selection
            CustomTextWidget(
              text: 'Card Color',
              fontSize: 14.sp,
              color: fisrtHeaderTextColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: textfieldBackgroundColor,
                borderRadius: BorderRadius.circular(17.r),
                border: Border.all(color: textfiledBorderColor),
              ),
              child: Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children:
                    _colors.map((colorData) {
                      final color = Color(
                        int.parse(colorData['color'].replaceAll('#', '0xFF')),
                      );
                      final isSelected = _selectedColor == colorData['color'];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = colorData['color'];
                          });
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border:
                                isSelected
                                    ? Border.all(
                                      color: fisrtHeaderTextColor,
                                      width: 3,
                                    )
                                    : null,
                          ),
                          child:
                              isSelected
                                  ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20.sp,
                                  )
                                  : null,
                        ),
                      );
                    }).toList(),
              ),
            ),
            SizedBox(height: 20.h),

            // Spending Limit Section
            CustomTextWidget(
              text: 'Spending Limit',
              fontSize: 14.sp,
              color: fisrtHeaderTextColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: textfieldBackgroundColor,
                borderRadius: BorderRadius.circular(17.r),
                border: Border.all(color: textfiledBorderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text:
                            '${controller.selectedCurrencySymbol}${NumberFormat('#,##0.00').format(_spendingLimit)}',
                        fontSize: 18.sp,
                        color: fisrtHeaderTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      CustomTextWidget(
                        text: controller.selectedCurrencyCode,
                        fontSize: 12.sp,
                        color: secondHeadTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: fisrtHeaderTextColor,
                      inactiveTrackColor: actionButtonColor,
                      thumbColor: fisrtHeaderTextColor,
                      overlayColor: fisrtHeaderTextColor.withOpacity(0.2),
                      trackHeight: 4.h,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8.r,
                      ),
                      overlayShape: RoundSliderOverlayShape(
                        overlayRadius: 16.r,
                      ),
                    ),
                    child: Slider(
                      value: _spendingLimit.clamp(0.0, cardController.balance > 0 ? cardController.balance : 10000),
                      min: 0,
                      max:
                          cardController.balance > 0
                              ? cardController.balance
                              : 10000,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          _spendingLimit = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        text: 'Available Balance:',
                        fontSize: 12.sp,
                        color: secondHeadTextColor,
                      ),
                      CustomTextWidget(
                        text:
                            '${cardController.currencySymbol}${NumberFormat('#,##0.00').format(cardController.balance)}',
                        fontSize: 12.sp,
                        color: fisrtHeaderTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Duration Dropdown
            CustomTextWidget(
              text: 'Transaction Duration',
              fontSize: 14.sp,
              color: fisrtHeaderTextColor,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: textfieldBackgroundColor,
                borderRadius: BorderRadius.circular(17.r),
                border: Border.all(color: textfiledBorderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _duration,
                  dropdownColor: textfieldBackgroundColor,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: fisrtHeaderTextColor,
                    size: 20.sp,
                  ),
                  style: TextStyle(
                    color: fisrtHeaderTextColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  items:
                      _durations.map((String duration) {
                        return DropdownMenuItem<String>(
                          value: duration,
                          child: Text(duration),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _duration = newValue!;
                    });
                  },
                ),
              ),
            ),
            const Spacer(),

            // Create Button
            CustomButton(
              text: 'Create Subcard',
              onTap: _submit,
              isLoading: controller.isCreating,
              loadingText: 'Creating...',
              color: buttonBackgroundColor,
              textColor: buttonTextColor,
              isEnabled: _isFormValid && !controller.isCreating,
            ),
          ],
        ),
      ),
    );
  }
}
