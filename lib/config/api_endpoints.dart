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
  static const String getCard =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/get-card';
  static const String createSubcard =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/create-sub-card';

  //currency endpoints
  static const String getTotalBalance =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/total-balance';

  static const String convertCurrency =
      'https://0o9v8c0su1.execute-api.us-east-1.amazonaws.com/prod/convert';
}
