// ignore_for_file: avoid_print

import 'package:manycards/config/api_endpoints.dart';
import 'package:manycards/model/auth/req/confirm_sign_up_req.dart';
import 'package:manycards/model/auth/req/sign_up_req.dart';
import 'package:manycards/model/auth/res/confirm_forgot_password_res.dart';
import 'package:manycards/model/auth/res/confirm_sign_up_res.dart';
import 'package:manycards/model/auth/res/forgot_password_res.dart';
import 'package:manycards/model/auth/res/login_res.dart';
import 'package:manycards/model/auth/res/sign_up_res.dart';
import 'package:manycards/services/base_api_service.dart';
import 'package:manycards/services/storage_service.dart';
import 'dart:convert';

class AuthService extends BaseApiService {
  final StorageService _storageService;
  static const String _tokenKey = 'cognito_id_token';

  AuthService({required super.client, StorageService? storageService})
    : _storageService = storageService ?? StorageService();

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

      return claims;
    } catch (e) {
      print('Error decoding token: $e');
      return null;
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
          // TODO: Implement token refresh
          await clearAuthToken();
          return null;
        }
      }
    }
    return token;
  }

  Future<void> clearAuthToken() async {
    await _storageService.deleteToken(_tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null;
  }

  Future<void> refreshToken() async {
    throw UnimplementedError('Token refresh not implemented');
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
    final response = await post(
      ApiEndpoints.confirmSignUp,
      body: {'email': request.email, 'code': request.code},
    );

    return ConfirmSignUpRes.fromJson(response);
  }

  Future<LoginRes> login({
    required String email,
    required String password,
  }) async {
    final response = await post(
      ApiEndpoints.login,
      body: {'email': email, 'password': password},
      requiresAuth: false,
    );

    final loginResponse = LoginRes.fromJson(response);

    if (loginResponse.success) {
      print('Login successful, received tokens:');
      print('ID Token: ${loginResponse.data.idToken.substring(0, 20)}...');
      print(
        'Access Token: ${loginResponse.data.accessToken.substring(0, 20)}...',
      );

      // Decode and print claims for both tokens
      final idTokenClaims = _decodeToken(loginResponse.data.idToken);
      final accessTokenClaims = _decodeToken(loginResponse.data.accessToken);

      print('ID Token claims: $idTokenClaims');
      print('Access Token claims: $accessTokenClaims');

      // Store the ID token
      await setAuthToken(loginResponse.data.idToken);
    }

    return loginResponse;
  }

  Future<ForgotPasswordRes> forgotPassword({required String email}) async {
    final response = await post(
      ApiEndpoints.forgotPassword,
      body: {'email': email},
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
    );
    return ConfirmForgotPasswordRes.fromJson(response);
  }

  Future<void> logout() async {
    await clearAuthToken();
  }

  // Future<void> resendVerificationEmail() async {
  //   // TODO: Implement resend verification email API call
  //   throw UnimplementedError('Resend verification email not implemented yet');
  // }
}
