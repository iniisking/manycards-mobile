// lib/screens/auth_wrapper.dart
// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:manycards/controller/auth_controller.dart';
import 'package:manycards/view/authentication/login_screen.dart';
import 'package:manycards/view/authentication/verify_email.dart';
import 'package:manycards/view/bottom%20nav%20bar/main_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize auth state when the widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = context.read<AuthController>();
      authController.initializeAuthState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    // Debug print
    debugPrint(
      'AuthWrapper rebuild: isLoggedIn=${authController.isLoggedIn}, user=${authController.authService.email}, isEmailVerified=${authController.isEmailVerified}',
    );

    // Show loading indicator while initializing
    if (authController.isLoading) {
      debugPrint('AuthWrapper: Showing loading indicator');
      String loadingMessage = 'Loading...';
      // You can add more logic here to personalize the message
      if (authController.error == null) {
        if (authController.isLoggedIn == false && authController.user == null) {
          loadingMessage = 'Logging in...';
        } else if (authController.isLoggedIn == false && authController.user != null) {
          loadingMessage = 'Logging out...';
        } else {
          loadingMessage = 'Loading...';
        }
      } else {
        loadingMessage = 'Loading...';
      }
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                loadingMessage,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      );
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
