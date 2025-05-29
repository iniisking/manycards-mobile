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
  final int totalBalance;
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
      totalBalance: json['totalBalance'] ?? 0,
      targetCurrency: json['targetCurrency'] ?? '',
      cardCount: json['cardCount'] ?? 0,
      cardBalances:
          (json['cardBalances'] as List<dynamic>?)
              ?.map((e) => CardBalance.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CardBalance {
  final dynamic cardId;
  final int originalBalance;
  final String originalCurrency;
  final int convertedBalance;
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
      cardId: json['cardId'],
      originalBalance: json['originalBalance'] ?? 0,
      originalCurrency: json['originalCurrency'] ?? '',
      convertedBalance: json['convertedBalance'] ?? 0,
      targetCurrency: json['targetCurrency'] ?? '',
    );
  }
}
