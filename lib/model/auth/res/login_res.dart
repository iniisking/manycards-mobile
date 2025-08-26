class LoginRes {
  final bool success;
  final String? token;
  final String? ngnCardId;
  final String message;
  final Data? data;

  LoginRes({
    required this.success,
    this.token,
    this.ngnCardId,
    required this.message,
    this.data,
  });

  factory LoginRes.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return LoginRes(
      success: json['success'] as bool,
      token: data?['id_token'] as String?,
      ngnCardId: data?['ngn_card_id'] as String?,
      message: json['message'] as String,
      data: data != null ? Data.fromJson(data) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'ngn_card_id': ngnCardId,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  final String idToken;
  final String refreshToken;
  final String accessToken;
  final int expiresIn;
  final String tokenType;
  final String email;
  final String? ngnCardId;

  Data({
    required this.idToken,
    required this.refreshToken,
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
    required this.email,
    this.ngnCardId,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      idToken: json['id_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      accessToken: json['access_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
      tokenType: json['token_type'] ?? '',
      email: json['email'] ?? '',
      ngnCardId: json['ngn_card_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_token': idToken,
      'refresh_token': refreshToken,
      'access_token': accessToken,
      'expires_in': expiresIn,
      'token_type': tokenType,
      'email': email,
      'ngn_card_id': ngnCardId,
    };
  }
}
