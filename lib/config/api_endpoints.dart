class ApiEndpoints {
  //authentication endpoints
  static const String signUp =
      'https://5tbf0gkug4.execute-api.us-east-1.amazonaws.com/prod/signup';
  static const String confirmSignUp =
      'https://5tbf0gkug4.execute-api.us-east-1.amazonaws.com/prod/confirm-signup';
  static const String login =
      'https://dy3dlxbv5h.execute-api.us-east-1.amazonaws.com/prod/login';
  static const String forgotPassword =
      'https://zosnt5scng.execute-api.us-east-1.amazonaws.com/prod/forgot-password';
  static const String confirmForgotPassword =
      'https://zosnt5scng.execute-api.us-east-1.amazonaws.com/prod/confirm-forgot-password';

  static const String baseUrl =
      'https://mn5rfaqybd.execute-api.us-east-1.amazonaws.com/prod';

  // Card endpoints
  static const String getAllCards = '$baseUrl/list-all-cards';
  static const String generateCard = '$baseUrl/generate-card';
  static const String getCardById = '$baseUrl/get-card';
  static const String transferFunds = '$baseUrl/transfer-funds';
  static const String lockCard = '$baseUrl/lock-card';

  // Sub-card endpoints
  static const String createSubcard = '$baseUrl/create-sub-card';
  static const String getAllSubcards = '$baseUrl/get-all-sub-cards';
  static const String getSubcardById = '$baseUrl/get-sub-card';
  static const String updateSubcard = '$baseUrl/update-sub-card';

  // Currency endpoints
  static const String getTotalBalance = '$baseUrl/total-balance';
  static const String convertCurrency = '$baseUrl/convert';

  // Payment endpoints
  static const String fundAccount = '$baseUrl/fund-account';
  static const String paystackWebhook = '$baseUrl/paystack-webhook';

  // Transaction endpoints
  static const String getAllTransactions = '$baseUrl/get-all-transactions';
}
