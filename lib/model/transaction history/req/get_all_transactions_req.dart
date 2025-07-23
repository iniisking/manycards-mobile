class GetAllTransactionsReq {
  final String? currency;
  final String? type;
  final String? status;
  final String? cardId;
  final String? startDate;
  final String? endDate;
  final int? limit;
  final String? nextToken;

  GetAllTransactionsReq({
    this.currency,
    this.type,
    this.status,
    this.cardId,
    this.startDate,
    this.endDate,
    this.limit,
    this.nextToken,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (currency != null) data['currency'] = currency;
    if (type != null) data['type'] = type;
    if (status != null) data['status'] = status;
    if (cardId != null) data['card_id'] = cardId;
    if (startDate != null) data['start_date'] = startDate;
    if (endDate != null) data['end_date'] = endDate;
    if (limit != null) data['limit'] = limit;
    if (nextToken != null) data['next_token'] = nextToken;
    
    return data;
  }
} 