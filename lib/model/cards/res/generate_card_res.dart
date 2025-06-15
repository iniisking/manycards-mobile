class GenerateCardRes {
  final bool error;
  final bool success;
  final String message;
  final Data data;

  GenerateCardRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  factory GenerateCardRes.fromJson(Map<String, dynamic> json) {
    return GenerateCardRes(
      error: json['error'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  final String cardId;
  final String userId;
  final String currency;
  final double balance;
  final String cardType;
  final String network;
  final String maskedNumber;
  final String expiry;
  final bool isActive;
  final bool isLocked;
  final DateTime createdAt;

  Data({
    required this.cardId,
    required this.userId,
    required this.currency,
    required this.balance,
    required this.cardType,
    required this.network,
    required this.maskedNumber,
    required this.expiry,
    required this.isActive,
    required this.isLocked,
    required this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      cardId: json['card_id'] ?? '',
      userId: json['user_id'] ?? '',
      currency: json['currency'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      cardType: json['card_type'] ?? '',
      network: json['network'] ?? '',
      maskedNumber: json['masked_number'] ?? '',
      expiry: json['expiry'] ?? '',
      isActive: json['is_active'] ?? false,
      isLocked: json['is_locked'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
