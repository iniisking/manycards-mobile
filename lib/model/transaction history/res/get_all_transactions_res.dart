class GetAllTransactionsRes {
  final bool success;
  final Data data;

  GetAllTransactionsRes({required this.success, required this.data});

  factory GetAllTransactionsRes.fromJson(Map<String, dynamic> json) {
    return GetAllTransactionsRes(
      success: json['success'] ?? false,
      data: Data.fromJson(json['data'] ?? {}),
    );
  }
}

class Data {
  final List<Transaction> transactions;
  final int count;
  final dynamic nextToken;
  final Filters filters;

  Data({
    required this.transactions,
    required this.count,
    required this.nextToken,
    required this.filters,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] ?? 0,
      nextToken: json['nextToken'],
      filters: Filters.fromJson(json['filters'] ?? {}),
    );
  }
}

class Filters {
  final dynamic type;
  final dynamic status;
  final dynamic currency;
  final dynamic sourceCurrency;
  final dynamic destinationCurrency;
  final dynamic cardId;
  final dynamic sourceCardId;
  final dynamic destinationCardId;
  final DateRange dateRange;

  Filters({
    required this.type,
    required this.status,
    required this.currency,
    required this.sourceCurrency,
    required this.destinationCurrency,
    required this.cardId,
    required this.sourceCardId,
    required this.destinationCardId,
    required this.dateRange,
  });

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      type: json['type'],
      status: json['status'],
      currency: json['currency'],
      sourceCurrency: json['sourceCurrency'],
      destinationCurrency: json['destinationCurrency'],
      cardId: json['cardId'],
      sourceCardId: json['sourceCardId'],
      destinationCardId: json['destinationCardId'],
      dateRange: DateRange.fromJson(json['dateRange'] ?? {}),
    );
  }
}

class DateRange {
  final dynamic start;
  final dynamic end;

  DateRange({required this.start, required this.end});

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      start: json['start'],
      end: json['end'],
    );
  }
}

class Transaction {
  final String transactionId;
  final String type;
  final String status;
  final int? amount;
  final String? currency;
  final DateTime createdAt;
  final String? cardId;
  final String? reference;
  final Metadata metadata;
  final int? amountDebited;
  final double? amountCredited;
  final String? sourceCurrency;
  final String? destinationCurrency;
  final double? exchangeRate;
  final String? sourceCardId;
  final String? destinationCardId;

  Transaction({
    required this.transactionId,
    required this.type,
    required this.status,
    this.amount,
    this.currency,
    required this.createdAt,
    this.cardId,
    required this.reference,
    required this.metadata,
    this.amountDebited,
    this.amountCredited,
    this.sourceCurrency,
    this.destinationCurrency,
    this.exchangeRate,
    this.sourceCardId,
    this.destinationCardId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      amount: json['amount'],
      currency: json['currency'],
      createdAt: DateTime.parse(json['createdAt']),
      cardId: json['cardId'],
      reference: json['reference'] ?? '',
      metadata: Metadata.fromJson(json['metadata'] ?? {}),
      amountDebited: json['amountDebited'],
      amountCredited: (json['amountCredited'] is int)
          ? (json['amountCredited'] as int).toDouble()
          : (json['amountCredited'] as num?)?.toDouble(),
      sourceCurrency: json['sourceCurrency'],
      destinationCurrency: json['destinationCurrency'],
      exchangeRate: (json['exchangeRate'] is int)
          ? (json['exchangeRate'] as int).toDouble()
          : (json['exchangeRate'] as num?)?.toDouble(),
      sourceCardId: json['sourceCardId'],
      destinationCardId: json['destinationCardId'],
    );
  }
}

class Metadata {
  final String? userId;
  final String? cardId;

  Metadata({this.userId, this.cardId});

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      userId: json['userId'],
      cardId: json['cardId'],
    );
  }
}
