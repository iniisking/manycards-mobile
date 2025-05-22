// lib/screens/auth_wrapper.dart
// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:manycards/controller/auth_controller.dart';
import 'package:manycards/view/authentication/login_screen.dart';
import 'package:manycards/view/authentication/verify_email.dart';
import 'package:manycards/view/bottom%20nav%20bar/main_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    // Debug print
    debugPrint(
      'AuthWrapper rebuild: isLoggedIn=${authController.isLoggedIn}, user=${authController.user?.email}, isEmailVerified=${authController.isEmailVerified}',
    );

    // Show loading indicator while initializing
    if (authController.isLoading) {
      debugPrint('AuthWrapper: Showing loading indicator');
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Redirect based on auth state
    if (authController.isLoggedIn) {
      if (!authController.isEmailVerified) {
        debugPrint(
          'AuthWrapper: User is logged in but not verified, showing VerifyEmailScreen',
        );
        return const VerifyEmailScreen();
      }
      debugPrint(
        'AuthWrapper: User is logged in and verified, showing MainScreen',
      );
      return const MainScreen();
    } else {
      debugPrint('AuthWrapper: User is not logged in, showing LoginScreen');
      return const LoginScreen();
    }
  }
}
