class SignUpRes {
  final bool error;
  final bool success;
  final String message;
  final dynamic data;

  SignUpRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  factory SignUpRes.fromJson(Map<String, dynamic> json) {
    return SignUpRes(
      error: json['error'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
