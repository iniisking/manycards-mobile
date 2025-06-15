class ApiEndpoints {
  //authentication endpoints
  static const String signUp =
      'https://cpah6106v7.execute-api.us-east-1.amazonaws.com/prod/signup';
  static const String confirmSignUp =
      'https://cpah6106v7.execute-api.us-east-1.amazonaws.com/prod/confirm-signup';
  static const String login =
      'https://rqr7k2vd9k.execute-api.us-east-1.amazonaws.com/prod/login';
  static const String forgotPassword =
      'https://dlyu9xdhg9.execute-api.us-east-1.amazonaws.com/prod/forgot-password';
  static const String confirmForgotPassword =
      'https://dlyu9xdhg9.execute-api.us-east-1.amazonaws.com/prod/confirm-forgot-password';

  //card endpoints
  static const String getAllCards =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/list-all-cards';
  static const String generateCard =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/generate-card';
  static const String getCardById =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/get-card';
  static const String transferFunds =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/transfer-funds';
  static const String lockCard =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/lock-card';

  //subcard endpoints
  static const String createSubcard =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/create-sub-card';
  static const String getAllSubcards =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/get-all-sub-cards';
  static const String getSubcardById =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/get-sub-card-id';
  static const String updateSubcard =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/update-sub-card';

  //currency endpoints
  static const String getTotalBalance =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/total-balance';

  static const String convertCurrency =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/convert';

  //payment endpoints
  static const String fundAccount =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/fund-account';
  static const String paystackWebhook =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/paystack-webhook';
}
