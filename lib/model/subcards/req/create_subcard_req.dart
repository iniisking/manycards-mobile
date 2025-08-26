class CreateSubcardReq {
  final String mainCardId;
  final String color;
  final String name;
  final String merchantName;
  final String merchantId;
  final int spendingLimit;
  final int durationDays;
  final bool resume;

  CreateSubcardReq({
    required this.mainCardId,
    required this.color,
    required this.name,
    required this.merchantName,
    required this.merchantId,
    required this.spendingLimit,
    required this.durationDays,
    required this.resume,
  });
}

Map<String, dynamic> createSubcardReqToJson(CreateSubcardReq req) {
  return {
    'main_card_id': req.mainCardId,
    'color': req.color,
    'name': req.name,
    'merchant_name': req.merchantName,
    'merchant_id': req.merchantId,
    'spending_limit': req.spendingLimit,
    'duration_days': req.durationDays,
    'resume': req.resume,
  };
}
