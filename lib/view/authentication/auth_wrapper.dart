// lib/screens/auth_wrapper.dart
// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:manycards/controller/auth_controller.dart';
import 'package:manycards/view/authentication/login_screen.dart';
import 'package:manycards/view/bottom%20nav%20bar/main_screen.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  // In AuthWrapper
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    // Debug print
    print(
      'AuthWrapper rebuild: isLoggedIn=${authController.isLoggedIn}, user=${authController.user?.email}',
    );

    // Show loading indicator while initializing
    if (authController.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Redirect based on auth state
    if (authController.isLoggedIn) {
      return MainScreen();
    } else {
      return LoginScreen();
    }
  }
}
