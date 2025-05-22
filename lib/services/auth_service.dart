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

class AuthService extends BaseApiService {
  final StorageService _storageService;
  static const String _tokenKey = 'cognito_id_token';

  AuthService({required super.client, StorageService? storageService})
    : _storageService = storageService ?? StorageService();

  Future<void> setAuthToken(String token) async {
    await _storageService.saveToken(_tokenKey, token);
  }

  Future<String?> getAuthToken() async {
    return await _storageService.getToken(_tokenKey);
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
