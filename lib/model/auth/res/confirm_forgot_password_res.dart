class ConfirmForgotPasswordRes {
  final bool error;
  final bool success;
  final String message;
  final dynamic data;

  ConfirmForgotPasswordRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConfirmForgotPasswordRes.fromJson(Map<String, dynamic> json) {
    return ConfirmForgotPasswordRes(
      error: json['error'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
