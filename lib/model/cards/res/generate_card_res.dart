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
}

class Data {
  final String cardId;
  final String userId;
  final String currency;
  final String cardType;
  final String network;
  final String maskedNumber;
  final String expiry;
  final bool isActive;
  final DateTime createdAt;
  final int balance;

  Data({
    required this.cardId,
    required this.userId,
    required this.currency,
    required this.cardType,
    required this.network,
    required this.maskedNumber,
    required this.expiry,
    required this.isActive,
    required this.createdAt,
    required this.balance,
  });
}
