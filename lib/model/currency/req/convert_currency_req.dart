class ConvertCurrencyReq {
  final double amount;
  final String fromCurrency;
  final String toCurrency;

  ConvertCurrencyReq({
    required this.amount,
    required this.fromCurrency,
    required this.toCurrency,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
    };
  }
}
