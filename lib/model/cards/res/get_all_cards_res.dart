class GetAllCardsRes {
  final bool error;
  final bool success;
  final String message;
  final Data data;

  GetAllCardsRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetAllCardsRes.fromJson(Map<String, dynamic> json) {
    return GetAllCardsRes(
      error: json['error'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }
}

class Data {
  final List<Card> cards;
  final int count;

  Data({required this.cards, required this.count});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      cards:
          (json['cards'] as List<dynamic>?)
              ?.map((e) => Card.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      count: json['count'] ?? 0,
    );
  }
}

class Card {
  final String currency;
  final String cvv;
  final DateTime createdAt;
  final String cardType;
  final String network;
  final double balance;
  final String userId;
  final String number;
  final String sk;
  final bool isActive;
  final String expiry;
  final String pk;
  final String maskedNumber;

  Card({
    required this.currency,
    required this.cvv,
    required this.createdAt,
    required this.cardType,
    required this.network,
    required this.balance,
    required this.userId,
    required this.number,
    required this.sk,
    required this.isActive,
    required this.expiry,
    required this.pk,
    required this.maskedNumber,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      currency: json['currency'] ?? '',
      cvv: json['cvv'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      cardType: json['card_type'] ?? '',
      network: json['network'] ?? '',
      balance: (json['balance'] ?? 0.0).toDouble(),
      userId: json['user_id'] ?? '',
      number: json['number'] ?? '',
      sk: json['sk'] ?? '',
      isActive: json['is_active'] ?? false,
      expiry: json['expiry'] ?? '',
      pk: json['pk'] ?? '',
      maskedNumber: json['masked_number'] ?? '',
    );
  }
}
