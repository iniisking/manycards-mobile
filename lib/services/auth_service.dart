// ignore_for_file: avoid_print

import 'package:manycards/config/api_endpoints.dart';
import 'package:manycards/model/auth/req/confirm_sign_up_req.dart';
import 'package:manycards/model/auth/req/login_req.dart';
import 'package:manycards/model/auth/req/sign_up_req.dart';
import 'package:manycards/model/auth/res/confirm_forgot_password_res.dart';
import 'package:manycards/model/auth/res/confirm_sign_up_res.dart';
import 'package:manycards/model/auth/res/forgot_password_res.dart';
import 'package:manycards/model/auth/res/login_res.dart';
import 'package:manycards/model/auth/res/sign_up_res.dart';
import 'package:manycards/services/base_api_service.dart';
import 'package:manycards/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:manycards/services/card_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends BaseApiService {
  final StorageService _storageService;
  final SharedPreferences _prefs;

  AuthService({
    required super.client,
    required StorageService storageService,
    required SharedPreferences prefs,
  }) : _storageService = storageService,
       _prefs = prefs;

  static String get _tokenKey => dotenv.env['STORAGE_AUTH_TOKEN_KEY'] ?? 'auth_token';
  static String get _ngnCardIdKey => dotenv.env['STORAGE_NGN_CARD_ID_KEY'] ?? 'ngn_card_id';
  String? _token;
  String? _ngnCardId;
  String? _userId;
  String? _email;
  String? _phone;

  String? get token => _token;
  String? get ngnCardId => _ngnCardId;
  String? get userId => _userId;
  String? get email => _email;
  String? get phone => _phone;

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return date.toUtc().toString();
  }

  Map<String, dynamic>? _decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Invalid token format');
        return null;
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final claims = json.decode(decoded);

      // Add formatted timestamps for debugging
      if (claims['auth_time'] != null) {
        print('Token auth_time: ${_formatTimestamp(claims['auth_time'])}');
      }
      if (claims['exp'] != null) {
        print('Token expiration: ${_formatTimestamp(claims['exp'])}');
      }
      if (claims['iat'] != null) {
        print('Token issued at: ${_formatTimestamp(claims['iat'])}');
      }
      print('Current time: ${DateTime.now().toUtc()}');

      // Update user data from token
      _userId = claims['sub'] as String?;
      _email = claims['email'] as String?;
      _phone = claims['phone_number'] as String?;

      return claims;
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }

  Future<void> initialize() async {
    _token = _prefs.getString(_tokenKey);
    _ngnCardId = await _storageService.getToken(_ngnCardIdKey);

    if (_token != null) {
      _decodeToken(_token!);

      // If we have a token but no NGN card ID, try to fetch it
      if (_ngnCardId == null) {
        try {
          final cardService = CardService(client: client, authService: this);
          final cards = await cardService.getAllCards();
          final ngnCard = cards.data.firstWhere(
            (card) => card.currency == 'NGN',
            orElse: () => throw Exception('No NGN card found'),
          );
          _ngnCardId = ngnCard.cardId;
          print('Found NGN card ID from cards: $_ngnCardId');

          if (_ngnCardId != null) {
            await _prefs.setString(_ngnCardIdKey, _ngnCardId!);
            await _storageService.saveToken(_ngnCardIdKey, _ngnCardId!);
            print('NGN card ID set in AuthService: $_ngnCardId');
          }
        } catch (e) {
          print('Error getting NGN card ID during initialization: $e');
        }
      }
    }
  }

  Future<void> setAuthToken(String token) async {
    final claims = _decodeToken(token);
    print('Setting token with claims: $claims');
    if (claims != null) {
      print('Token type: ${claims['token_use']}');
    }
    await _storageService.saveToken(_tokenKey, token);
  }

  Future<String?> getAuthToken() async {
    final token = await _storageService.getToken(_tokenKey);
    if (token != null) {
      final claims = _decodeToken(token);
      print('Retrieved token with claims: $claims');
      if (claims != null) {
        print('Token type: ${claims['token_use']}');

        // Check if token is expired
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        if (claims['exp'] != null && claims['exp'] < now) {
          print(
            'Token is expired! Current time: ${_formatTimestamp(now)}, Expiration: ${_formatTimestamp(claims['exp'])}',
          );
          // Attempt to refresh the token
          try {
            final refreshedToken = await refreshToken();
            if (refreshedToken != null) {
              print('Token refreshed successfully');
              return refreshedToken;
            } else {
              print('Token refresh failed, clearing auth data');
              await clearAuthToken();
              return null;
            }
          } catch (e) {
            print('Error refreshing token: $e');
            await clearAuthToken();
            return null;
          }
        }
      }
    }
    return token;
  }

  Future<void> clearAuthToken() async {
    await _storageService.deleteToken(_tokenKey);
    await _storageService.deleteToken(_ngnCardIdKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null;
  }

  Future<String?> refreshToken() async {
    try {
      // Call the backend to refresh the token
      // This assumes you have a refresh token endpoint
      final response = await post(
        ApiEndpoints.refreshToken,
        body: {
          'refresh_token': await _storageService.getToken('refresh_token'),
        },
        requiresAuth: false,
      );
      
      if (response['success'] == true && response['token'] != null) {
        final newToken = response['token'] as String;
        
        // Decode and validate the new token
        final claims = _decodeToken(newToken);
        if (claims != null) {
          // Save the new token
          await _storageService.saveToken(_tokenKey, newToken);
          await _prefs.setString(_tokenKey, newToken);
          _token = newToken;
          
          // Save refresh token if provided
          if (response['refresh_token'] != null) {
            await _storageService.saveToken('refresh_token', response['refresh_token']);
          }
          
          print('Token refreshed successfully');
          return newToken;
        }
      }
      
      print('Token refresh failed: Invalid response');
      return null;
    } catch (e) {
      print('Error refreshing token: $e');
      return null;
    }
  }

  Future<SignUpRes> signUp(SignUpReq request) async {
    final response = await post(
      ApiEndpoints.signUp,
      body: {
        'email': request.email,
        'password': request.password,
        'first_name': request.firstName,
        'last_name': request.lastName,
      },
    );

    return SignUpRes.fromJson(response);
  }

  Future<ConfirmSignUpRes> confirmSignUp(ConfirmSignUpReq request) async {
    try {
      print('Confirming signup for email: ${request.email}');
      print('Verification code: ${request.code}');

      final response = await post(
        ApiEndpoints.confirmSignUp,
        body: {'email': request.email, 'code': request.code},
        requiresAuth: false, // Don't require auth for confirmation
      );

      print('Confirm signup response: $response');
      final confirmResponse = ConfirmSignUpRes.fromJson(response);
      print(
        'Parsed confirm response: ${confirmResponse.success} - ${confirmResponse.message}',
      );

      return confirmResponse;
    } catch (e) {
      print('Error in confirmSignUp: $e');
      rethrow;
    }
  }

  Future<LoginRes> login(LoginReq request) async {
    try {
      final response = await post(
        ApiEndpoints.login,
        body: request.toJson(),
        requiresAuth: false,
      );

      print('Login response raw: $response');
      print('Login response data: ${response['data']}');
      print('Login response ngn_card_id: ${response['ngn_card_id']}');

      final loginResponse = LoginRes.fromJson(response);
      print('Parsed login response: ${loginResponse.toJson()}');
      print('Parsed login response data: ${loginResponse.data?.toJson()}');

      if (loginResponse.success) {
        _token = loginResponse.token;

        if (_token != null) {
          _decodeToken(_token!);

          // Save to both SharedPreferences and StorageService
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, _token!);
          await _storageService.saveToken(_tokenKey, _token!);

          // Get the NGN card ID from the list of cards
          try {
            final cardService = CardService(client: client, authService: this);
            final cards = await cardService.getAllCards();
            final ngnCard = cards.data.firstWhere(
              (card) => card.currency == 'NGN',
              orElse: () => throw Exception('No NGN card found'),
            );
            _ngnCardId = ngnCard.cardId;
            print('Found NGN card ID from cards: $_ngnCardId');

            if (_ngnCardId != null) {
              await prefs.setString(_ngnCardIdKey, _ngnCardId!);
              await _storageService.saveToken(_ngnCardIdKey, _ngnCardId!);
              print('NGN card ID set in AuthService: $_ngnCardId');
            }
          } catch (e) {
            print('Error getting NGN card ID: $e');
            // Don't fail the login if we can't get the NGN card ID
            // The user can retry card generation later
          }

          print('Token set in AuthService: $_token');
        }
      }

      return loginResponse;
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<ForgotPasswordRes> forgotPassword({required String email}) async {
    final response = await post(
      ApiEndpoints.forgotPassword,
      body: {'email': email},
      requiresAuth: false, // Don't require auth for password reset
    );
    return ForgotPasswordRes.fromJson(response);
  }

  Future<ConfirmForgotPasswordRes> confirmForgotPassword({
    required String email,
    required String code,
    required String password,
  }) async {
    final response = await post(
      ApiEndpoints.confirmForgotPassword,
      body: {'email': email, 'code': code, 'password': password},
      requiresAuth: false, // Don't require auth for password reset confirmation
    );
    return ConfirmForgotPasswordRes.fromJson(response);
  }

  Future<void> logout() async {
    _token = null;
    _ngnCardId = null;
    _userId = null;
    _email = null;
    _phone = null;

    // Clear from both SharedPreferences and StorageService
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_ngnCardIdKey);
    await _storageService.deleteToken(_tokenKey);

    debugPrint('AuthService: Cleared all auth data');
  }

  @override
  Map<String, String> getHeaders({bool requiresAuth = true}) {
    final headers = super.getHeaders(requiresAuth: requiresAuth);
    if (requiresAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  Future<Map<String, dynamic>> resendVerificationEmail({required String email}) async {
    try {
      final response = await post(
        ApiEndpoints.resendVerificationEmail,
        body: {'email': email},
        requiresAuth: false,
      );
      
      return response;
    } catch (e) {
      print('Error resending verification email: $e');
      rethrow;
    }
  }
}
