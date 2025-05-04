// lib/providers/auth_provider.dart
// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:manycards/services/auth_service.dart';
import 'package:manycards/services/firestore_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  bool _isLoading = false;
  String _error = '';
  String _lastEmail = '';
  bool _isEmailVerified = false;
  String _lastEmailSent = '';
  String _firstName = '';

  AuthController() {
    debugPrint('AuthController initialized');
    _initializeAuthState();
  }

  Future<void> _initializeAuthState() async {
    debugPrint('Initializing auth state');
    _isLoading = true;
    notifyListeners();

    try {
      // Get the current user
      _user = _authService.currentUser;
      debugPrint('Current user: ${_user?.email}');

      if (_user != null) {
        _isEmailVerified = _user!.emailVerified;
        debugPrint('Email verified: $_isEmailVerified');

        // Get user profile from Firestore
        final userProfile = await _firestoreService.getUserProfile(_user!.uid);
        if (userProfile != null) {
          _firstName = userProfile['firstName'] ?? '';
          debugPrint('Retrieved first name: $_firstName');
        } else {
          debugPrint('No user profile found, using display name');
          _firstName = _user!.displayName?.split(' ').first ?? '';
        }
      }

      // Listen to auth state changes
      _authService.authStateChanges.listen((User? user) async {
        debugPrint('Auth state changed. New user: ${user?.email}');
        _user = user;
        _isEmailVerified = user?.emailVerified ?? false;

        if (user != null) {
          // Get user profile from Firestore when auth state changes
          final userProfile = await _firestoreService.getUserProfile(user.uid);
          if (userProfile != null) {
            _firstName = userProfile['firstName'] ?? '';
            debugPrint(
              'Updated first name from auth state change: $_firstName',
            );
          } else {
            debugPrint(
              'No user profile found in auth state change, using display name',
            );
            _firstName = user.displayName?.split(' ').first ?? '';
          }
        } else {
          _firstName = '';
          debugPrint('User signed out, cleared first name');
        }

        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error initializing auth state: $e');
      _error = 'Error initializing auth state';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Getters
  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get lastEmail => _lastEmail;
  bool get isEmailVerified => _isEmailVerified;
  String get lastEmailSent => _lastEmailSent;
  String get firstName => _firstName;

  // Sign in
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _authService.signIn(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _getUserFriendlyError(e);
      notifyListeners();
      return false;
    }
  }

  // Sign up with full profile
  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = '';
    _lastEmail = email;
    _firstName = firstName;
    notifyListeners();

    try {
      debugPrint('Checking if email is already in use...');
      // Check if user already exists
      final methods = await _authService.getSignInMethods(email);
      if (methods.isNotEmpty) {
        _error = 'An account with this email already exists';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      debugPrint('Creating new user account...');
      // Create the user account
      final userCredential = await _authService.signUp(email, password);

      if (userCredential?.user != null) {
        try {
          debugPrint('Creating user profile in Firestore...');
          // Create user profile in Firestore
          await _firestoreService.createUserProfile(
            userCredential!.user!.uid,
            firstName,
            lastName,
            email,
          );

          debugPrint('Updating display name...');
          // Update display name
          await userCredential.user!.updateDisplayName('$firstName $lastName');

          debugPrint('Sending verification email...');
          // Send verification email
          await userCredential.user!.sendEmailVerification();
          debugPrint('Verification email sent successfully');

          // Update the current user and state
          _user = userCredential.user;
          _isEmailVerified = false;
          _lastEmail = email;
          _firstName = firstName;

          // Ensure state is updated
          _isLoading = false;
          notifyListeners();

          // Wait for state to be fully updated
          await Future.delayed(const Duration(milliseconds: 500));

          debugPrint('Sign-up completed successfully, returning true');
          return true;
        } catch (profileError) {
          debugPrint('Error during profile setup: $profileError');
          // If profile creation fails, delete the user account
          if (userCredential?.user != null) {
            await userCredential!.user!.delete();
          }
          _error = 'Account creation failed. Please try again.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        debugPrint('Failed to create user account');
        _error = 'Failed to create user account';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      _error = _getUserFriendlyError(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
      _firstName = '';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Sign out error: $e');
      _error = 'Error signing out';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear errors
  void clearError() {
    _error = '';
    notifyListeners();
  }

  // Get user-friendly error messages
  String _getUserFriendlyError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'This email is already registered';
        case 'weak-password':
          return 'Password is too weak';
        case 'invalid-email':
          return 'Invalid email address';
        case 'user-not-found':
          return 'No account found with this email';
        case 'wrong-password':
          return 'Incorrect password';
        case 'user-disabled':
          return 'This account has been disabled';
        default:
          return 'An error occurred: ${error.message}';
      }
    }
    return 'An unexpected error occurred';
  }

  Future<void> checkEmailVerification() async {
    try {
      // Reload the user to get the latest verification status
      await _user?.reload();
      _user = _authService.currentUser;
      _isEmailVerified = _user?.emailVerified ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error checking email verification: $e');
      _error = 'Error checking email verification';
      notifyListeners();
    }
  }

  Future<void> resendVerificationEmail() async {
    // TODO: Implement actual email resend
    await Future.delayed(const Duration(seconds: 2));
    _lastEmailSent = 'user@example.com';
    notifyListeners();
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _getUserFriendlyError(e);
      notifyListeners();
      return false;
    }
  }

  // Update password
  Future<bool> updatePassword(String newPassword) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _user?.updatePassword(newPassword);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = _getUserFriendlyError(e);
      notifyListeners();
      return false;
    }
  }
}
