class FundAccountReq {
  final String cardId;
  final double amount;

  FundAccountReq({required this.cardId, required this.amount});

  Map<String, dynamic> toJson() {
    return {'card_id': cardId, 'amount': amount.toString()};
  }
}
