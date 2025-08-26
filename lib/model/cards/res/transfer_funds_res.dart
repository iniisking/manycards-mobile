class TransferFundsRes {
  final bool success;
  final String sourceCardId;
  final String destinationCardId;
  final double amountDebited;
  final double amountCredited;
  final String sourceCurrency;
  final String destinationCurrency;
  final double newBalance;
  final double exchangeRate;
  final String transactionId;
  final String message;

  TransferFundsRes({
    required this.success,
    required this.sourceCardId,
    required this.destinationCardId,
    required this.amountDebited,
    required this.amountCredited,
    required this.sourceCurrency,
    required this.destinationCurrency,
    required this.newBalance,
    required this.exchangeRate,
    required this.transactionId,
    required this.message,
  });

  factory TransferFundsRes.fromJson(Map<String, dynamic> json) {
    return TransferFundsRes(
      success: json['success'] ?? false,
      sourceCardId: json['source_card_id'] ?? '',
      destinationCardId: json['destination_card_id'] ?? '',
      amountDebited: (json['amount_debited'] ?? 0.0).toDouble(),
      amountCredited: (json['amount_credited'] ?? 0.0).toDouble(),
      sourceCurrency: json['source_currency'] ?? '',
      destinationCurrency: json['destination_currency'] ?? '',
      newBalance: (json['new_balance'] ?? 0.0).toDouble(),
      exchangeRate: (json['exchange_rate'] ?? 0.0).toDouble(),
      transactionId: json['transaction_id'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
