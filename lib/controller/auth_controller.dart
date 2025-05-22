import 'package:flutter/material.dart';
import 'package:manycards/model/auth/req/confirm_sign_up_req.dart';
import 'package:manycards/model/auth/req/sign_up_req.dart';
import 'package:manycards/model/auth/res/login_res.dart';
import 'package:manycards/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _isEmailVerified = false;
  String? _error;
  LoginRes? _user;
  String? _lastEmail;

  AuthController(this._authService) {
    _initializeAuthState();
  }

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get isEmailVerified => _isEmailVerified;
  String? get error => _error;
  LoginRes? get user => _user;
  String? get lastEmail => _lastEmail;
  String get firstName =>
      user?.data.email.split('@')[0].split('.')[0].capitalize() ?? 'User';

  // Initialize auth state
  Future<void> _initializeAuthState() async {
    _setLoading(true);
    try {
      _isLoggedIn = await _authService.isLoggedIn();
      if (_isLoggedIn) {
        // TODO: Implement token validation and email verification check
        _isEmailVerified =
            true; // This should be set based on actual verification status
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Sign Up with full name
  Future<bool> signUp(String fullName, String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      // Split full name into first and last name
      final nameParts = fullName.trim().split(' ');
      if (nameParts.length != 2) {
        _setError('Please enter your full name (first and last name)');
        return false;
      }

      final request = SignUpReq(
        email: email,
        firstName: nameParts[0],
        lastName: nameParts[1],
        password: password,
      );

      final response = await _authService.signUp(request);
      if (response.success) {
        _lastEmail = email;
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Sign In
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );
      if (response.success) {
        _user = response;
        _isLoggedIn = true;
        _isEmailVerified = true;
        notifyListeners();
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Confirm Sign Up
  Future<bool> confirmSignUp(String email, String code) async {
    _setLoading(true);
    _clearError();
    try {
      final request = ConfirmSignUpReq(email: email, code: code);
      final response = await _authService.confirmSignUp(request);
      if (response.success) {
        _isEmailVerified = true;
        notifyListeners();
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Check Email Verification
  Future<void> checkEmailVerification() async {
    _setLoading(true);
    _clearError();
    try {
      await Future.delayed(const Duration(seconds: 1));
      _isEmailVerified = true;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Resend Verification Email
  Future<void> resendVerificationEmail() async {
    _setLoading(true);
    _clearError();
    try {
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = null;
      _isLoggedIn = false;
      _isEmailVerified = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Sign Out (alias for logout)
  Future<void> signOut() async => logout();

  // Reset Password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    try {
      // TODO: Implement actual password reset API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      _lastEmail = email;
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Google Sign In
  Future<void> signInWithGoogle(BuildContext context) async {
    _setLoading(true);
    _clearError();
    try {
      // TODO: Implement Google Sign In
      throw UnimplementedError('Google Sign In not implemented yet');
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
