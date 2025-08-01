import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  //authentication endpoints
  static String get signUp => dotenv.env['AUTH_SIGNUP_URL'] ?? '';
  static String get confirmSignUp => dotenv.env['AUTH_CONFIRM_SIGNUP_URL'] ?? '';
  static String get login => dotenv.env['AUTH_LOGIN_URL'] ?? '';
  static String get forgotPassword => dotenv.env['AUTH_FORGOT_PASSWORD_URL'] ?? '';
  static String get confirmForgotPassword => dotenv.env['AUTH_CONFIRM_FORGOT_PASSWORD_URL'] ?? '';

  // Token refresh endpoint
  static String get refreshToken => dotenv.env['AUTH_REFRESH_TOKEN_URL'] ?? '';
  
  // Resend verification email endpoint
  static String get resendVerificationEmail => dotenv.env['AUTH_RESEND_VERIFICATION_EMAIL_URL'] ?? '';

  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? '';

  // Card endpoints
  static String get getAllCards => '$baseUrl/list-all-cards';
  static String get generateCard => '$baseUrl/generate-card';
  static String get getCardById => '$baseUrl/get-card';
  static String get transferFunds => '$baseUrl/transfer-funds';
  static String get lockCard => '$baseUrl/lock-card';

  // Sub-card endpoints
  static String get createSubcard => '$baseUrl/create-sub-card';
  static String get getAllSubcards => '$baseUrl/get-all-sub-cards';
  static String get getSubcardById => '$baseUrl/get-sub-card';
  static String get updateSubcard => '$baseUrl/update-sub-card';
  static String get deleteSubcard => '$baseUrl/delete-sub-card';

  // Currency endpoints
  static String get getTotalBalance => '$baseUrl/total-balance';
  static String get convertCurrency => '$baseUrl/convert';

  // Payment endpoints
  static String get fundAccount => '$baseUrl/fund-account';
  static String get paystackWebhook => '$baseUrl/paystack-webhook';

  // Transaction endpoints
  static String get getAllTransactions => '$baseUrl/list-transactions';
}
