class ForgotPasswordRes {
  final bool error;
  final bool success;
  final String message;
  final dynamic data;

  ForgotPasswordRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ForgotPasswordRes.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRes(
      error: json['error'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
