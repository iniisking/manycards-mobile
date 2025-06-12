import 'package:flutter/material.dart';
import 'package:manycards/model/auth/req/confirm_sign_up_req.dart';
import 'package:manycards/model/auth/req/sign_up_req.dart';
import 'package:manycards/model/auth/res/login_res.dart';
import 'package:manycards/services/auth_service.dart';
import 'package:manycards/services/card_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthController extends ChangeNotifier {
  final AuthService _authService;
  final CardService _cardService;
  final SharedPreferences _prefs;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  bool _isEmailVerified = false;
  String? _error;
  LoginRes? _user;
  String? _lastEmail;
  String? _firstName;
  String? _lastPassword;

  static const String _firstNameKey = 'user_first_name';

  AuthController(
    this._authService,
    this._cardService, {
    SharedPreferences? prefs,
  }) : _prefs =
           prefs ?? (throw Exception('SharedPreferences must be provided')) {
    _initializeAuthState();
  }

  // Getters
  AuthService get authService => _authService;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  bool get isEmailVerified => _isEmailVerified;
  String? get error => _error;
  LoginRes? get user => _user;
  String? get lastEmail => _lastEmail;
  String get firstName => _firstName ?? 'User';

  // Add a public getter for the auth token
  Future<String?> get authToken async => await _authService.getAuthToken();

  // Decode JWT token
  Map<String, dynamic>? _decodeToken(String token) {
    try {
      debugPrint('Attempting to decode token...');
      final parts = token.split('.');
      if (parts.length != 3) {
        debugPrint(
          'Invalid token format: expected 3 parts, got ${parts.length}',
        );
        return null;
      }

      // Decode the payload (second part)
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final claims = json.decode(decoded) as Map<String, dynamic>;

      debugPrint('Token claims: $claims');
      debugPrint('Given name from token: ${claims['given_name']}');

      return claims;
    } catch (e) {
      debugPrint('Error decoding token: $e');
      return null;
    }
  }

  // Initialize auth state
  Future<void> _initializeAuthState() async {
    _setLoading(true);
    try {
      _isLoggedIn = await _authService.isLoggedIn();
      if (_isLoggedIn) {
        final token = await _authService.getAuthToken();
        if (token != null) {
          final claims = _decodeToken(token);
          if (claims != null) {
            _firstName = claims['given_name'] as String?;
            debugPrint('Loaded first name from token: $_firstName');
          }
        }
        _isEmailVerified = true;
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
      // Store password temporarily for login after confirmation
      _lastPassword = password;

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
        _firstName = nameParts[0];
        // Store first name in SharedPreferences
        await _prefs.setString(_firstNameKey, _firstName!);
        debugPrint('Stored first name in SharedPreferences: $_firstName');
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

        // Extract first name from ID token
        final token = response.data.idToken;
        debugPrint('Login successful, token: $token');

        if (token.isNotEmpty) {
          final claims = _decodeToken(token);
          if (claims != null) {
            _firstName = claims['given_name'] as String?;
            debugPrint('Extracted first name from token: $_firstName');
          } else {
            debugPrint('Failed to decode token or extract given_name');
          }
        } else {
          debugPrint('Token is empty');
        }

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

        // Log in the user after successful confirmation
        debugPrint('Logging in user after confirmation...');
        final loginResponse = await _authService.login(
          email: email,
          password:
              _lastPassword ?? '', // We need to store the password temporarily
        );

        if (loginResponse.success) {
          _user = loginResponse;
          _isLoggedIn = true;

          // Now generate initial cards with valid authentication
          try {
            debugPrint('Generating initial cards for new user...');
            await _cardService.generateInitialCards();
            debugPrint('Initial cards generated successfully');
          } catch (e) {
            debugPrint('Error generating initial cards: $e');
            // Don't fail the signup if card generation fails
            // The user can retry card generation later
          }
        } else {
          _setError('Failed to log in after confirmation');
          return false;
        }

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
      // Clear first name from SharedPreferences
      await _prefs.remove(_firstNameKey);
      debugPrint('Cleared first name from SharedPreferences');
      _user = null;
      _firstName = null;
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
    if (isEmpty) return '';
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
