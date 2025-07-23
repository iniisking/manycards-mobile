import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/gen/assets.gen.dart';
import 'package:manycards/view/cards/create_subcard.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/navigation_controller.dart';
import 'package:manycards/controller/subcard_controller.dart';
import 'package:manycards/controller/card_controller.dart';
import 'package:manycards/model/subcards/res/get_all_subcard_res.dart';

class SubCardScreen extends StatefulWidget {
  const SubCardScreen({super.key});

  @override
  State<SubCardScreen> createState() => _SubCardState();
}

class _SubCardState extends State<SubCardScreen> {
  NavigationController? _navigationController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigationController = context.read<NavigationController>();
  }

  @override
  void initState() {
    super.initState();
    // Hide bottom nav bar when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _navigationController?.hideBottomNavBar();
        // Load subcards when screen is initialized
        final subcardController = context.read<SubcardController>();
        subcardController.loadSubcards();
      }
    });
  }

  @override
  void dispose() {
    // Show bottom nav bar when screen is disposed
    _navigationController?.showBottomNavBar();
    super.dispose();
  }

  Widget _getCurrencyFlag() {
    final cardController = context.read<CardController>();
    final currencyCode = cardController.currencyCode;
    
    switch (currencyCode) {
      case 'NGN':
        return Assets.images.nigerianFlag.image(
          height: 20.h,
          width: 20.w,
        );
      case 'USD':
        return Assets.images.usFlag.image(
          height: 20.h,
          width: 20.w,
        );
      case 'GBP':
        return Assets.images.ukFlag.image(
          height: 20.h,
          width: 20.w,
        );
      default:
        return Assets.images.nigerianFlag.image(
          height: 20.h,
          width: 20.w,
        );
    }
  }

  void _showSubcardDetails(BuildContext context, Datum subcard, Color cardColor) {
    final subcardController = context.read<SubcardController>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextWidget(
                    text: 'Subcard Details',
                    fontSize: 20.sp,
                    color: fisrtHeaderTextColor,
                    fontWeight: FontWeight.bold,
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
              SizedBox(height: 24.h),
              
              // Card Preview
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: cardColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: CustomTextWidget(
                              text: 'SUB',
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            width: 40.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      CustomTextWidget(
                        text: subcard.name,
                        fontSize: 18.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextWidget(
                        text: '•••• •••• •••• ${subcard.sk.substring(subcard.sk.length - 4)}',
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                text: 'Spending Limit',
                                fontSize: 10.sp,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              CustomTextWidget(
                                text: '${subcardController.selectedCurrencySymbol}${subcard.spendingLimit}',
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomTextWidget(
                                text: 'Expires',
                                fontSize: 10.sp,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              CustomTextWidget(
                                text: '${subcard.expirationDate.day}/${subcard.expirationDate.month}',
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              
              // Details Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Card ID', subcard.sk),
                      _buildDetailRow('Status', subcard.status ? 'Active' : 'Inactive'),
                      _buildDetailRow('Current Spend', '${subcardController.selectedCurrencySymbol}${subcard.currentSpend}'),
                      _buildDetailRow('Remaining', '${subcardController.selectedCurrencySymbol}${subcard.spendingLimit - subcard.currentSpend}'),
                      _buildDetailRow('Created', '${subcard.createdAt.day}/${subcard.createdAt.month}/${subcard.createdAt.year}'),
                      _buildDetailRow('Expires', '${subcard.expirationDate.day}/${subcard.expirationDate.month}/${subcard.expirationDate.year}'),
                      if (subcard.merchantName.isNotEmpty)
                        _buildDetailRow('Merchant', subcard.merchantName),
                      if (subcard.allowedMerchants.isNotEmpty) ...[
                        SizedBox(height: 16.h),
                        CustomTextWidget(
                          text: 'Allowed Merchants',
                          fontSize: 16.sp,
                          color: fisrtHeaderTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(height: 8.h),
                        ...subcard.allowedMerchants.map((merchant) => 
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: CustomTextWidget(
                              text: '• $merchant',
                              fontSize: 14.sp,
                              color: secondHeadTextColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextWidget(
            text: label,
            fontSize: 14.sp,
            color: secondHeadTextColor,
          ),
          CustomTextWidget(
            text: value,
            fontSize: 14.sp,
            color: fisrtHeaderTextColor,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SubcardController, CardController>(
      builder: (context, subcardController, cardController, child) {
        final subcards = subcardController.subcardsForCurrentCurrency;
        final hasSubcards = subcards.isNotEmpty;

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
                      AppBackButton(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _getCurrencyFlag(),
                          CustomTextWidget(
                            text: ' Subcards',
                            fontSize: 18.sp,
                            color: fisrtHeaderTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ],
                  ),

                  if (subcardController.isLoading) ...[
                    SizedBox(height: 80.h),
                    Center(
                      child: CircularProgressIndicator(
                        color: fisrtHeaderTextColor,
                      ),
                    ),
                  ] else if (!hasSubcards) ...[
                    // Empty State
                    SizedBox(height: 80.h),
                    GestureDetector(
                      onTap: () async {
                        final result = await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height,
                          ),
                          routeSettings: const RouteSettings(name: 'subcard'),
                          builder: (context) => CreateSubcard(),
                        );
                        // Refresh subcards if creation was successful
                        if (result == true) {
                          subcardController.loadSubcards();
                        }
                      },
                      child: DottedBorder(
                        color: actionButtonColor,
                        strokeWidth: 2,
                        dashPattern: const [8, 4],
                        radius: Radius.circular(20.r),
                        borderType: BorderType.RRect,
                        child: SizedBox(
                          height: 186.h,
                          width: 327.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomTextWidget(
                                text: 'No Subcards',
                                fontSize: 18.sp,
                                color: const Color(0xFF606060),
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 10.h),
                              CustomTextWidget(
                                text: 'Create a subcard to get started',
                                fontSize: 14.sp,
                                color: const Color(0xFF606060),
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(height: 10.h),
                              Assets.images.plus.image(
                                height: 30.h,
                                width: 30.w,
                                color: const Color(0xFF606060),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Non-empty State
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextWidget(
                          text: 'Your Subcards',
                          fontSize: 18.sp,
                          color: fisrtHeaderTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height,
                              ),
                              routeSettings: const RouteSettings(name: 'subcard'),
                              builder: (context) => CreateSubcard(),
                            );
                            // Refresh subcards if creation was successful
                            if (result == true) {
                              subcardController.loadSubcards();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: actionButtonColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.add,
                              color: fisrtHeaderTextColor,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: subcards.length,
                        itemBuilder: (context, index) {
                          final subcard = subcards[index];
                          final cardColor = Color(0xFF479951); // Default green
                          
                          return GestureDetector(
                            onTap: () {
                              _showSubcardDetails(context, subcard, cardColor);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: cardColor.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                            child: CustomTextWidget(
                                              text: 'SUB',
                                              fontSize: 10.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            width: 40.w,
                                            height: 30.h,
                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20.h),
                                      CustomTextWidget(
                                        text: subcard.name,
                                        fontSize: 18.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      SizedBox(height: 8.h),
                                      CustomTextWidget(
                                        text: '•••• •••• •••• ${subcard.sk.substring(subcard.sk.length - 4)}',
                                        fontSize: 14.sp,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CustomTextWidget(
                                                text: 'Spending Limit',
                                                fontSize: 10.sp,
                                                color: Colors.white.withOpacity(0.7),
                                              ),
                                              CustomTextWidget(
                                                text: '${subcardController.selectedCurrencySymbol}${subcard.spendingLimit}',
                                                fontSize: 16.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              CustomTextWidget(
                                                text: 'Expires',
                                                fontSize: 10.sp,
                                                color: Colors.white.withOpacity(0.7),
                                              ),
                                              CustomTextWidget(
                                                text: '${subcard.expirationDate.day}/${subcard.expirationDate.month}',
                                                fontSize: 14.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
