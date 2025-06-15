// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manycards/view/authentication/new_password_screen.dart';
import 'package:manycards/view/constants/text/text.dart';
import 'package:manycards/view/constants/widgets/button.dart';
import 'package:manycards/view/constants/widgets/colors.dart';
import 'package:provider/provider.dart';
import 'package:manycards/controller/auth_controller.dart';

class ConfirmReset extends StatefulWidget {
  const ConfirmReset({super.key});

  @override
  State<ConfirmReset> createState() => _ConfirmResetState();
}

class _ConfirmResetState extends State<ConfirmReset> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Method to handle pasting OTP
  void _handlePaste() async {
    ClipboardData? clipboardData = await Clipboard.getData(
      Clipboard.kTextPlain,
    );
    if (clipboardData != null &&
        clipboardData.text != null &&
        clipboardData.text!.isNotEmpty) {
      // Extract only digits from pasted text
      String pastedText = clipboardData.text!.replaceAll(RegExp(r'\D'), '');

      if (pastedText.isEmpty) return;

      // Take only up to 6 digits since this is a 6-digit OTP
      if (pastedText.length > 6) {
        pastedText = pastedText.substring(0, 6);
      }

      // Update UI with the pasted digits
      setState(() {
        // Clear existing values first
        for (var controller in _controllers) {
          controller.clear();
        }

        // Distribute pasted digits
        for (int i = 0; i < pastedText.length; i++) {
          _controllers[i].text = pastedText[i];
        }
      });

      // Move focus to appropriate field or unfocus if all fields filled
      if (pastedText.length < 6) {
        _focusNodes[pastedText.length].requestFocus();
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  Widget _buildOTPField(int index) {
    return SizedBox(
      height: 55.h,
      width: 50.w,
      child: TextFormField(
        cursorColor: fisrtHeaderTextColor,
        autofocus: index == 0,
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Only accept digits
            final filtered = value.replaceAll(RegExp(r'\D'), '');
            _controllers[index].text = filtered;
            _controllers[index].selection = TextSelection.fromPosition(
              TextPosition(offset: _controllers[index].text.length),
            );
            if (filtered.length == 1 && index < 5) {
              _focusNodes[index + 1].requestFocus();
            }
          } else if (value.isEmpty && index > 0) {
            // Move focus to previous field without clearing it
            _focusNodes[index - 1].requestFocus();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: fisrtHeaderTextColor,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: secondHeadTextColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: secondHeadTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: fisrtHeaderTextColor),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        contextMenuBuilder: (context, editableTextState) {
          final List<ContextMenuButtonItem> buttonItems =
              editableTextState.contextMenuButtonItems;

          final int pasteButtonIndex = buttonItems.indexWhere(
            (item) => item.type == ContextMenuButtonType.paste,
          );

          if (pasteButtonIndex >= 0) {
            buttonItems[pasteButtonIndex] = ContextMenuButtonItem(
              onPressed: _handlePaste,
              type: ContextMenuButtonType.paste,
            );
          }

          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: buttonItems,
          );
        },
      ),
    );
  }

  bool get _isCodeComplete => _controllers.every((c) => c.text.isNotEmpty);

  Future<void> _verifyCode() async {
    if (!_isCodeComplete) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      final code = _controllers.map((c) => c.text).join();

      // Navigate to new password screen with the code
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => NewPasswordScreen(
                  email: authController.lastEmail ?? '',
                  code: code,
                ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final email = authController.lastEmail;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: fisrtHeaderTextColor),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 16.h),
              CustomTextWidget(
                text: 'Reset Password',
                fontSize: 20.sp,
                color: fisrtHeaderTextColor,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 8.h),
              CustomTextWidget(
                text: 'Please enter the code sent to $email',
                fontSize: 12.sp,
                color: secondHeadTextColor,
                fontWeight: FontWeight.normal,
              ),
              SizedBox(height: 25.h),
              CustomTextWidget(
                text: 'Code',
                fontSize: 14.sp,
                color: fisrtHeaderTextColor,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 24.h),
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _buildOTPField(index)),
                ),
              ),
              SizedBox(height: 32.h),
              CustomButton(
                text: _isVerifying ? 'Verifying...' : 'Continue',
                onTap: _isCodeComplete && !_isVerifying ? _verifyCode : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
