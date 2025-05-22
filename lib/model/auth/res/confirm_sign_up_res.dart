class ConfirmSignUpRes {
  final bool error;
  final bool success;
  final String message;
  final dynamic data;

  ConfirmSignUpRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConfirmSignUpRes.fromJson(Map<String, dynamic> json) {
    return ConfirmSignUpRes(
      error: json['error'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}
