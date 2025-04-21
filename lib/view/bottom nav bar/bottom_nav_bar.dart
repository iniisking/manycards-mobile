// Updated BottomNavBar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/gen/assets.gen.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: 40.h),
        child: Container(
          height: 60.h,
          width: 290.w,
          decoration: BoxDecoration(
            color: const Color(0xDD252525), // Slightly transparent
            borderRadius: BorderRadius.circular(40.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                index: 0,
                isSelected: selectedIndex == 0,
                icon: Assets.images.home.image(
                  height: 27.h,
                  width: 27.w,
                  color:
                      selectedIndex == 0
                          ? const Color(0xFFEAEAEA)
                          : const Color(0xFF606060),
                ),
              ),
              _buildNavItem(
                index: 1,
                isSelected: selectedIndex == 1,
                icon: Assets.images.card.image(
                  height: 30.h,
                  width: 30.w,
                  color:
                      selectedIndex == 1
                          ? const Color(0xFFEAEAEA)
                          : const Color(0xFF606060),
                ),
              ),
              _buildNavItem(
                index: 2,
                isSelected: selectedIndex == 2,
                icon: Assets.images.transactionHistory.image(
                  height: 27.h,
                  width: 27.w,
                  color:
                      selectedIndex == 2
                          ? const Color(0xFFEAEAEA)
                          : const Color(0xFF606060),
                ),
              ),
              _buildNavItem(
                index: 3,
                isSelected: selectedIndex == 3,
                icon: Assets.images.setting.image(
                  height: 27.h,
                  width: 27.w,
                  color:
                      selectedIndex == 3
                          ? const Color(0xFFEAEAEA)
                          : const Color(0xFF606060),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required Widget icon,
    required bool isSelected,
  }) {
    return GestureDetector(onTap: () => onItemTapped(index), child: icon);
  }
}
