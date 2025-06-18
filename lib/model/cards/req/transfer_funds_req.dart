class TransferFundsReq {
  final String sourceCardId;
  final String destinationCardId;
  final double amount;
  final String sourceCurrency;
  final String destinationCurrency;

  TransferFundsReq({
    required this.sourceCardId,
    required this.destinationCardId,
    required this.amount,
    required this.sourceCurrency,
    required this.destinationCurrency,
  });
}
