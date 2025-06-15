class PaystackWebhookRes {
  final bool success;
  final String message;
  final double newBalance;
  final String reference;

  PaystackWebhookRes({
    required this.success,
    required this.message,
    required this.newBalance,
    required this.reference,
  });

  factory PaystackWebhookRes.fromJson(Map<String, dynamic> json) {
    return PaystackWebhookRes(
      success: json['success'] as bool,
      message: json['message'] as String,
      newBalance: (json['new_balance'] as num).toDouble(),
      reference: json['reference'] as String,
    );
  }
}
