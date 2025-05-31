class ConvertCurrencyRes {
  final bool error;
  final bool success;
  final String message;
  final Data data;

  ConvertCurrencyRes({
    required this.error,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ConvertCurrencyRes.fromJson(Map<String, dynamic> json) {
    return ConvertCurrencyRes(
      error: json['error'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: Data.fromJson(json['data'] ?? {}),
    );
  }
}

class Data {
  final double originalAmount;
  final double convertedAmount;
  final String fromCurrency;
  final String toCurrency;
  final double exchangeRate;
  final String timestamp;

  Data({
    required this.originalAmount,
    required this.convertedAmount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.exchangeRate,
    required this.timestamp,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      originalAmount: (json['original_amount'] ?? 0.0).toDouble(),
      convertedAmount: (json['converted_amount'] ?? 0.0).toDouble(),
      fromCurrency: json['from_currency'] ?? '',
      toCurrency: json['to_currency'] ?? '',
      exchangeRate: (json['exchange_rate'] ?? 0.0).toDouble(),
      timestamp: json['timestamp'] ?? '',
    );
  }
}
