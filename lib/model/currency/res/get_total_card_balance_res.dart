class GetTotalBalanceRes {
  final bool error;
  final bool success;
  final String message;
  final Data data;

  GetTotalBalanceRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetTotalBalanceRes.fromJson(Map<String, dynamic> json) {
    return GetTotalBalanceRes(
      error: json['error'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }
}

class Data {
  final double totalBalance;
  final String targetCurrency;
  final int cardCount;
  final List<CardBalance> cardBalances;

  Data({
    required this.totalBalance,
    required this.targetCurrency,
    required this.cardCount,
    required this.cardBalances,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      totalBalance: (json['total_balance'] ?? 0.0).toDouble(),
      targetCurrency: json['target_currency'] ?? '',
      cardCount: json['card_count'] ?? 0,
      cardBalances:
          (json['card_balances'] as List<dynamic>?)
              ?.map((e) => CardBalance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CardBalance {
  final String cardId;
  final double originalBalance;
  final String originalCurrency;
  final double convertedBalance;
  final String targetCurrency;

  CardBalance({
    required this.cardId,
    required this.originalBalance,
    required this.originalCurrency,
    required this.convertedBalance,
    required this.targetCurrency,
  });

  factory CardBalance.fromJson(Map<String, dynamic> json) {
    return CardBalance(
      cardId: json['card_id'] ?? '',
      originalBalance: (json['original_balance'] ?? 0.0).toDouble(),
      originalCurrency: json['original_currency'] ?? '',
      convertedBalance: (json['converted_balance'] ?? 0.0).toDouble(),
      targetCurrency: json['target_currency'] ?? '',
    );
  }
}
