class LoginRes {
  final bool error;
  final bool success;
  final String message;
  final Data data;

  LoginRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginRes.fromJson(Map<String, dynamic> json) {
    return LoginRes(
      error: json['error'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }
}

class Data {
  final String idToken;
  final String refreshToken;
  final String accessToken;
  final int expiresIn;
  final String tokenType;
  final String email;

  Data({
    required this.idToken,
    required this.refreshToken,
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
    required this.email,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      idToken: json['idToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      accessToken: json['accessToken'] ?? '',
      expiresIn: json['expiresIn'] ?? 0,
      tokenType: json['tokenType'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
